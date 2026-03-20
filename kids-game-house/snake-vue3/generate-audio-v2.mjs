/**
 * 简易音频生成器 - 生成兼容性更好的 WAV 文件
 * 确保生成的 WAV 文件被所有浏览器正确解码
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const AUDIO_DIR = path.join(__dirname, 'public/assets/themes/snake/audio');

// 确保目录存在
if (!fs.existsSync(AUDIO_DIR)) {
  fs.mkdirSync(AUDIO_DIR, { recursive: true });
}

/**
 * 生成标准 WAV 文件
 */
function createWAV(samples, sampleRate = 44100, numChannels = 1) {
  const bitsPerSample = 16;
  const byteRate = sampleRate * numChannels * (bitsPerSample / 8);
  const blockAlign = numChannels * (bitsPerSample / 8);
  const dataSize = samples.length * 2; // 16-bit = 2 bytes per sample
  const fileSize = 36 + dataSize;

  const buffer = Buffer.alloc(44 + dataSize);
  let offset = 0;

  // RIFF Header
  buffer.write('RIFF', offset); offset += 4;
  buffer.writeUInt32LE(fileSize, offset); offset += 4;
  buffer.write('WAVE', offset); offset += 4;

  // fmt Subchunk
  buffer.write('fmt ', offset); offset += 4;
  buffer.writeUInt32LE(16, offset); offset += 4;      // Subchunk1Size (16 for PCM)
  buffer.writeUInt16LE(1, offset); offset += 2;       // AudioFormat (1 = PCM)
  buffer.writeUInt16LE(numChannels, offset); offset += 2;
  buffer.writeUInt32LE(sampleRate, offset); offset += 4;
  buffer.writeUInt32LE(byteRate, offset); offset += 4;
  buffer.writeUInt16LE(blockAlign, offset); offset += 2;
  buffer.writeUInt16LE(bitsPerSample, offset); offset += 2;

  // data Subchunk
  buffer.write('data', offset); offset += 4;
  buffer.writeUInt32LE(dataSize, offset); offset += 4;

  // Write samples (16-bit signed integers)
  for (let i = 0; i < samples.length; i++) {
    const sample = Math.max(-1, Math.min(1, samples[i]));
    const intSample = Math.floor(sample * 32767);
    buffer.writeInt16LE(intSample, offset);
    offset += 2;
  }

  return buffer;
}

/**
 * 生成正弦波采样
 */
function sineWave(duration, frequency, sampleRate = 44100, volume = 0.5, fadeIn = 0.01, fadeOut = 0.05) {
  const numSamples = Math.floor(duration * sampleRate);
  const fadeInSamples = Math.floor(fadeIn * sampleRate);
  const fadeOutSamples = Math.floor(fadeOut * sampleRate);
  const samples = [];

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    let amp = 1;

    // Fade in
    if (i < fadeInSamples) {
      amp = i / fadeInSamples;
    }
    // Fade out
    else if (i > numSamples - fadeOutSamples) {
      amp = (numSamples - i) / fadeOutSamples;
    }

    const sample = Math.sin(2 * Math.PI * frequency * t) * volume * amp;
    samples.push(sample);
  }

  return samples;
}

/**
 * 生成双音调（频率跳跃）
 */
function dualTone(duration, freq1, freq2, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const halfSamples = Math.floor(numSamples / 2);
  const samples = [];

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const freq = i < halfSamples ? freq1 : freq2;
    
    // Fade envelope
    const fadeOut = i > numSamples * 0.7 ? (numSamples - i) / (numSamples * 0.3) : 1;
    const fadeIn = i < numSamples * 0.1 ? i / (numSamples * 0.1) : 1;
    const amp = fadeIn * fadeOut;

    const sample = Math.sin(2 * Math.PI * freq * t) * volume * amp;
    samples.push(sample);
  }

  return samples;
}

/**
 * 生成上升音调（用于升级/得分）
 */
function risingTone(duration, startFreq, endFreq, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const samples = [];

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const progress = i / numSamples;
    const freq = startFreq + (endFreq - startFreq) * progress;
    
    // Smooth envelope
    const envelope = Math.sin(progress * Math.PI);
    const sample = Math.sin(2 * Math.PI * freq * t) * volume * envelope;
    samples.push(sample);
  }

  return samples;
}

/**
 * 生成下降音调（用于游戏结束）
 */
function fallingTone(duration, startFreq, endFreq, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const samples = [];

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const progress = i / numSamples;
    const freq = startFreq + (endFreq - startFreq) * progress;
    
    const envelope = 1 - progress * 0.3;
    const sample = Math.sin(2 * Math.PI * freq * t) * volume * envelope;
    samples.push(sample);
  }

  return samples;
}

/**
 * 生成噪音
 */
function noise(duration, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const samples = [];

  for (let i = 0; i < numSamples; i++) {
    const progress = i / numSamples;
    const envelope = 1 - progress;
    const sample = (Math.random() * 2 - 1) * volume * envelope;
    samples.push(sample);
  }

  return samples;
}

/**
 * 生成简单旋律
 */
function melody(notes, noteDuration, sampleRate = 44100, volume = 0.5) {
  const samples = [];
  const samplesPerNote = Math.floor(noteDuration * sampleRate);

  for (const freq of notes) {
    for (let i = 0; i < samplesPerNote; i++) {
      const t = i / sampleRate;
      
      // Note envelope
      const attack = Math.min(1, i / (samplesPerNote * 0.1));
      const decay = Math.min(1, (samplesPerNote - i) / (samplesPerNote * 0.2));
      const envelope = attack * decay;

      const sample = Math.sin(2 * Math.PI * freq * t) * volume * envelope;
      samples.push(sample);
    }
  }

  return samples;
}

console.log('🎵 生成音频资源...\n');

// 背景音乐 - 简单旋律
const bgmNotes = [440, 494, 523, 587, 523, 494, 440, 392]; // A4, B4, C5, D5, C5, B4, A4, G4
const bgmMainSamples = melody(bgmNotes, 0.4, 44100, 0.4);
fs.writeFileSync(path.join(AUDIO_DIR, 'bgm_main.wav'), createWAV(bgmMainSamples));
console.log('✅ bgm_main.wav');

const bgmGameplayNotes = [523, 587, 659, 698, 659, 587, 523, 494]; // C5, D5, E5, F5, E5, D5, C5, B4
const bgmGameplaySamples = melody(bgmGameplayNotes, 0.5, 44100, 0.4);
fs.writeFileSync(path.join(AUDIO_DIR, 'bgm_gameplay.wav'), createWAV(bgmGameplaySamples));
console.log('✅ bgm_gameplay.wav');

const bgmGameoverNotes = [392, 349, 330, 294]; // G4, F4, E4, D4
const bgmGameoverSamples = melody(bgmGameoverNotes, 0.5, 44100, 0.5);
fs.writeFileSync(path.join(AUDIO_DIR, 'bgm_gameover.wav'), createWAV(bgmGameoverSamples));
console.log('✅ bgm_gameover.wav');

// 音效
const buttonClickSamples = dualTone(0.1, 800, 1000, 44100, 0.3);
fs.writeFileSync(path.join(AUDIO_DIR, 'button_click.wav'), createWAV(buttonClickSamples));
console.log('✅ button_click.wav');

const crashSamples = noise(0.2, 44100, 0.4);
fs.writeFileSync(path.join(AUDIO_DIR, 'crash.wav'), createWAV(crashSamples));
console.log('✅ crash.wav');

const eatSamples = sineWave(0.15, 880, 44100, 0.4, 0.01, 0.05);
fs.writeFileSync(path.join(AUDIO_DIR, 'eat.wav'), createWAV(eatSamples));
console.log('✅ eat.wav');

const gameoverSamples = fallingTone(0.5, 440, 220, 44100, 0.5);
fs.writeFileSync(path.join(AUDIO_DIR, 'gameover.wav'), createWAV(gameoverSamples));
console.log('✅ gameover.wav');

const levelupSamples = risingTone(0.3, 440, 880, 44100, 0.5);
fs.writeFileSync(path.join(AUDIO_DIR, 'levelup.wav'), createWAV(levelupSamples));
console.log('✅ levelup.wav');

console.log('\n✨ 音频生成完成！');

/**
 * 稳定音频生成器 - 生成确保能被浏览器解码的 WAV 文件
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const AUDIO_DIR = path.join(__dirname, 'public/assets/themes/snake/audio');

if (!fs.existsSync(AUDIO_DIR)) {
  fs.mkdirSync(AUDIO_DIR, { recursive: true });
}

/**
 * 生成标准 PCM WAV 文件
 */
function createWAV(samples, sampleRate = 44100, numChannels = 1) {
  const bitsPerSample = 16;
  const byteRate = sampleRate * numChannels * (bitsPerSample / 8);
  const blockAlign = numChannels * (bitsPerSample / 8);
  const dataSize = samples.length * 2;
  const fileSize = 36 + dataSize;

  const buffer = Buffer.alloc(44 + dataSize);
  let offset = 0;

  // RIFF Header
  buffer.write('RIFF', offset); offset += 4;
  buffer.writeUInt32LE(fileSize, offset); offset += 4;
  buffer.write('WAVE', offset); offset += 4;

  // fmt chunk
  buffer.write('fmt ', offset); offset += 4;
  buffer.writeUInt32LE(16, offset); offset += 4;
  buffer.writeUInt16LE(1, offset); offset += 2;        // PCM
  buffer.writeUInt16LE(numChannels, offset); offset += 2;
  buffer.writeUInt32LE(sampleRate, offset); offset += 4;
  buffer.writeUInt32LE(byteRate, offset); offset += 4;
  buffer.writeUInt16LE(blockAlign, offset); offset += 2;
  buffer.writeUInt16LE(bitsPerSample, offset); offset += 2;

  // data chunk
  buffer.write('data', offset); offset += 4;
  buffer.writeUInt32LE(dataSize, offset); offset += 4;

  // 写入采样数据
  for (let i = 0; i < samples.length; i++) {
    const sample = Math.max(-32768, Math.min(32767, Math.floor(samples[i] * 32767)));
    buffer.writeInt16LE(sample, offset);
    offset += 2;
  }

  return buffer;
}

/**
 * 生成平滑的正弦波（带包络）
 */
function smoothSine(duration, frequency, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const samples = new Float32Array(numSamples);

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    // 使用平滑的包络曲线
    const envelope = Math.sin((i / numSamples) * Math.PI);
    samples[i] = Math.sin(2 * Math.PI * frequency * t) * volume * envelope;
  }

  return samples;
}

/**
 * 生成双音调（两个频率）
 */
function twoTones(duration, freq1, freq2, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const halfPoint = Math.floor(numSamples / 2);
  const samples = new Float32Array(numSamples);

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const freq = i < halfPoint ? freq1 : freq2;
    const envelope = Math.sin((i / numSamples) * Math.PI);
    samples[i] = Math.sin(2 * Math.PI * freq * t) * volume * envelope;
  }

  return samples;
}

/**
 * 生成上升音调
 */
function risingSweep(duration, startFreq, endFreq, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const samples = new Float32Array(numSamples);

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const progress = i / numSamples;
    const freq = startFreq + (endFreq - startFreq) * progress;
    const envelope = Math.sin(progress * Math.PI);
    samples[i] = Math.sin(2 * Math.PI * freq * t) * volume * envelope;
  }

  return samples;
}

/**
 * 生成下降音调
 */
function fallingSweep(duration, startFreq, endFreq, sampleRate = 44100, volume = 0.5) {
  const numSamples = Math.floor(duration * sampleRate);
  const samples = new Float32Array(numSamples);

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const progress = i / numSamples;
    const freq = startFreq + (endFreq - startFreq) * progress;
    const envelope = 1 - progress * 0.5;
    samples[i] = Math.sin(2 * Math.PI * freq * t) * volume * envelope;
  }

  return samples;
}

/**
 * 生成白噪音
 */
function whiteNoise(duration, sampleRate = 44100, volume = 0.3) {
  const numSamples = Math.floor(duration * sampleRate);
  const samples = new Float32Array(numSamples);

  for (let i = 0; i < numSamples; i++) {
    const envelope = 1 - (i / numSamples);
    samples[i] = (Math.random() * 2 - 1) * volume * envelope;
  }

  return samples;
}

/**
 * 生成简单旋律（多个音符）
 */
function simpleMelody(notes, noteDuration, sampleRate = 44100, volume = 0.4) {
  const samplesPerNote = Math.floor(noteDuration * sampleRate);
  const totalSamples = notes.length * samplesPerNote;
  const samples = new Float32Array(totalSamples);

  let offset = 0;
  for (const freq of notes) {
    for (let i = 0; i < samplesPerNote; i++) {
      const t = i / sampleRate;
      // 音符包络（攻击-衰减）
      const attack = Math.min(1, i / (samplesPerNote * 0.1));
      const decay = Math.max(0, 1 - (i / samplesPerNote) * 0.3);
      const envelope = attack * decay;
      samples[offset + i] = Math.sin(2 * Math.PI * freq * t) * volume * envelope;
    }
    offset += samplesPerNote;
  }

  return samples;
}

console.log('🎵 生成音频资源 (v3)...\n');

// 背景音乐 - 简单旋律
const bgmMainNotes = [440, 494, 523, 587, 523, 494, 440, 392];
fs.writeFileSync(path.join(AUDIO_DIR, 'bgm_main.wav'), createWAV(simpleMelody(bgmMainNotes, 0.4)));
console.log('✅ bgm_main.wav');

const bgmGameplayNotes = [523, 587, 659, 698, 659, 587, 523, 494];
fs.writeFileSync(path.join(AUDIO_DIR, 'bgm_gameplay.wav'), createWAV(simpleMelody(bgmGameplayNotes, 0.5)));
console.log('✅ bgm_gameplay.wav');

const bgmGameoverNotes = [392, 349, 330, 294];
fs.writeFileSync(path.join(AUDIO_DIR, 'bgm_gameover.wav'), createWAV(simpleMelody(bgmGameoverNotes, 0.5)));
console.log('✅ bgm_gameover.wav');

// 音效
fs.writeFileSync(path.join(AUDIO_DIR, 'button_click.wav'), createWAV(twoTones(0.1, 800, 1000, 44100, 0.3)));
console.log('✅ button_click.wav');

fs.writeFileSync(path.join(AUDIO_DIR, 'crash.wav'), createWAV(whiteNoise(0.2)));
console.log('✅ crash.wav');

fs.writeFileSync(path.join(AUDIO_DIR, 'eat.wav'), createWAV(smoothSine(0.15, 880, 44100, 0.4)));
console.log('✅ eat.wav');

fs.writeFileSync(path.join(AUDIO_DIR, 'gameover.wav'), createWAV(fallingSweep(0.5, 440, 220)));
console.log('✅ gameover.wav');

fs.writeFileSync(path.join(AUDIO_DIR, 'levelup.wav'), createWAV(risingSweep(0.3, 440, 880)));
console.log('✅ levelup.wav');

console.log('\n✨ 音频生成完成！');
console.log('\n提示: 请刷新浏览器测试。如果仍有问题，请检查浏览器控制台的具体错误信息。');

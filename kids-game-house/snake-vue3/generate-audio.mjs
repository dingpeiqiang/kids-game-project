/**
 * 音频资源生成器 - 使用 wav 库生成标准 WAV 文件
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { Writable } from 'stream';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const AUDIO_DIR = path.join(__dirname, 'public/assets/themes/snake/audio');

// 确保目录存在
if (!fs.existsSync(AUDIO_DIR)) {
  fs.mkdirSync(AUDIO_DIR, { recursive: true });
}

// 简单的 WAV 写入器（不依赖外部库）
class WavWriter {
  constructor(sampleRate = 44100, channels = 1, bitsPerSample = 16) {
    this.sampleRate = sampleRate;
    this.channels = channels;
    this.bitsPerSample = bitsPerSample;
    this.samples = [];
  }

  // 添加采样数据
  addSample(sample) {
    // 限制范围
    const clamped = Math.max(-1, Math.min(1, sample));
    this.samples.push(clamped);
  }

  // 生成 WAV 文件
  toBuffer() {
    const numSamples = this.samples.length;
    const dataSize = numSamples * this.channels * (this.bitsPerSample / 8);
    const fileSize = 36 + dataSize;

    const buffer = Buffer.alloc(44 + dataSize);
    let offset = 0;

    // RIFF header
    buffer.write('RIFF', offset); offset += 4;
    buffer.writeUInt32LE(fileSize, offset); offset += 4;
    buffer.write('WAVE', offset); offset += 4;

    // fmt chunk
    buffer.write('fmt ', offset); offset += 4;
    buffer.writeUInt32LE(16, offset); offset += 4; // chunk size
    buffer.writeUInt16LE(1, offset); offset += 2;   // PCM format
    buffer.writeUInt16LE(this.channels, offset); offset += 2;
    buffer.writeUInt32LE(this.sampleRate, offset); offset += 4;
    buffer.writeUInt32LE(this.sampleRate * this.channels * (this.bitsPerSample / 8), offset); offset += 4; // byte rate
    buffer.writeUInt16LE(this.channels * (this.bitsPerSample / 8), offset); offset += 2; // block align
    buffer.writeUInt16LE(this.bitsPerSample, offset); offset += 2;

    // data chunk
    buffer.write('data', offset); offset += 4;
    buffer.writeUInt32LE(dataSize, offset); offset += 4;

    // 写入采样数据
    for (let i = 0; i < numSamples; i++) {
      const sample = this.samples[i];
      const value = Math.floor(sample * 32767);
      buffer.writeInt16LE(Math.max(-32768, Math.min(32767, value)), offset);
      offset += 2;
    }

    return buffer;
  }
}

/**
 * 生成正弦波
 */
function generateSineWave(duration, frequency, sampleRate = 44100, volume = 0.5) {
  const writer = new WavWriter(sampleRate);
  const numSamples = Math.floor(duration * sampleRate);

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    // 正弦波 + 渐弱效果
    const fadeOut = 1 - (i / numSamples) * 0.3;
    const sample = Math.sin(2 * Math.PI * frequency * t) * volume * fadeOut;
    writer.addSample(sample);
  }

  return writer.toBuffer();
}

/**
 * 生成方波
 */
function generateSquareWave(duration, frequency, sampleRate = 44100, volume = 0.5) {
  const writer = new WavWriter(sampleRate);
  const numSamples = Math.floor(duration * sampleRate);

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const fadeOut = 1 - (i / numSamples) * 0.3;
    const sample = Math.sign(Math.sin(2 * Math.PI * frequency * t)) * volume * fadeOut;
    writer.addSample(sample);
  }

  return writer.toBuffer();
}

/**
 * 生成噪音
 */
function generateNoise(duration, sampleRate = 44100, volume = 0.5) {
  const writer = new WavWriter(sampleRate);
  const numSamples = Math.floor(duration * sampleRate);

  for (let i = 0; i < numSamples; i++) {
    const fadeOut = 1 - (i / numSamples) * 0.5;
    const sample = (Math.random() * 2 - 1) * volume * fadeOut;
    writer.addSample(sample);
  }

  return writer.toBuffer();
}

/**
 * 生成简单旋律
 */
function generateMelody(duration, baseFrequency, sampleRate = 44100, volume = 0.5) {
  const writer = new WavWriter(sampleRate);
  const numSamples = Math.floor(duration * sampleRate);
  
  // 简单的音阶：Do Re Mi Fa
  const notes = [1, 1.125, 1.25, 1.125];
  const noteLength = numSamples / notes.length;

  let sampleIndex = 0;
  for (let noteIdx = 0; noteIdx < notes.length; noteIdx++) {
    const freq = baseFrequency * notes[noteIdx];
    const noteEnd = Math.min((noteIdx + 1) * noteLength, numSamples);
    
    while (sampleIndex < noteEnd) {
      const t = sampleIndex / sampleRate;
      const noteProgress = (sampleIndex - noteIdx * noteLength) / noteLength;
      const fadeOut = 1 - noteProgress * 0.2;
      const sample = Math.sin(2 * Math.PI * freq * t) * volume * fadeOut;
      writer.addSample(sample);
      sampleIndex++;
    }
  }

  return writer.toBuffer();
}

/**
 * 生成双音调（用于提示音）
 */
function generateDualTone(duration, freq1, freq2, sampleRate = 44100, volume = 0.5) {
  const writer = new WavWriter(sampleRate);
  const numSamples = Math.floor(duration * sampleRate);

  for (let i = 0; i < numSamples; i++) {
    const t = i / sampleRate;
    const fadeOut = 1 - (i / numSamples) * 0.3;
    const sample = (
      Math.sin(2 * Math.PI * freq1 * t) * 0.5 +
      Math.sin(2 * Math.PI * freq2 * t) * 0.5
    ) * volume * fadeOut;
    writer.addSample(sample);
  }

  return writer.toBuffer();
}

// 音频配置
const audioConfigs = [
  // 背景音乐
  { name: 'bgm_main.wav', generator: generateMelody, args: [3.0, 440, 44100, 0.4] },
  { name: 'bgm_gameplay.wav', generator: generateMelody, args: [4.0, 523, 44100, 0.4] },
  { name: 'bgm_gameover.wav', generator: generateMelody, args: [2.0, 330, 44100, 0.4] },
  
  // 音效
  { name: 'button_click.wav', generator: generateDualTone, args: [0.15, 800, 1000, 44100, 0.3] },
  { name: 'crash.wav', generator: generateNoise, args: [0.3, 44100, 0.5] },
  { name: 'eat.wav', generator: generateSineWave, args: [0.2, 880, 44100, 0.4] },
  { name: 'gameover.wav', generator: generateSquareWave, args: [0.5, 440, 44100, 0.5] },
  { name: 'levelup.wav', generator: generateDualTone, args: [0.4, 660, 880, 44100, 0.5] },
];

console.log('🎵 生成音频资源...\n');

for (const config of audioConfigs) {
  const buffer = config.generator(...config.args);
  const filepath = path.join(AUDIO_DIR, config.name);
  fs.writeFileSync(filepath, buffer);
  console.log(`✅ ${config.name} (${buffer.length} bytes)`);
}

console.log('\n✨ 音频生成完成！');

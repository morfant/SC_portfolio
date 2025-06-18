(
// Additive Synth Example
SynthDef(\creativeAddSynth, { |freq = 220, amp = 0.2, atk = 2, sus = 10, rel = 3|
	var sig, env, numPartials, freqs, amps, detune, mod, pan;

	numPartials = 16;

	// 음색 구조 정의: harmonic (1, 2, 3..) 혹은 inharmonic(비정수 배율)
	freqs = Array.fill(numPartials, { |i|
		freq * (i + 1 + LFNoise1.kr(0.2).range(-0.05, 0.05)) // 미세한 inharmonic detune 추가
	});

	// 각 부분음의 진폭을 동적으로 조정하여 창의적 음색을 생성
	amps = Array.fill(numPartials, { |i|
		(1 / (i + 1)) * LFNoise2.kr(Rand(0.1, 0.4)).range(0.3, 1.0)
	});

	// 위상 변화를 주어 움직임이 풍부한 음색 생성
	mod = Array.fill(numPartials, {
		LFNoise1.kr(Rand(0.05, 0.2)).range(0, 2pi)
	});

	pan = Array.fill(numPartials, {|i|
		if (i % 2 == 0, {
			// SinOsc.ar((2 + i)/3)
			VarSaw.ar((2 + i)/3, width: 0.2) // 비대칭적인 변화
		}, {
			// SinOsc.ar((2 + i)/3, pi);
			VarSaw.ar((2 + i)/3, 0.5, width: 0.2)
		});
	});

	// 사인파 합성
	sig = Mix.fill(numPartials, { |i|
		Pan2.ar(SinOsc.ar(freqs[i], mod[i]) * amps[i], pan[i])
	});

	// 엔벨로프: 소리의 진화(attack, sustain, release)
	env = EnvGen.kr(
		Env([0, 1, 0.7, 0], [atk, sus, rel], 'sin'), doneAction: 2
	);

	sig = sig * env * amp;

	// 공간적 배치 추가 (optional)
	// sig = Pan2.ar(sig, 0);
	sig;

	Out.ar(0, sig);
}).add;
)

// Synth를 실행하는 코드 (다양한 소리 실험)
Synth(\creativeAddSynth, [\freq, 120]); // 저음역 음색 탐구
Synth(\creativeAddSynth, [\freq, 440]); // 중음역 음색 탐구
Synth(\creativeAddSynth, [\freq, 880, \amp, 0.1]); // 고음역 음색 탐구



(
{
	var trig, freq;

	trig = LFPulse.kr(2, 0, 0.1, 0.5, -0.1);
	freq = (trig >= 0).if(200, 700);

	SinOsc.ar(freq.lag(0.2), mul: 0.2);
}.play
)
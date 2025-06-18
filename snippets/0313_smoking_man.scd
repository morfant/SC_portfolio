// 250313
// 공사장 앞에서 담배 피우는 외국인 노동자 (남자)
// 사람들이 모여 있고, 이 남자는 조금 외떨어져 있다.

{SinOsc.ar(Array.series(30, 100, 40)).sum * 0.02 !2}.play


Array.series(30, 100, 1.5);
Array.geom();

({ // 1. Test
	var lfo = LFNoise0.ar(1/2).range(-50, 50);

	SinOsc.ar(Array.series(5, 100, lfo).poll(10), mul: 0.1)!2
	// SinOsc.ar([lfo, lfo * 2].poll(10), mul: 0.1)!2
}.play
)


( // 2. Base
{
	arg gate = 1, amp = 0.9, freq = 400;
	var sig, env, mods, trigR, freqAdd = [10, -200, -150];

	mods = [
		LFNoise2.ar(1/4).range(0.5, 1.5),
		LFNoise2.ar(1/6).range(0.5, 1.5),
		LFNoise2.ar(1/7).range(0.5, 1.5)
	];
	// mods = LFNoise2.ar(1/4).range(0.5, 1.5).dup(3); // mods를 통일하고 싶다면 주석 해제 할 것
	sig = FSinOsc.ar(freqAdd[0] + Array.series(30, freq, mods[0]), mul: 1/80).sum; // Array의 내용이 갱신된다
	sig = sig + FSinOsc.ar(freqAdd[1] + Array.series(30, freq, mods[1]), mul: 1/90).sum;
	sig = sig + FSinOsc.ar(freqAdd[2] + Array.series(30, freq, mods[2]), mul: 1/100).sum;

	sig = Limiter.ar(sig, 0.7);

	Out.ar(0, Pan2.ar(sig), amp);
}.play;
)



(// 2. mods를 상수로 고정 - 더 명확하고 제어 가능한 배음간 맥놀이 주기
{
	arg gate = 1, amp = 0.9, freq = 400;
	var sig, env, mods, trigR, freqAdd = [10, -200, -150];

	mods = [
		1, 2, 3
	];
	// 1.Test에서 확인한 것 처럼, Array의 내용이 갱신된다
	sig = FSinOsc.ar(freqAdd[0] + Array.series(30, freq, mods[0]), mul: 1/80).sum;
	sig = sig + FSinOsc.ar(freqAdd[1] + Array.series(30, freq, mods[1]), mul: 1/90).sum;
	sig = sig + FSinOsc.ar(freqAdd[2] + Array.series(30, freq, mods[2]), mul: 1/100).sum;

	sig = Limiter.ar(sig, 0.9);

	Out.ar(0, Pan2.ar(sig), amp);
}.play;
)


(// 3. mods를 아규먼트로 만들어 외부에서 제어 가능 하도록
SynthDef.new(\smokingMan, {
	arg mods = #[1, 2, 3], gate = 1, amp = 0.9, freq = 400;
	var sig, env, trigR, freqAdd = [10, -200, -150];

	sig = FSinOsc.ar(freqAdd[0] + Array.series(30, freq, mods[0]), mul: 1/80).sum;
	sig = sig + FSinOsc.ar(freqAdd[1] + Array.series(30, freq, mods[1]), mul: 1/90).sum;
	sig = sig + FSinOsc.ar(freqAdd[2] + Array.series(30, freq, mods[2]), mul: 1/100).sum;

	sig = Limiter.ar(sig, 0.9);

	Out.ar(0, Pan2.ar(sig), amp);
}).add;
)

a = Synth(\smokingMan);
a.set(\mods, [1, 3, 2])
a.set(\mods, ~func.())


(// 피보나치 수열을 구성하는 수들 중 구간별로 세 개를 뽑아 뒤섞는 함수
~result = nil;
~arrFib = Array.fib(10)/10;
~rotated = ~arrFib;
~func = {
	~rotated = ~rotated.rotate(-3);
	~result = ~rotated[3..5].scramble.postln;
};
)


(// 일정 범위의 3개의 수를 중복없이 구하는 함수
~func2 = {
	var list = (-30..30) * 10;
	list = list.scramble[3..5];
	(list).postln;
};
)

~func2.()


(// 4. freqAdd를 아규먼트로 만들어 외부에서 제어 가능 하도록
SynthDef.new(\smokingMan, {
	arg mods = #[1, 2, 3], freqAdd = #[10, -200, -150], gate = 1, amp = 0.9, freq = 400;
	var sig, env, trigR;
	env = EnvGen.kr(Env.asr(), gate, doneAction: 2);
	sig = FSinOsc.ar(freqAdd[0] + Array.series(30, freq, mods[0]), mul: 1/80).sum;
	sig = sig + FSinOsc.ar(freqAdd[1] + Array.series(30, freq, mods[1]), mul: 1/90).sum;
	sig = sig + FSinOsc.ar(freqAdd[2] + Array.series(30, freq, mods[2]), mul: 1/100).sum;

	sig = Limiter.ar(sig, 0.9);

	Out.ar(0, Pan2.ar(sig * env), amp);
}, [5.0, 5.0]).add; // SynthDef의 rate 아규먼트 사용
)

a = Synth(\smokingMan);
a.set(\mods, ~func.());
a.set(\freqAdd, ~func2.());


(
a = Synth(\smokingMan);

r{
	4.0.wait;
	10.do{
		1.0 + (4.0.rand).wait;

		a.set(\mods, ~func.());
		if(0.5.coin.postln, {
			a.set(\freqAdd, ~func2.());
		});

		(6.0 + 2.0.rand).wait;
	};

	"Fin.".postln;

	a.release(20);
}.play;
)

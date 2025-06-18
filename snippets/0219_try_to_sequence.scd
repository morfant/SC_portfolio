
// Error case 1: 배열의 크기는 동적으로 할당 불가
(
SynthDef(\lone,
	{
		arg n = 20, freq = 150, parAmp = 0.05, amp = 0.3;
		var harmonics, env;
		harmonics = Mix.fill(n, {|i|
			var overtone = (i + 1) * (1 + i.rand * parAmp);
			SinOsc.ar(freq * overtone, mul: amp / (i + 1))
		});
		env = EnvGen.kr(Env.perc(0.1, 3), doneAction: 2);
		Pan2.ar(harmonics * env, 0);
	}
).add;
)

SuperCollider’s server isn’t set up for dynamic array sizes.
If an array size isn’t a compile-time constant,
an error might pop up due to this persistent restriction.


// 대안: 최대 배열 수를 정하고, 그 안에서 필요한 만큼의 소리를 만든다
(
SynthDef(\lone, {
	arg n = 20, freq = 150, parAmp = 0.05, amp = 0.3;
	var harmonics, env, maxPartials = 32;
	harmonics = Mix.fill(maxPartials, { |i|
		var isActive = (i < n);
		var overtone = (i + 1) * (1 + Rand(0, 2) * parAmp);
		SinOsc.ar(freq * overtone, mul: isActive * (amp / (i + 1)))
	});

	env = EnvGen.kr(Env.perc(0.1, 0.3), doneAction: 2);
	Out.ar(0, Pan2.ar(harmonics * env, 0));
}).add;
)


(// functions
~setA = {Synth(\lone, [\n, 10, \freq, 450 + rand2(1.0), \amp, 0.3])};
~setB = {Synth(\lone, [\n, 8, \freq, 1420 + rand2(1.0), \amp, 0.1])};
~setC = {Synth(\lone, [\n, 32, \freq, 120 + rand2(1.0), \amp, 0.3])};
)


(
~tc = TempoClock.new();
~tc.tempo = 4.0;

r{
	2.do{
		~setA.();
		"A".postln;
		3.0.wait;

		~setA.();
		"B".postln;
		1.0.wait;
		~setA.();
		"C".postln;
		4.0.wait;
	}
}.play(clock: ~tc)
)


(
~randList = Array.fill(20, {|x| rrand(6, 31)});
~walkPaths = 8.fib.mirror2;
~freqList = Array.fill(32, {|x| x = x + 1});

Pbind(
	\instrument, \lone,
	\n, 10,
	\freq, (Pseries(150, 1, inf) + Prand((-1.00, -0.99..1.0), inf)).trace,
	\dur, 2
).play;


Pbind(
	\instrument, \lone,
	\n, 8,
	\freq, (Pseries(1420, 0.5, inf) + Prand((-1.00, -0.99..1.0), inf)).trace,
	\dur, 6,
	\amp, 0.05,
).play;


Pbind(
	\instrument, \lone,
	\n, 32,
	\freq, Pseries(120, 2, inf),
	\dur, 10,
).play;

)



// 미리 함수(또는 실행할 내용)와 해당 이벤트 이후 쉴 시간(dur)을 배열로 정리
(
~tc = TempoClock.new(6); // 템포 클럭(4 bps = 분당 240 BPM 정도)

~score1A = [
	[ ~setA, 2 ],   // ~setA 호출 후 3초 대기
	[ ~setB, 1 ],
	[ ~setC, 3 ],
	[ ~setC, 2 ],
	[ ~setA, 4 ],
	[ ~setA, 1 ]
];


~score1B = [
	[ ~setC, 1 ],
	[ ~setC, 1 ],
	[ ~setC, 2 ],
	[ ~setB, 3 ],
	[ ~setA, 1 ],
	[ ~setA, 5 ]
];


// 병렬 루틴
r {
	// Routine for 1A
	r {
		10.do {
			~score1A.do { |item|
				var func = item[0], dur = item[1];
				func.value;
				dur.wait;
			};
		};
	}.play(~tc);


	// Routine for 1B
	r{
		5.do {
			~score1B.do { |item|
				var func = item[0], dur = item[1];
				func.value;
				dur.wait;
			};
		};

	}.play(~tc);

}.play(clock: ~tc);
)


// todo: 소리 진행 중간에 음색을 변화 시키는 방법들








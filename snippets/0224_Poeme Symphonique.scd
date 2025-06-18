
// (thor magnusson) (c 2007)

// A reinterpretation of the Poème symphonique was composed by György Ligeti (in 1962)
// http://www.youtube.com/watch?v=QCp7bL-AWvw

(
SynthDef(\ligetignome, {arg tempo=1, filterfreq=1000, rq=1.0, amp = 0.4;
	var env, signal;
	var rho, theta, b1, b2;
	b1 = 2 * 0.996839 * cos(0.0931624);
	b2 = 0.996839.squared.neg;
	signal = SOS.ar(Impulse.ar(tempo), 1.0, 0.0, 0.0, b1, b2);
	signal = RHPF.ar(signal, filterfreq, rq);
	Out.ar(0, Pan2.ar(signal, 0, amp));
}).add;
)

a = Synth(\ligetignome)

// and we create 10 different metronomes running in different tempi
// (try with 3 metros or 30 metros)
(
3.do({
	Synth(\ligetignome).set(
		\tempo, (rrand(0.5,1.5)).reciprocal,
		\filterfreq, rrand(2000,4000),
		\rq, rrand(0.3,0.9) )
});
)

// -----------

// and something totally else... ligeti's brother:

(
var trig;
var wait = 4;
Task({
	20.do({
		trig = [1, 1.5].wchoose([0.7, 0.3]);
		{Resonz.ar(Impulse.ar(trig, 0, 50*rrand(5,10)), Rand(200,2000), 0.003) ! 2}.play;
		(wait + rrand(0.1,1)).wait;
		wait = wait - rrand(0.01, 0.2);
	});
	"thank you! you can now stop this program at any point!".postln;
}).play
)

2.min(10)

~buf = Buffer.alloc(s, 2048);
~buf = Buffer.loadDialog(s); // Hat.aiff

~buf.play
~buf.zero;
~buf.plot
(
var numNodes = 20;  // 노드 개수
var minDur = 10.0;    // 최소 지속 시간
var maxDur = 100.0;    // 최대 지속 시간
var makeup = 20.0;
var amp = 0.3;
var durArr = Array.interpolation(numNodes, minDur, maxDur);
var posArr = Array.interpolation(numNodes.min(10), -0.3, 0.3);
// posArr.postln;
durArr.postln;

// 10.do{|i| ~buf.set(i, makeup/16)};
// 5.do({|i| ~buf.set(2048.rand, coin(rand(1.0)).asInteger * 2 - 1 * rrand(1.0, 1.01)); });

// numGroup
// 동시에 멈췄다 나오는 부분이 있는 것이 조금 이상하게 느껴진다.
// 한 그룹당 20개의 노드가 있고 각 노드들은 일정 간격으로 순차 실행 된다.
// 전부 100개의 노드라면 5개의 그룹이 있는데, 각 그룹들이 실행되는 순서는 동시에.

numNodes.do({|i|
	var tempo = rrand(1, 32)/16;
	// var duration = rrand(minDur, maxDur);
	var duration = durArr[i];

	("i/tempo: "+i+"/"+tempo).postln;
	{

		var sig, impL, impR;
		var trig = Impulse.ar(tempo);
		var partials = [0.03, 0.1];
		var count = PulseCount.ar(trig) % 2;
		var index = count > 0;
		impL = Ringz.ar(trig, 654 + (i/10), partials[0]);
		impR = Ringz.ar(trig, 653 + (i/10), partials[1]);

		sig = Select.ar(index,
			[

				// HPF.ar(makeup * Convolution2.ar(impL, ~buf, 128), 280),
				// HPF.ar(makeup * Convolution2.ar(impR, ~buf, 128), 280)

				0.1 * impL,
				0.1 * impR

				// Decay.ar(Ringz.ar(trig, 654 + (i/10), partials[0]), 0.4),
				// Decay.ar(Ringz.ar(trig, 653 + (i/10), partials[1]), 0.4),

				// Decay2.ar(Ringz.ar(trig, 654 + (i/10), partials[0]), 0.001, 0.1),
				// Decay2.ar(Ringz.ar(trig, 653 + (i/10), partials[1]), 0.001, 0.1),

				// Ringz.ar(Decay2.ar(trig, 0.01, 0.8), 654 + (i/10), partials[0]),
				// Ringz.ar(Decay2.ar(trig, 0.01, 0.8), 653 + (i/10), partials[1]),

		]);

		sig = sig * EnvGen.kr(Env.linen(0.001, duration, 0.001), doneAction: 2);
		sig = Pan2.ar(sig, posArr[i%10], amp);
		Out.ar(100, sig);
	}.play
});


SynthDef(\rev,
	{
		var in = In.ar(100, 2);
		Out.ar(110, FreeVerb.ar(in, 0.3, 0.2))
	}
).add;

SynthDef(\mix,
	{
		var dry = In.ar(100, 2);
		var wet = In.ar(110, 2);
		Out.ar(0, (dry * 0.7) + (wet * 0.3));
}).add;


Synth(\rev, addAction: \addToTail);
Synth(\mix, addAction: \addToTail);
)



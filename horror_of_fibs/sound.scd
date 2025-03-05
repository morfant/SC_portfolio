(
(
SynthDef(\unit_of_sound_1,
	{
		arg freq = 200, detune = 1.0, freq_trig = 0, amp = 0.5, cutoff_mul = 0.6, dctime = 0.8, gate = 1, rq = 0.01;
		var sig, env, freq_cutoff;
		freq_cutoff = freq * cutoff_mul;
		env = EnvGen.kr(Env.perc(0.01), gate, doneAction: 2);
		sig = Decay2.ar(Impulse.ar(freq_trig), 0.01, dctime);
		sig = Pan2.ar(sig * SinOsc.ar(freq * detune) * env, 0, amp);
		sig = RHPF.ar(sig, freq_cutoff, rq);
		Out.ar(0, sig);
}).add;
);

~tung_1 = Synth(\unit_of_sound_1, [\freq, 200, \detune, 1, \freq_trig, 0, \cutoff_mul, 0.6, \amp, 0.5, \dctime, 0.8, \rq, 0.01]);
~tung_2 = Synth(\unit_of_sound_1, [\freq, 400, \freq_trig, 0, \cutoff_mul, 0.6, \amp, 0.5, \dctime, 0.8, \rq, 0.01]);
~tung_3 = Synth(\unit_of_sound_1, [\freq, 800, \freq_trig, 11,\cutoff_mul, 0.4, \amp, 0.5, \dctime, 0.2, \rq, 0.01]);
)




(
SynthDef(\unit_of_sound_2,
	{
		arg freq = 0, amp = 0.1, dctime = 0.8, gate = 1;
		var sig, env;
		env = EnvGen.kr(Env.perc(0.001, 0.7), gate, doneAction: 2);
		sig = Decay2.ar(Impulse.ar(freq), 0.005, dctime)
		* LFPar.ar(429 * [0.98, 1.0, 1.04, 1.086]).cubed.cubed.sum;
		sig = Pan2.ar(sig * env, 0, amp);
		sig = CombC.ar(sig, 0.5, [30, 40].choose.reciprocal);
		sig = HPF.ar(sig, 400);
		// sig = Ringz.ar(sig, 1000, 0.05);
		Out.ar(0, sig);
}).play;
);

(
SynthDef(\unit_of_sound_3,
	{
		arg freq = 0, amp = 0.1, dctime = 0.8, gate = 1;
		var sig, env;
		env = EnvGen.kr(Env.perc(1, 0.7), gate, doneAction: 2);
		sig = Decay2.ar(Impulse.ar(freq), 0.5, dctime)
		* DynKlank.ar(`[[500, 600, 920], [0.1], [0.01]], LFSaw.ar(700 * LFNoise0.kr([3, 4].choose).range(0.9, 1.2)));
		sig = Pan2.ar(sig * env, 0, amp);
		sig = HPF.ar(sig, 300);
		sig = Ringz.ar(sig, 1000, 0.1);
		Out.ar(0, sig);
}).play;
)
)

a = Synth(\unit_of_sound_2)
a = Synth(\unit_of_sound_3)


(// gate 아규먼트 자리에 trigger rate 아규먼트를 이용하는 예
SynthDef(\rtest, {|t_trig = 0, ttrig = 0|
	var sig, env;
	env = EnvGen.kr(Env.perc(), t_trig, doneAction: 0); // tr
	// env = EnvGen.kr(Env.perc(), ttrig, doneAction: 0); // kr
	sig = SinOsc.ar(\freq.ar(300), mul: \amp.ar(0.2));
	Out.ar(0, sig * env);
}).add;
)
a = Synth(\rtest);

a.set(\t_trig, 1); // t_trig 이용

a.set(\ttrig, 0); // ttrig 이용
a.set(\ttrig, 1);



t = Tempo.default;
t.tempo = (72/60);

(
~pre_1 = Pbind(
	\instrument, \unit_of_sound_1,
	\freq, Pn(Pseq([150], 1), 29),
	\dur, 0.3,
	\detune, 1,
	\freq_trig, 0,
	\cutoff_mul, 0.6,
	\amp, Pseq([0.2, 0.15], inf),
	\dctime, 0.5,
	\rq, 0.1
))
~pre_1.play
)


(
~pre_2 = Pbind(
	\instrument, \unit_of_sound_1,
	\freq, Pn(Pseq([135], 1), 30),
	\dur, 0.3,
	\detune, 1,
	\freq_trig, 0,
	\cutoff_mul, 0.6,
	\amp, Pseq([0.2, 0.15], inf),
	\dctime, 0.5,
	\rq, 0.1
))
~pre_2.play
)


(
~pre_3 = Pbind(
	\instrument, \unit_of_sound_1,
	\freq, Pn(Pseq([150], 1), 32),
	\dur, 0.3,
	\detune, 1,
	\freq_trig, Pseq([Pseq([0], 8), Pseq([2], 8), Pseq([3], 8), Pseq([4], 7)], 1),
	\cutoff_mul, Pseq((0.01, 0.02..0.32), inf) * 0.6,
	\amp, Pseq([0.2, 0.15], inf),
	\dctime, Pseq((0.2, 0.21..0.5), inf),
	\rq, 0.1
);
)
~pre_3.play
)



(
~pre_4 = Pbind(
	\instrument, \unit_of_sound_1,
	\freq, Pn(Pseq([450], 1), 32),
	\dur, 0.3,
	\detune, 1,
	\freq_trig, Pseq([Pseq([2], 8), Pseq([2], 8), Pseq([12], 8), Pseq([4], 7)], 1),
	\cutoff_mul, Pseq((0.01, 0.02..0.32), inf) * 0.6,
	\amp, Pseq([0.2, 0.15], inf),
	\dctime, Pseq((0.2, 0.21..0.5), inf),
	\rq, 1
);
)
~pre_4.play
)

(
~pre_5 = Pbind(
	\instrument, \unit_of_sound_1,
	\freq, Pn(Pseq([600], 1), 24),
	\dur, 0.3,
	\detune, Prand([1, 1.1], inf),
	\freq_trig, 2,
	\cutoff_mul, Pseq((0.01, 0.02..0.32), inf) * 0.1,
	\amp, Pseq([0.2, 0.15], inf),
	\dctime, Pseq((0.2, 0.21..0.3), inf),
	\rq, 0.01
);
)
~pre_5.play
)


(
~pre_1_s = Pbind(
	\instrument, \unit_of_sound_1,
	\freq, Pn(Pseq([450, 195], 1), 28/2),
	\dur, 1.2,
	\detune, Pseq((0.9, 0.91..1.1), 15),
	\freq_trig, 3,
	\cutoff_mul, 0.8,
	\amp, Pseq([0.1, 0.05], inf),
	\dctime, 0.5,
	\rq, 0.01
))
~pre_1_s.play
)



// 시퀀스
(
~r_1 = Routine{
	~pre_1.play;
	9.6.wait;
	~pre_2.play;
	9.6.wait;
	~pre_1.play;
	~pre_3.play;
	9.6.wait;
	~pre_2.play;
	~pre_3.play;
	9.6.wait;
	~pre_1.play;
	~pre_4.play;
	9.6.wait;
	~pre_2.play;
	~pre_5.play;
};
)

~r_1.reset;~r_1.play;

(
~r_2 = Routine{
	~pre_1.play;
	~pre_1_s.play;
	9.6.wait;
	~pre_2_s.play;
	9.6.wait;
	~pre_1_s.play;
	~pre_3_s.play;
	9.6.wait;
	~pre_2.play;
	~pre_3.play;
	9.6.wait;
	~pre_1.play;
	~pre_4.play;
	9.6.wait;
	~pre_2.play;
	~pre_5.play;
};
)

~r_2.reset;~r_2.play;
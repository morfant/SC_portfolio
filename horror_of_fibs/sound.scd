(
SynthDef(\unit_of_sound_1,
	{
		arg freq = 0, amp = 0.5, dctime = 0.8, gate = 1;
		var sig, env;
		env = EnvGen.kr(Env.perc(0.00001), gate, doneAction: 2);
		sig = Decay2.ar(Impulse.ar(freq), 0.01, dctime);
		sig = Pan2.ar(sig * env, 0, amp);
		Out.ar(0, sig);
	}).add;

SynthDef(\unit_of_sound_2,
	{
		arg freq = 0, amp = 0.5, dctime = 0.8, gate = 1;
		var sig, env;
		env = EnvGen.kr(Env.perc(0.1), gate, doneAction: 2);
		sig = Decay2.ar(Impulse.ar(freq), 0.005, dctime) * SinOsc.ar(429).cubed;
		sig = Pan2.ar(sig * env, 0, amp);
		Out.ar(0, sig);
	}).add;
)

a = Synth(\unit_of_sound_2)


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
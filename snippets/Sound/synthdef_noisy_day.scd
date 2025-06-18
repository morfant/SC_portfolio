(
SynthDef(\ttttt, {
	arg freq = 100, amp = 0.2, gate = 1, fcFreq = 10;
	var sig, fil, fc, env, trig;

	trig = Trig.kr(Dust.kr(10));
	sig = BrownNoise.ar(LFPulse.kr([10, 20], width: 0.9) * trig * amp);
	fc = LFNoise0.kr(fcFreq).range(100, s.sampleRate/4);

	fil = BRF.ar(sig, [fc, fc / Rand(1, 4)], 1.0);
	fil = Resonz.ar(fil, 800 + (trig * LFPar.kr(5).range(-1, 1) * 600), 0.08);
	fil = Balance.ar(fil, fil*2);

	Out.ar(0, fil);
}).play;
)



(
SynthDef.new(\rand_temp,
	{
		|amp = 0.5|
		var del;
		var trig = Trig.ar(LFNoise0.ar(14), LFNoise0.kr(5).range(0.01, 0.05));
		var sig = ClipNoise.ar() * trig;
		// sig = RHPF.ar(sig, 500 + (PulseCount.ar(trig) % 8 * [140, -40].choose), 0.02, 0.4);
		sig = RHPF.ar(sig, 500, 0.02, 0.4);
		del = DelayN.ar(sig * 0.2, 0.5, 0.5);
		sig = sig + (del * 0);
		Out.ar(0, Pan2.ar(sig, 0, amp));
	}
).play;


)



(
{
	// Trig.ar(LFNoise0.ar(18), LFNoise0.kr(5).range(0.01, 0.3));
	Trig.ar(LFNoise0.ar(12), LFNoise0.kr(5).range(0.01, 0.3));
}.plot(1)
)
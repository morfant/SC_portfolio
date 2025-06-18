// 250303

(
SynthDef.new(\path,
	{
		|amp = 0.9, freq = 800, modHi = 101, modLo = 100|
		var sig;
		var randSigLo = WhiteNoise.ar().range(2, modHi);
		var randSigHi = WhiteNoise.ar().range(2, modLo);
		var lo = SinOsc.ar(randSigLo);
		var hi = SinOsc.ar(randSigHi);
		sig = Clip.ar(LFTri.ar(freq, mul: 0.8), lo, hi);
		sig = HPF.ar(sig, 100);
		sig = LeakDC.ar(sig);
		Out.ar(0, Pan2.ar(sig, 0, amp));
	}
).add;
)

// Test
a = Synth(\path, [\freq, 100, \modHi, 20, \modLo, 21])
b = Synth(\path, [\freq, 200, \modHi, 20, \modLo, 21])
c = Synth(\path, [\freq, 300, \modHi, 20, \modLo, 21])

a.set(\modLo, 30)
b.set(\modLo, 30)
c.set(\modLo, 30)

a.set(\modHi, 100)
b.set(\modHi, 40)
c.set(\modHi, 50)


자주 찾게 되는 것 : 일정 범위의 랜덤한 신호를 만들어 내는 것



{WhiteNoise.ar().range(0, 0.9)}.play


({
		[WhiteNoise.ar().range(3, 101),
		WhiteNoise.ar().range(3, 100)]
}.plot(1))

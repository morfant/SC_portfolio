(//Schroeder Reverberator
// https://ccrma.stanford.edu/~jos/pasp/Schroeder_Reverberators.html#fig:jcrevmus10

~path = "/Users/giy/Projects/sc-example-code/effector/sample/peaceful-simple-piano.wav";
// ~path = "/Users/giy/Downloads/pseudo-classical-piano-melody-2.wav";
b = Buffer.read(s, ~path);

SynthDef(\schroeder_reverb, {
	arg predt = 0.001, dmul = 1, dctime = 1, mix = 0.9;
	var input, out, temp, oneSampT = s.sampleRate.reciprocal;
	var x1, x2, x3, x4, s1, s2, outa, outb, outc, outd;

	input = PlayBuf.ar(2, b, BufRateScale.kr(b), loop: 1);

	// reverb predelay time :
	temp = DelayN.ar(input, 0.048, predt);

	// allpass filter serial
	temp = 0.7 * AllpassN.ar(temp, 0.5, oneSampT * 3470 * dmul, dctime);
	temp = 0.7 * AllpassN.ar(temp, 0.5, oneSampT * 1130 * dmul, dctime);
	temp = 0.7 * AllpassN.ar(temp, 0.5, oneSampT * 370 * dmul, dctime);

	// comb filter parallel
	x1 = 0.773 * CombL.ar(temp, 0.5, oneSampT * 1687 * dmul, dctime);
	x2 = 0.802 * CombL.ar(temp, 0.5, oneSampT * 1601 * dmul, dctime);
	x3 = 0.753 * CombL.ar(temp, 0.5, oneSampT * 2053 * dmul, dctime);
	x4 = 0.733 * CombL.ar(temp, 0.5, oneSampT * 2251 * dmul, dctime);

	// mixing matrix
	s1 = x1 + x3;
	s2 = x2 + x4;
	outa = s1 + s2;
	outb = outa.neg;
	outd = s1 - s2;
	outc = outd.neg;

	out = [outa, outb, outc, outd].sum;

	// set mix (dry and wet)
	out = (1.0 - mix) * input + (mix * temp);
	Out.ar(0, out);
}).add;
)

(
a = Synth(\schroeder_reverb);
a.set(\mix, 0.1, \predt, 0.4, \dmul, 3.0, \dctime, 3.0);
a.free;
)



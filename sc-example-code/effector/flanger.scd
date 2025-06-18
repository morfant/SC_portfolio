( //flanger
~path = "/Users/giy/Downloads/peaceful-simple-piano.wav";
// ~path = "/Users/giy/Downloads/pseudo-classical-piano-melody-2.wav";
b = Buffer.read(s, ~path);

f = {
	arg time = 0.0035, feedback = 0.4, rate = 0.55, depth = 1, dry = 0.5, wet = 0.5;
	var in, eff, lfo, out, numCh = 2;

	in = PlayBuf.ar(numCh, b, BufRateScale.kr(b), loop: 1);
	in = in + LocalIn.ar(numCh); // add previous output to current input
	lfo = SinOsc.kr(rate).range(0.0, depth); //freq: rate, range: Depth
	eff = DelayC.ar(in, 10, lfo*time, 1);
	LocalOut.ar(feedback*eff); // enable LocalIn has output
	(dry * in) + (wet * eff);

}.play;
);

(
d = 0.1;
w = 1.0 - d;
f.set(\dry, d, \wet, w, \time, 0.009, \rate, 0.4, \depth, 1, \feedback, 0.85);
)


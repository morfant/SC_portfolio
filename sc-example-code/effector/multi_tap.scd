(// Multi tap...?
~path = "/Users/giy/Downloads/peaceful-simple-piano.wav";
// ~path = "/Users/giy/Downloads/pseudo-classical-piano-melody-2.wav";
b = Buffer.read(s, ~path);
// b = Buffer.alloc(s, s.sampleRate); // normal use
f = {
	arg wet = 0.5, dry = 0.5, tadd = #[1, 4, 7, 10];
	var numCh = 2, in, eff, feedback, out;
	in = PlayBuf.ar(numCh, b, BufRateScale.kr(b), loop: 1);
	eff = MultiTap.ar(
		`[[0.1, 0.4]+tadd[0], [0.2, 0.5]+tadd[1], [0.3, 0.6]+tadd[2], [0.4, 0.7]+tadd[3]],
		`[[0.8, 0.1], [0.4, 0.2], [0.2, 0.5], [0.1, 0.7]],
		PinkNoise.ar(), // output과 상관 없다
		bufnum: b.bufnum);
	out = (in * dry) + (eff * wet);
	out;
}.play
)

(
d = 0.2;
w = 1.0 - d;
f.set(\dry, d, \wet, w);
f.setn(\tadd, #[0, 1, 2, 3]);
)

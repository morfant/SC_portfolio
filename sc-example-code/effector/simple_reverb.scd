(// simple Reverb
~path = "/Users/giy/Downloads/peaceful-simple-piano.wav";
// ~path = "/Users/giy/Downloads/pseudo-classical-piano-melody-2.wav";
b = Buffer.read(s, ~path);

Ndef(\verb, {
	arg dltime = 0.45, dctime = 1.0, fdCoef = 0.7, mix = 0.3;
	var sig, eff, out, fdbk;

	sig = PlayBuf.ar(2, b, loop: 1);
	// sig = Impulse.ar(1/3, mul: 0.4)!2;
	fdbk = LocalIn.ar(2);


	// experimental
	// fdbk = Mix.fill(4, {Resonz.ar(fdbk, rrand(200, 1000), 0.8) * 0.42});
	// 5.do{fdbk = DelayN.ar(fdbk, 0.3, 0.3.rand)*0.9};


	eff = sig + fdbk;
	LocalOut.ar(DelayC.ar(eff, dltime, dltime, dctime) * fdCoef);

	(sig * (1.0 - mix)) + (eff * mix);

}).play
)
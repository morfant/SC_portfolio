s.sampleRate
s.depth
ServerOptions
b.play;


(// chorus
~path = "/Users/giy/Downloads/peaceful-simple-piano.wav";
// ~path = "/Users/giy/Downloads/pseudo-classical-piano-melody-2.wav";
b = Buffer.read(s, ~path);
f = {|dry = 0.5, wet = 0.5, time = 0.01, rate = 0.46, amount = 0.2, phase = 0.5|
  var in, lfo1, lfo2, eff;
	// time = 10/1000; // ms(millisecond)
	// rate = 0.46; // Hz
	// amount = 0.2; // %
  in = PlayBuf.ar(2, b, BufRateScale.kr(b), loop: 1);

  lfo1 = SinOsc.kr(rate).range(0.0, 1.0*amount); //freq: rate, range: Depth
	lfo2 = SinOsc.kr(rate, phase.linlin(0.0, 1.0, 0, pi)).range(0.0, 1.0*amount);
  eff = Mix.ar([
    DelayC.ar(in, 0.5, time*lfo1, 0.2),
    DelayC.ar(in, 0.5, time*lfo2, 0.2),
  ]);

	(dry * in) + (wet * eff);

}.play;
);

(
d = 0.1;
w = 1.0 - d;
f.set(\dry, d, \wet, w, \phase, 0.4, \time, 10/1000, \rate, 0.46, \amount, 0.2);
)

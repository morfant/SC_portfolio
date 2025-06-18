(// Dodge, p.215
~getButterHPFCoef = {|fc = 800|
	c = tan(pi*(fc/s.sampleRate));
	~a0 = 1 / (1 + (sqrt(2)*c) + (c*c));
	~a1 = -2 * ~a0;
	~a2 = ~a0;
	~b1 = 2 * ~a0 * (c*c - 1);
	~b2 = ~a0 * (1 - (sqrt(2)*c) + (c*c));
};
)

~getButterHPFCoef.value(2000);
{SOS.ar(PinkNoise.ar(0.5), ~a0, ~a1, ~a2, (-1)*~b1, (-1)*~b2)}.play

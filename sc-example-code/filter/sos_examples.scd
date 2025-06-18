
( // max의 filtergraph 이용
~a0 = 0.001395;
~a1 = 0.00279;
~a2 = 0.001395;
~b1 = -1.953181;
~b2 = 0.957355;
{SOS.ar(WhiteNoise.ar(0.5), ~a0, ~a1, ~a2, -1 * ~b1, -1 * ~b2)}.play;
)

(// dodge 책의 공식 이용
~f_bpf = {|freq = 2000|
~fs = s.sampleRate;
~f0 = freq;
~bw = 100;
~c = 1 / (tan(pi * (~bw/~fs)));
~d = 2 * cos(2*pi*(~f0/~fs));
~a0 = 1 / (1 + ~c);
~a1 = 0;
~a2 = -1 * ~a0;
~b1 = -1 * ~a0 * ~c * ~d;
~b2 = ~a0 * (~c - 1);

	[~a0, ~a1, ~a2, ~b1, ~b2];
};
)

(
r = ~f_bpf.value(100);
{SOS.ar(WhiteNoise.ar(0.5), r[0], r[1], r[2], -1 * r[3], -1 * r[4])}.play;
)


(// reson 필터 공식 이용
{
	var rho, theta, cos_theta, fs, bw, f0, a0, a1 = 0, a2 = 0, b1, b2;
	bw = MouseY.kr(10, 200);
	f0 = MouseX.kr(10, 2000);
	fs = s.sampleRate;
	rho = 1 - (pi*(bw/fs));
	theta = 2*pi*(f0/fs);
	cos_theta = (2*rho)/(1 + (rho*rho))*cos(theta);

	a0 = (1 - rho.squared)*sin(theta);
	b1 = 2.0 * rho * cos_theta;
	b2 = rho.squared.neg;

	{SOS.ar(WhiteNoise.ar(1), a0, a1, a2, b1, b2)};
}.play
) 
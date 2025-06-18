// SOS 유젠에 사용하기 위한 계수들을 구하는 함수
(// Dodge, p.216 - Butterworth band-pass filter
~bp = {|fc = 700, rq = 1.0|

	~bw = fc * rq; // BPF의 도움말 문서 참고 (rq = bw/fc)
	~fc = fc;

	c = 1 / tan(pi * ~bw / s.sampleRate);
	d = 2 * cos(2 * pi * ~fc / s.sampleRate);
	~a0 = 1 / (1 + c);
	~a1 = 0;
	~a2 = -1 * ~a0;
	~b1 = -1 * ~a0 * c * d * -1;
	~b2 = ~a0 * (c - 1) * -1;
};
)

(
~bp.value(1400, 0.5); // center frequency, rq 값 조절 가능
{SOS.ar(WhiteNoise.ar(0.2), ~a0, ~a1, ~a2, ~b1, ~b2);}.play;
)
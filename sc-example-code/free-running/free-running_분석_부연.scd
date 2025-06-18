// play 안에 함수가 있을 때
(
play{
	f = { |freq = (26.midicps) | LFDNoise3.ar(0.2, 0.1) };
}
)


// var gate 형태 확인
{LFTri.ar(1/30, 1)}.plot(30)

{Pulse.kr(5)}.plot(1);
trace

s.meter.alwaysOnTop_(s)

// k와 i의 변화 양상
(
{|k|
	("k = " ++ k).postln;
	{|i|
		  ("\ti = " ++ i).postln;
	}!(k/2 + 1).asInteger;
} ! 16;
)



(
~makePulse = {|i|
	Pulse.ar(10.0.rand, 0.5.rrand(0.95));
} ! 12;
)


// .product
[6,2,12].product;


// Pan2
(
	Pan2.ar((
		~makePulse.()
	)
))


// Pan2 + .product
(
Pan2.ar((
	~makePulse.()
).product;
))


// https://ko.wikipedia.org/wiki/%EC%86%8C%EC%88%98_(%EC%88%98%EB%A1%A0)
3.nthPrime; // 소수(prime number)를 얻는다



(// plot
~freqDrift = { |freq=200| LFDNoise3.kr(0.2, 0.1, freq.cpsmidi).midicps }; // 주파수를 미세하게 랜덤하게 변화시킴 계속해서
{
~rootFreq = ~freqDrift.(26.midicps);

({ |k| // 0 ~ 15
Pan2.ar(
	({ |i| // 0 ~ ((k/2 + 1).asInteger - 1)
				Pulse.ar(
					(i * k) + 2 / (k + 1) * ~rootFreq * (i + 1) * 0.0625 * 16, // freq of Pulse 
					LinLin.ar(LFTri.ar(~rootFreq * (i + 1) / 1024), -1, 1, 0.5, 0.95) // width of Pulse
                    )} ! (k/2 + 1).asInteger).product // (k/2 + 1) 개의 인자를 가진 배열의 인자들 값을 모두 곱한 결과
	* (k + 1).reciprocal // / (k + 1)
				* LinExp.ar(Blip.ar(
					(k + 5).nthPrime.reciprocal * ~rootFreq * 0.125, 3), -1, 1, -48.dbamp, 1).neg, // in of Pan2

				LFTri.ar((k + 1).nthPrime * ~rootFreq / 256) // pos of Pan2
			)
} ! 16).sum
}.plot(20)
)



// dup of Pan2
Pan2.ar(({|i| i.postln} ! 6));


(// Blip 의 변화 양상 관찰 
~freqDrift = { |freq=200| LFDNoise3.kr(0.2, 0.1, freq.cpsmidi).midicps }; // 주파수를 미세하게 랜덤하게 변화시킴 계속해서
{
	var sig;
	~rootFreq = ~freqDrift.(26.midicps);
	sig = Blip.kr(8.nthPrime.reciprocal * ~rootFreq * 0.125, 3 );
	// Blip.kr(5.nthPrime.reciprocal * ~rootFreq * 0.125, 6 );
	sig = LinExp.kr(sig, -1, 1, -48.dbamp, 1);
	sig = sig.neg;
}.plot(10)
)


// .neg : 음수로 만든다
0.125.neg;
-1.neg;


// Blip : freq 에 정해진 주파수의 배음들을 만들어 내는 UGen. sampleRate안의 모든 주파수 배음들을 만들어 내면 Impulse와 같아진다. 그러나 Band-limited
{Impulse.ar(10)}.plot(1)
{Impulse.ar(1)}.play;
{Blip.ar(1, 2)}.plot(1)
{Blip.ar(8, s.sampleRate/2)}.play;


// UGen의 phase 파라메터에 GVerb를 사용한 것의 효과 - 2ch, 랜덤한 느낌, 피드백...
{GVerb.ar(Pulse.ar())}.plot;
{(Pulse.ar())}.plot;

{SinOsc.ar(400, GVerb.ar(Pulse.ar() * Blip.ar(3, 3).neg))}.play;
{SinOsc.ar(400, (Pulse.ar() * Blip.ar(3, 3).neg))}.play;
{SinOsc.ar(400, GVerb.ar(Pulse.ar()))}.play;
{SinOsc.ar(400, (LFPulse.ar()))}.play;


// LeakDC
{SinOsc.ar(1)}.plot(2)
{LeakDC.ar(SinOsc.ar(1))}.plot(2); //coef가 1에 가까울 수록 원래 신호와 비슷한 형태를 유지한다 


// Lag
{Lag.ar(Line.ar(0.0, 1.0, 1.0), 1.0)}.plot(1)

// LinLin : 출력값의 범위를 변경하는 기능
{LinLin.ar(LFTri.ar(1), -1, 1, 3, 13)}.plot(1);


// f_1과 f_2가 같은 경우, 다른 경우를 비교해 보자.
(
{
	var f_1 = 5;
	var f_2 = 3;
	var sig_1 = LinLin.ar(LFTri.ar(f_1), -1, 1, 3, 13).floor;
	var sig_2 = LinLin.ar(LFTri.ar(f_2), -1, 1, 13, 3).floor;
	(sig_1 / sig_2);
	// Lag.ar(sig_1 / sig_2, 0.25); // Lag을 사용하면 자잘한 차이들을 부드럽게 만든다.
}.plot(5)
)


// LFTri 의 iphase 값 비교
(
{{|i|
	LFTri.ar(1, i)
}!4}.plot(1)
)

(
{[
	LFTri.ar(1, 0),
	LFTri.ar(1, 1),
	LFTri.ar(1, 2),
	LFTri.ar(1, 3),
	LFTri.ar(1, 4),
]}.plot(1)
)


// AmpComA : A-weight 함수를 통한 보상
// 등청감곡선에 의해 주파수에 따른 인지의 차이를 균등하게 맞추려는 시도
// FreqScope의 dbCut을 36db로 셋팅하고 마우스를 움직여 0, 1 각bus의 음량 변화의 추이를 관찰할 것
(
{
    var freq;
    freq = MouseX.kr(100, 20000, 0);
    [
		SinOsc.ar(freq) * AmpCompA.kr(freq), // A-weight 보상
    	SinOsc.ar(freq)
	] * 0.3;
}.play;
)

// 10 ~ 100 구간과 100 ~ 10000 구간에서의 필터링 값 비교
// https://community.sw.siemens.com/s/article/what-is-a-weighting
// 위 링크의 fig.4 와 비교해서 관찰 할 것
{ AmpCompA.ar(Line.ar([10, 1000], [100, 10000], 1))}.plot(1.0);


// make WhiteNoise with SinOsc(s)
// 그러나 AmpCompA가 예상대로 작동하지는 않음
s.options.memSize;
s.options.memSize = 8192 * 2 * 2;
s.reboot;
(
{
Mix.fill(s.sampleRate/2, {|i| AmpCompA.ir(i) * 0.01 * SinOsc.ar(rrand(1, s.sampleRate/2))});
// Mix.fill(s.sampleRate/2, {|i| SinOsc.ar(rrand(1, s.sampleRate/2), mul: 0.001)});
}.play;
)

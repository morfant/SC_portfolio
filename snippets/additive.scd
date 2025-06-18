({
	var n = 20, freq = 150, harmonics;
	var parAmp = 0.05, amp = 0.3;
	var env;
	n = rrand(n * 0.2, n).asInteger.postln;
    harmonics = Mix.fill(n, {|i|
        var overtone = (i + 1) * (1 + i.rand * parAmp);
        SinOsc.ar(freq * overtone, mul: amp / (i + 1))
    });
	env = EnvGen.kr(Env.perc(0.1, 3), doneAction: 2);
    harmonics * env!2;
}.play;
)





(
{
	var n = 10;
    var baseFreq = 150;
    var harmonics = Mix.fill(n, {|i|
        var overtone = (i+1) * (1 + i.rand * 0.05);
		SinOsc.ar(baseFreq * overtone, mul: 0.3 / ((n + 1) - (i + 1)))
    });
    harmonics * EnvGen.kr(Env.perc(0.1, 3), doneAction: 2)
!2}.play;
)



(
{
	var n = 20;
    var baseFreq = 550;
	var harmonics;
	baseFreq = baseFreq + SinOsc.ar(3).range(0, 7);
	"n: ".post;
	n = rrand(n * 0.2, n).asInteger.postln;
    harmonics = Mix.fill(n, {|i|
		// var overtone = (i+1) * (1 + i.rand * 0.05);
        var overtone = (i+1) * (1 + n
			.rand * 0.05);
		// SinOsc.ar(baseFreq * overtone, mul: 0.3 / ((n + 1) - (i + 1)))
		SinOsc.ar(baseFreq * overtone, mul: 0.3 / (i + 1))
    });
    harmonics * EnvGen.kr(Env.perc(0.1, 3), doneAction: 2)
!2}.play;
)




(
{
	var n = 20;
    var baseFreq = 550;
	var harmonics;
	baseFreq = baseFreq + SinOsc.ar(3).range(0, 7);
	"n: ".post;
	n = rrand(n * 0.2, n).asInteger.postln;
    harmonics = Mix.fill(n, {|i|
		var overtone = (i+1) * (1 + i.rand * 0.05);
		// var overtone = (i+1) * (1 + n.rand * 0.05);
		// SinOsc.ar(baseFreq * overtone, mul: 0.3 / ((n + 1) - (i + 1))) // 고음 강조
		SinOsc.ar(baseFreq * overtone, mul: 0.3 / (i + 1)) // 저음 강조
    });
    harmonics * EnvGen.kr(Env.perc(0.1, 3), doneAction: 2)
!2}.play;
)


// * 이런 질문들, 혹은 다른 작동들의 방식을 상상한 다음 그 각각을 구현해 보기
// 고음 강조 상태와 저음 강조 상태가 왔다갔다 하게 하려면?
// 소리가 나고 있는 상태에서 각 배음들의 음량이 달라지려면?


n = 5

0.3/1
0.3/2
0.3/3
0.3/4
0.3/5

0.3/2
0.3/3
0.3/4
0.3/5
0.3/1

0.3/3
0.3/4
0.3/5
0.3/1
0.3/2

0.3/4
0.3/5
0.3/1
0.3/2
0.3/3
.
.


첫 배음의 입장
0.3/1 -> 0.3/2 -> 0.3/3 -> 0.3/4 -> 0.3/5 -> 0.3/1 -> 0.3/2 -> 0.3/3 ...



(   // 1 ~ n까지 반복되는 인덱스 생성: Phasor.ar
{
    var n = 20;
    var baseFreq = 550;

	var harmonics;


	var modIndex = (Phasor.kr(0, 200*(1/s.sampleRate), 1, n+1) % n + 1).floor;

    baseFreq = baseFreq + SinOsc.ar(3).range(0, 7); // 기본 주파수에 변화 추가


    "n: ".post;
    n = rrand(n * 0.2, n).asInteger.postln;

    harmonics = Mix.fill(n, {|i|
        var overtone = (i+1) * (1 + i.rand * 0.05);
		var modulatedAmp = Lag.kr(0.3 / ((i + modIndex) % n + 1)); // 주기적으로 변화하는 진폭 적용
        SinOsc.ar(baseFreq * overtone, mul: modulatedAmp)
    });

    harmonics * EnvGen.kr(Env.perc(0.1, 7), doneAction: 2)
!2}.play;
)


(
// 1 ~ n까지 반복되는 인덱스를 생성, Lag 적용하여 부드러운 변화
// Phasor.kr
{
    var n = 20;
    var baseFreq = 550;
    var harmonics;
	var modIndex = (Phasor.kr(0, 330*(1/s.sampleRate), 1, n+1) % n + 1).floor;

    baseFreq = baseFreq + SinOsc.ar(3).range(0, 7); // 기본 주파수에 변화 추가

    "n: ".post;
    n = rrand(n * 0.2, n).asInteger.postln;

    harmonics = Mix.fill(n, {|i|
        var overtone = (i+1) * (1 + i.rand * 0.05);

        // 클릭 방지를 위해 Lag.kr로 부드럽게 변화하도록 조절
        var modulatedAmp = Lag.kr(0.3 / ((i + modIndex) % n + 1), 0.1);

        SinOsc.ar(baseFreq * overtone, mul: modulatedAmp)
    });

    harmonics * EnvGen.kr(Env.perc(1.1, 7), doneAction: 2)
!2}.play;
)



(   // SinOsc.kr을 사용하여 진폭이 부드럽게 변화하도록 설정
{
    var n = 20;
    var baseFreq = 550;
    var harmonics;

    var modIndex = SinOsc.kr(0.5).range(1, 5);

    baseFreq = baseFreq + SinOsc.ar(3).range(0, 7);


    "n: ".post;
    n = rrand(n * 0.2, n).asInteger.postln;

    harmonics = Mix.fill(n, {|i|
        var overtone = (i+1) * (1 + i.rand * 0.05);
        var modulatedAmp = 0.3 / ((i + modIndex) % n + 1);
        SinOsc.ar(baseFreq * overtone, mul: modulatedAmp)
    });

    harmonics * EnvGen.kr(Env.perc(0.4, 7), doneAction: 2)
!2}.play;
)
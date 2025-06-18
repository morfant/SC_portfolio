// Pbind를 통해 오실레이터 개수를 가변적으로 사용하는 방법


// SinOsc가 담기는 개수에 따라 synthdef를 여러 개 만드는 방법
// synth_1 : 1개의 SinOsc가 작동하는 synthdef
// synth_2 : 2개의 SinOsc가 작동하는 synthdef
// ...

(
(1..10).do{|n|
	var name = \synth_++n;
	SynthDef(name, {|out = 0, freq = #[440, 450], amp = 0.1, gate = 1|
		var sig0, sig1, amps, env;
		env = EnvGen.kr(Env.perc(), gate, doneAction: Done.freeSelf);
		amps = (1/(1..n)).normalizeSum;
		sig0 = (SinOsc.ar(freq[0] * (1..n), mul: amp) * amps).sum;
		sig1 = (SinOsc.ar(freq[1] * (1..n), mul: amp) * amps).sum;
		Out.ar(out, [sig0, sig1] * env);
		// Out.ar(out, sig0 * env);
	}).add;
}
)

(
p = Pbind(
	\size, Prand((1..10), 100).collect{|x| x.asSymbol}, // 1~10 사이 랜덤한 숫자를 선택, integer -> symbol
	\instrument, Pkey(\size).collect{|x| \synth_++x}, // 앞서 만든 값을 이용해 적용할 synthdef 이름을 결정
	\dur, 1,
	\amp, 0.3,
	\degree, Pshuf((0..11) + [[1.0.rand, 1.0.rand], [1.0.rand, 1.0.rand]], 100)
).trace.play
)


// Event patterns and array args 의 도움말 문서 참고
// https://github.com/dkmayer/miSCellaneous_lib
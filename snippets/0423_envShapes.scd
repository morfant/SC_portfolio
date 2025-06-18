"10_print_funcs.scd".loadRelative; // 이렇게만 해서는 초기값이 거의 0이 나온다. 왜??
"10_print_funcs.scd"를 한 번 실행해 줄 것.



(// 데이터를 만들어 내는 방식을 아래와 같이 바꿀 것.
// 그리고 v를 순차적으로 더해 구하는 것이 아니라 배열이 결정된 뒤에 바로 전체 톤을 변경하는 방식을 어떨까?
fork{
	5.do{
		~nextGen = Array.fill(8, {0.5.coin.asInteger});
		("~nextGen: "++ ~nextGen).postln;

		8.do{
			~nextGen = ~ca.value(~nextGen);

			1.0.wait;
		}
	}
}
)



(
var envs, env1, env2, env3, env4;
env1 = Env([0, 1, 0.5, 0], [0.2, 0.3, 0.5], \sin, offset: -1.0);
env2 = Env.new([-1, -0.3, 0.3, 1], [1, 2, 1], curve: 'sin', offset: -1.0);
env3 = Env.new([1, 0.3, 0, 0.3, 1], [1, 1, 1, 1], curve: ['sin', 'cub', 'cub', 'sin'], offset: -1.0);
env4 = Env.new(
	[1] ++ {|i| rrand(0.3, 0.6) - (i * 0.1)}.dup(3) ++ [0] ++ {|i| rrand(0.3, 0.6) - (i * 0.1)}.dup(3) ++ [1],
	[1] ++ (0.1!6) ++ [1],
	curve: [\sin, \cub, \cub, \sin],
	offset: -1.0
);
envs = [env1, env2, env3, env4];

SynthDef(\envShapes, {
	arg out = 0, amp = 0.2, envIdx = 1;
	var sig, envsigs;
	sig = SinOsc.ar(\freq.ar(([60, 67, 71, 72]-(12*1)).midicps, 3.0));

	// 미리 각각의 Env를 Signal로 변환
	envsigs = [
		IEnvGen.ar(env1, sig),
		IEnvGen.ar(env2, sig),
		IEnvGen.ar(env3, sig),
		IEnvGen.ar(env4, sig)
	];

	// sig = SelectX.ar(VarLag.ar(LFPulse.ar(1/4).clip(0, 1) + 1, 0.7, -5), envsigs);
	sig = SelectX.ar(envIdx, envsigs);
	sig = LeakDC.ar(HPF.ar(sig, 100));
	Out.ar(out, sig * amp ! 2);
}, rates: [0, 0, 6.0]).add;
)

a = Synth(\envShapes);
a.free;
b = Synth(\envShapes, [\freq, (#[55, 58, 62, 74]-(12*1)).midicps]);


a.set(\gate, 0)
a.set(\gate, 1)

a.set(\envIdx, 0);
a.set(\envIdx, 1);
a.set(\envIdx, 2);
a.set(\envIdx, 3);
a.set(\freq, #[55, 58, 62, 74].midicps)
a.set(\freq, (#[60, 67, 71, 72]-(12*1)).midicps)




// 주먹을 쥐었다 펴듯, 각오를 했던 것이 스르르 풀어 지듯
// 무언가를 좇아야만 한다고 믿었던 사람이 지하철에서 자기 손을 바라보며 보내는 시간 같은 것들
// 어쩌면 그게 마음이 움직이는 모양
// 고무줄이 당겨졌다 늘어지듯
(
var dur = 1.0, resetDur = 2.0, num = 8;
a = Synth(\envShapes);
fork{
	inf.do{|n|
		~nextGen = Array.fill(num, {0.5.coin.asInteger}); // if initial value is [0, 0, 0, 0 .. 0], you should retry it!
		// ~nextGen = [0, 1, 0, 1, 0, 0, 1, 0];
		("reset "++n++" times").postln;

		1.do{|i|
			var count = i % 6;
			var v = 0;
			~nextGen = ~ca.value(~nextGen);

			~nextGen.do{|item, i|
				item.postln;
				v = v + item;
				("v: "++v).postln;
				if (v > 2, {a.set(\freq, (#[55, 58, 62, 74] - v).midicps)}, {a.set(\freq, (#[60, 67, 71, 72]-(12*1)).midicps)});
				if (v > 2, {a.set(\envIdx, (item + 1 + v) % 4);}, {a.set(\envIdx, item + 1);});

				dur.wait;
			};

			0.0.wait;

		};
		resetDur.wait;
	}
}
)



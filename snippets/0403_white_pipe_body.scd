// 25.04.03
// 하얀 가래떡 같은 골격으로 이루어진 작은 생물체
// 강아지로 들어와서 마틴의 펑퍼짐한 몸 위에 가래떡이 되어 누었다가 다시 작은 아이가 되어서 나갔다.

(
SynthDef(\whitePipeBodies,
	{
		arg freqs = #[100, 100, 121, 121, 95, 95],
		gate = 1, amp = 0.2, durTrans = 0.1;

		var envFreq, sig, mod, dev, freqMod, trig, count, index;

		trig = Impulse.kr(1/2);
		count = PulseCount.kr(trig) % (freqs.size / 2);
		index = Sweep.ar(Impulse.kr(1/3), 0.8).poll(3, \index);

		freqMod = Select.kr(count * 2, freqs).poll(3, \freqMod);
		dev = (index ** count) * freqMod;
		mod = SinOsc.ar(freqMod * 1.5, 0, dev);

		envFreq = EnvGen.kr(Env.circle(freqs, [3, durTrans, 3, durTrans, 2, durTrans]), gate, doneAction: 2);
		sig = SinOsc.ar(envFreq + mod + [SinOsc.kr(3).range(0, 0.2), SinOsc.ar(1).range(-0.2, 0)]);

		Out.ar(0, sig * amp);
}).play;

)


원하는 것이 정확하게 무엇인지 모른다
그래서 소리를 들어 보며 찾으려고 하는 것.
그런데 들어서 찾는 것이 정말 내가 원했던 것일까?

(
SynthDef(\whitePipeBodies2,
	{
		arg freqs = #[100, 100, 121, 121, 95, 95],
		gate = 1, amp = 0.2, durTrans = 0.1, dt = 1.0;

		var trig, envFreq,
		sig, mod1, mod2, mod3, dev, freqMod, index,
		count, countMod, countWrap,
		useMod3;

		// trig = Impulse.kr(1/2);
		trig = Dust.kr(1);
		count = PulseCount.kr(trig);
		countMod = count % (freqs.size / 2);
		countWrap = count.wrap(1, 4)/(countMod + 1); // 나누는 숫자를 작게 할 수록 index의 경사가 급해진다. -> dev의 급한 변화를 만들 수 있다

		// dt = max(0.01, dt - (count * 0.01)); // Evn.circle의 시간 변화를 만들 수 있다.
		// dt.poll(10, \dt);

		useMod3 = CoinGate.kr(0.3, Impulse.kr(1));
		// useMod3 = (dt < 0.3).asInteger;
		// useMod3.poll(10, \um);

		index = Sweep.ar(Impulse.kr(1/3), 0.8 + countWrap/2);

		freqMod = Select.kr(countMod * 2, freqs);
		dev = (index ** countMod) * freqMod;
		// dev.poll(10, \dev);


		mod3 = SinOsc.ar(freqMod * 3.313, 0, dev * index) * Env.linen(0.01, 0.2, 0.1).kr(gate: useMod3); // .poll(10, \mod3);
		mod2 = SinOsc.ar(mod3 + freqMod * (2.7 + countWrap), 0, dev * index);
		mod1 = SinOsc.ar(mod2 + freqMod * 1.5, 0, dev);

		envFreq = EnvGen.kr(Env.circle(freqs, [3 * dt, durTrans, 3 * dt, durTrans, 2 * dt, durTrans]), gate, doneAction: 2);
		sig = SinOsc.ar(envFreq + mod1 + [SinOsc.kr(3).range(0, 0.2), SinOsc.ar(1).range(-0.2, 0)]);

		Out.ar(0, sig * amp);
}).add;
)


a = Synth(\whitePipeBodies2);
a.set(\dt, 3);
a.set(\freqs, #[100, 100, 121, 121, 95, 95]);
a.set(\freqs, Array.rand(3, 95, 150).dupEach.postln)
a.set(\freqs, ~stepRandArr.(num: 3, step: 17, min: 93, max: 160).dupEach);

멜로디가 되는 음들을 정해 나가는 알고리즘으로 무엇을 사용해 볼 수 있을까?

(
~stepRandArr = {|num = 3, step = 10, min = 100, max = 150|
	var n = (max - min / step).asInteger;
	var arr = min + (Array.rand(num, 0, n) * step);
	arr.postln;
	arr;
}
)

~stepRandArr.(num: 4, step: 7, min: 93, max: 160)


[1, 2, 3].dupEach

/*
// 10 print
/\\\/\\/\/\\/\
\\///\/\///\/\
\/\//\//\/\\/\
////\//\\\/\//
\\///\/\\/\\\/
////\\\\/\\\\/
*/

(// 1. Base
{
	arg freq = 10, modBase = 100, amp = 0.8, gate = 1, prob = 0.5;
	var sig, mod, env, coin, trig ;
	var numHarm = 10;

	trig = CoinGate.kr(prob, Impulse.kr(freq));
	coin = ToggleFF.kr(trig).asInteger.poll(10);

	sig = SinOsc.ar(Array.series(numHarm, 48, 0.2).midicps, mul: amp / numHarm).sum;
	mod = if(coin, SinOsc.ar(modBase * (PulseCount.kr(trig) % 8 + 1), mul: 0.5), 1);
	env = EnvGen.ar(Env.asr(), gate, doneAction: 2);

	Out.ar(0, Pan2.ar((sig * mod) * env, 0, amp));

}.play
)


(// 2. Impulse.ar 버전
{
	arg freq = 10, modBase = 100, amp = 0.5, gate = 1, prob = 0.5;
	var sig, mod, env, coin, trig;
	var numHarm = 10;

	trig = CoinGate.ar(prob, Impulse.ar(freq));
	coin = ToggleFF.ar(trig).asInteger.poll(10);

	sig = SinOsc.ar(Array.series(numHarm, 48, 0.2).midicps, mul: amp / numHarm).sum;
	mod = if(coin, SinOsc.ar(modBase * (PulseCount.ar(trig) % 8 + 1), mul: 0.5), 1);
	env = EnvGen.ar(Env.asr(), gate, doneAction: 2);

	Out.ar(0, Pan2.ar((sig * mod) * env, 0, amp));

}.play
)




// Synthdef 밖에서 위와 같은 조건으로 데이터를 만드는 함수가 있고
// 그 함수를 입력으로 삼아 소리를 만드는 Synth가 있도록 구조를 만들수 있을 듯.
// '나'의 포지션을 바꾸는 것이 만드는 변화를 소리에 적용할 수 있도록?

(
var num = 8;

// "1010" -> 10
~binStr2Dec = {|binStr = "1010"|
	var result = 0;
	var digits = Array.newClear(binStr.size);
	binStr.do{ |char, i| digits[i] = char.asInteger - 48;};
	digits.do{|d, i|var exp = digits.size - (i + 1); result = result + (d * (2**exp)) };
	// ("dec: " ++ result.asInteger).postln;
	result.asInteger;
};

// [0, 1, 0] -> "010"
~arr2BinStr = {|arr = #[0, 1, 0]|
	var binaryString = arr.collect { |digit| digit.asString }.join;
	// ("binStr: " ++ binaryString).postln;
	binaryString;
};


// ~ca를 실행할 때마다 다음 세대의 결과가 나오도록
~ruleSet = Array.fill(num, {0.5.coin.asInteger});
// ~ruleSet = #[0, 1, 0, 1, 1, 0, 1, 0];
~nextGen = Array.fill(num, {0.5.coin.asInteger});
// ~nextGen = [1, 0, 0, 1, 0, 1, 0, 1];
~ca = {|init|
	var size = num;
	var arr = init.copy;
	var result = Array.newClear(size);

	~nextGen[0] = arr[0];
	~nextGen[size - 1] = arr[size - 1];

	(size - 2).do{|i|
		var neighborBinStr = ~arr2BinStr.(arr[i..(i + 2)]);
		var idx = ~binStr2Dec.(neighborBinStr);
		var nextValue = ~ruleSet[idx];
		// nextValue.postln;
		~nextGen[i + 1] = nextValue;
	};
	~nextGen.postln;
};



// Sound
SynthDef(\caSound, {
	arg baseNote = 48, carNoteRatio = 0.2, modBase = 100, modBaseDiv = 1, amp = 0.8, ampMod = 0.1, gate = 1, prob = 0.5;
	var sig, mod, env, coin, trig ;
	var numHarm = num;
	var data = \data.kr(Array.fill(numHarm, {0.5.coin.asInteger}););
	numHarm.postln;

	mod = Mix.new(data.collect{|item, i| SinOsc.ar(modBase * (((i % numHarm) + 1) / modBaseDiv), mul: ampMod * item);});

	sig = SinOsc.ar(Array.series(numHarm, baseNote, carNoteRatio).midicps, mul: amp / numHarm);
	env = EnvGen.ar(Env.asr(), gate, doneAction: 2);
	sig = (sig * mod) !2;

	Out.ar(0, Pan2.ar(sig * env, 0, amp));

}, rates: [1.0]).add;
)

// Test
a = Synth(\caSound, [\data, ~nextGen]);
a.set(\data, ~nextGen = ~ca.value(~nextGen));
a.set(\baseNote, 24)
a.set(\modBaseDiv, 2)
a.set(\ampMod, 0.2)
a.set(\carNoteRatio, 0.2)


(
var dur = 0.6, num = 8;
a = Synth(\caSound, [\data, ~nextGen]);
fork{

	inf.do{
		~nextGen = Array.fill(num, {0.5.coin.asInteger});
		"reset".postln;

		rrand(16, 7).do{|i|
			var count = i % 6;
			a.set(\data, ~nextGen = ~ca.value(~nextGen));

			if (count < 4, {dur.wait;});
			if (count == 4, {(dur*2).wait;});
			if (count == 5, {(dur*3).wait;});
		};
		(dur*6).wait;
	}

}
)


// 단발적인 소리들이 반복되도록 바꿔 보기!
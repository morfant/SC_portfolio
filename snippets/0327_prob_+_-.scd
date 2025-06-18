(
// 25.03.27
// 더하기와 빼기의 확률
// basic rule
{
	arg ampCar = 0.4, ampMod = 3, amp = 0.9;
	var numMod = 20;
	var sigCar, sigMod, env;
	var countPos = 0, countNeg = 0, count = 0;
	var sig;

	var trigSrc = LFClipNoise.ar(100);
	var trigCoin1 = CoinGate.kr(0.5, trigSrc);
	var trigCoin2 = CoinGate.kr(0.5, trigSrc);
	countPos = PulseCount.kr(trigCoin1);
	countNeg = PulseCount.kr(trigCoin2);
	count = countPos - countNeg;
	count = count % numMod;
	count.poll(10, \count);
	// countPos.poll(10, \pos);
	// countNeg.poll(10, \neg);

	// env = EnvGen.kr(Env.perc())
	sigMod = Mix.fill(numMod, {|i| SinOsc.ar(100 + (i * 100), mul: (i < count).asInteger * ampMod / numMod)});
	sigCar = Mix.fill(numMod/2, {|i| SinOsc.ar((0.1 + (count / numMod)) * 10, mul: ampCar / numMod)});
	// sigCar = SinOsc.ar(300, mul: ampCar);
	sigCar = sigCar * (0.3 + sigMod);
	sig = sigCar;
	Out.ar(0, Pan2.ar(sig, 0, amp));
}.play;
)



(
// 25.04.02
// 더하기와 빼기의 확률 x 2 (chainging harmonics)
// Using .pow()
{
	arg ampCar = 0.4, ampMod = 5, amp = 0.9,
	carFreqMul = 10, // 전반적인 피치
	modFreqBase = 100, // 측파대의 피치
	powDiv = 4, // powDiv가 클 수록 발작(?)이 자주 발생
	probL = 0.5, probR = 0.5, // 두 확률을 차이나게 조정하면 일정한 경향성을 강화시킬 수 있다
	probU = 0.5, probD = 0.5; // 두 확률을 차이나게 조정하면 일정한 경향성을 강화시킬 수 있다

	var numMod1 = 30, numMod2 = 15;
	var sigCar, sigMod, env;
	var countPos1 = 0, countNeg1 = 0, countPos2 = 0, countNeg2 = 0, count1 = 0, count2 = 0;
	var sig, sig1, sig2;

	var trigSrc = LFClipNoise.ar(120);
	var trigCoinL = CoinGate.kr(probL, trigSrc);
	var trigCoinR = CoinGate.kr(probR, trigSrc);
	var trigCoinU = CoinGate.kr(probU, trigSrc);
	var trigCoinD = CoinGate.kr(probD, trigSrc);

	countPos1 = PulseCount.kr(trigCoinL);
	countNeg1 = PulseCount.kr(trigCoinR);
	countPos2 = PulseCount.kr(trigCoinU);
	countNeg2 = PulseCount.kr(trigCoinD);

	count1 = countPos1 - countNeg1;
	count1 = count1 % numMod1;
	// count1.poll(10, \count1);

	count2 = countPos2 - countNeg2;
	count2 = count2 % numMod2;
	// count2.poll(10, \count2);

	// countPos.poll(10, \pos);
	// countNeg.poll(10, \neg);

	sigMod = Mix.fill(numMod1, {|i|
		SinOsc.ar(
			freq: modFreqBase + midicps(30) * (3/2**(i/2)/(2*(i/5))),
			mul: Env.perc(attackTime: 0.1, releaseTime: 1.0, curve: [-4, 4]).kr(gate: (i < count1).asInteger))
		* (ampMod / numMod1).pow(1+[1.5, 2.7] + count2/powDiv) // count2가 작아지면 배음들이 급작스럽게 살아난다
	});
	sigCar = Mix.fill(numMod1/2, {|i| SinOsc.ar(freq: (0.1 + (count1 / numMod1)) * carFreqMul * (count2 * 1.7), mul: ampCar / numMod1)});

	sigCar = sigCar * ((2 * ampMod / numMod1) * (count2 / numMod2) + sigMod);
	sig = sigCar;
	Out.ar(0, sig * amp);
}.play;
)


(
// 25.04.02
// 더하기와 빼기의 확률 x 2 (glitch/noise)
// Using .wrap()
{
	arg ampCar = 0.4, ampMod = 4, amp = 0.3,
	carFreqMul = 10, // 전반적인 피치
	modFreqBase = 100, // 측파대의 피치
	powDiv = 4, // powDiv가 클 수록 발작(?)이 자주 발생
	probL = 0.5, probR = 0.5, // 두 확률을 차이나게 조정하면 일정한 경향성을 강화시킬 수 있다
	probU = 0.5, probD = 0.5; // 두 확률을 차이나게 조정하면 일정한 경향성을 강화시킬 수 있다

	var numMod1 = 30, numMod2 = 15;
	var sigCar, sigMod, env;
	var countPos1 = 0, countNeg1 = 0, countPos2 = 0, countNeg2 = 0, count1 = 0, count2 = 0;
	var sig, sig1, sig2;

	var trigSrc = LFClipNoise.ar(1000); // Trig를 테스트 하는 속도 - 작으면 소리가 변하는 경과를 볼 수 있다
	var trigCoinL = CoinGate.kr(probL, trigSrc);
	var trigCoinR = CoinGate.kr(probR, trigSrc);
	var trigCoinU = CoinGate.kr(probU, trigSrc);
	var trigCoinD = CoinGate.kr(probD, trigSrc);

	countPos1 = PulseCount.kr(trigCoinL);
	countNeg1 = PulseCount.kr(trigCoinR);
	countPos2 = PulseCount.kr(trigCoinU);
	countNeg2 = PulseCount.kr(trigCoinD);

	count1 = countPos1 - countNeg1;
	count1 = count1 % numMod1;
	// count1.poll(10, \count1);

	count2 = countPos2 - countNeg2;
	count2 = count2 % numMod2;
	// count2.poll(10, \count2);

	// countPos.poll(10, \pos);
	// countNeg.poll(10, \neg);

	sigMod = Mix.fill(numMod1, {|i|
		SinOsc.ar(
			freq: modFreqBase + midicps([30, 30 + (i+1)/numMod1]) * (3/2**(i/2)/(2*(i/5))),
			mul: Env.perc(attackTime: 0.1, releaseTime: 1.0, curve: [-4, 4]).kr(gate: (i < count1).asInteger))
		* (ampMod / numMod1) // .range와 .wrap이 여기에 적용된다. 원 신호가 아니라.
		.range(-1 - count1, 1 + count2)
		.wrap(
			-1*(0.1 + count1/numMod1 + count2/numMod2).scaleneg(-1),
			(0.1 + count1/numMod1 + count2/numMod2).scaleneg(-1)
			) // count2가 작아지면 배음들이 급작스럽게 살아난다
	});
	sigCar = Mix.fill(numMod1/2, {|i| SinOsc.ar(freq: (0.1 + (count1 / numMod1)) * carFreqMul * (count2 * 1.7), mul: ampCar / numMod1)});

	sigCar = sigCar * ((2 * ampMod / numMod1) * (count2 / numMod2) + sigMod);
	sig = sigCar;
	Out.ar(0, sig * amp);
}.play;
)



(
// 25.04.02
// 더하기와 빼기의 확률 x 2 (refined noise)
// Using .wrap()
{
	arg ampCar = 0.4, ampMod = 4, amp = 0.6,
	carFreqMul = 10, // 전반적인 피치
	modFreqBase = 100, // 측파대의 피치
	powDiv = 4, // powDiv가 클 수록 발작(?)이 자주 발생
	probL = 0.5, probR = 0.5, // 두 확률을 차이나게 조정하면 일정한 경향성을 강화시킬 수 있다
	probU = 0.1, probD = 0.9; // 두 확률을 차이나게 조정하면 일정한 경향성을 강화시킬 수 있다

	var numMod1 = 30, numMod2 = 15;
	var sigCar, sigMod, env;
	var countPos1 = 0, countNeg1 = 0, countPos2 = 0, countNeg2 = 0, count1 = 0, count2 = 0;
	var sig, sig1, sig2;

	var trigSrc = LFClipNoise.ar(300); // Trig를 테스트 하는 속도 - 작으면 소리가 변하는 경과를 볼 수 있다
	var trigCoinL = CoinGate.kr(probL, trigSrc);
	var trigCoinR = CoinGate.kr(probR, trigSrc);
	var trigCoinU = CoinGate.kr(probU, trigSrc);
	var trigCoinD = CoinGate.kr(probD, trigSrc);

	countPos1 = PulseCount.kr(trigCoinL);
	countNeg1 = PulseCount.kr(trigCoinR);
	countPos2 = PulseCount.kr(trigCoinU);
	countNeg2 = PulseCount.kr(trigCoinD);

	count1 = countPos1 - countNeg1;
	count1 = count1 % numMod1;
	// count1.poll(10, \count1);

	count2 = countPos2 - countNeg2;
	count2 = count2 % numMod2;
	// count2.poll(10, \count2);

	// countPos.poll(10, \pos);
	// countNeg.poll(10, \neg);

	sigMod = Mix.fill(numMod1, {|i|
		SinOsc.ar(
			freq: modFreqBase + midicps([30, 30 + (i+1)/numMod1]) * (3/2**(i/2)/(2*(i/5))),
			mul: Env.perc(attackTime: 0.1, releaseTime: 1.0, curve: [-4, 4]).kr(gate: (i < count1).asInteger))
		.range(-1 - count1, 1 + count2)
		.wrap(
			-1*(0.1 + count1/numMod1 + count2/numMod2).scaleneg(-1),
			(0.1 + count1/numMod1 + count2/numMod2).scaleneg(-1) // count2가 작아지면 배음들이 급작스럽게 살아난다
			) * (ampMod / numMod1); // 이 수가 .range.wrap을 거친 이후 sigMod에 곱해진다.
	});
	sigCar = Mix.fill(numMod1/2, {|i| SinOsc.ar(freq: (0.1 + (count1 / numMod1)) * carFreqMul * (count2 * 1.7), mul: ampCar / numMod1)});

	sigCar = sigCar * ((2 * ampMod / numMod1) * (count2 / numMod2) + sigMod);
	sig = sigCar;
	Out.ar(0, sig * amp);
}.play;
)


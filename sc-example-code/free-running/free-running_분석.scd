( // http://sccode.org/1-4TU

/*
<New-Metal Mistress Time>
A free-running oscillator piece. I was hoping the three elements had enough code in common that I could make an elegant generator for them, but not so.
*/

var duration = 60 * 5; // 300
var freqDrift = { |freq=200| LFDNoise3.ar(0.2, 0.1, freq.cpsmidi).midicps }; // 주파수를 미세하게 랜덤하게 변화시킴 계속해서
var masterVolume = -2.dbamp; 

play {
	var rootFreq = freqDrift.(26.midicps);
	// var rootFreq = 26.midicps;
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration, 0.25]), gate: 1, doneAction: 0); // 300초의 매우 긴 엔벨롭
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal, 1), -1, 1, -24, 0).dbamp;//0db ~(15초)~ -24db ~(15초)~ 0db, iphase : 1
	var sig = HPF.ar(
		({ |k|
			// ("k: " + k).postln; 0 ~ 15
			Pan2.ar(({ |i|
				// ("\ti: " + i).postln; 0 ~ ((k/2 + 1).asInteger - 1) : k에 따라 달라진다.
				Pulse.ar(
					(i * k + 2 / (k + 1) * rootFreq * (i + 1) * 0.0625 * 16), // 'freq' of Pulse
					LinLin.ar(LFTri.ar(rootFreq * (i + 1) / 1024), -1, 1, 0.5, 0.95) // 'width' of Pulse
				)} ! (k/2 + 1).asInteger).product // Pulse 신호 배열에 대한 Pan2 + .product 는 내부 신호가 곱해진 스테레오 신호가 됨.
			* (k + 1).reciprocal // = / (k+1) ==> k가 커질 수록 큰 수로 나누게 된다.
				* LinExp.ar(Blip.ar( // Blip을 이용하여 input의 음량 결정하는 이유는? ==> 주기적으로 커졌다 작아졌다 하는 형태를 만들 수 있다.
				(k + 5).nthPrime.reciprocal * rootFreq * 0.125, 3), -1, 1, -48.dbamp, 1).neg, // 'in' of Pan2 .neg의 유무는 들었을 때는 크게 영향이 없다.

			LFTri.ar((k + 1).nthPrime * rootFreq / 256) // 'pos' of Pan2
			)
		} ! 16).sum * -12.dbamp, // * 0.25...
		40 // cutoff freq
	);

	var compsig = Compander.ar(
		sig, sig, -48.dbamp, 1, XLine.ar(1, 0.125, duration), mul: Line.ar(0, 36, duration).dbamp // 0 -> 36db for duration
	);
	var final = LeakDC.ar(SinOsc.ar( // LeakDC.ar의 유무가 소리에 큰 변화를 주는 것 같지는 않음
		rootFreq * 2,
		GVerb.ar(
			compsig.sum,
			revtime: 2.5,
			drylevel: 0,
			earlyreflevel: 0,
			taillevel: -12.dbamp,
			mul: LinExp.ar(LFTri.ar(duration.reciprocal, 1), -1, 1, pi, pi * 0.25),
			add: compsig
		),
		mul: 0.5 * gate,
	), mul:  leveler);
	var verb = GVerb.ar(final.sum, 300, 4.5, drylevel: 0, earlyreflevel: -6.dbamp, taillevel: -12.dbamp, add: final);
	var env = DetectSilence.ar(gate + verb, doneAction: 2);
	verb * masterVolume;
};

play {
	var rootFreq = freqDrift.(
		(
			26.midicps * 4 * LinLin.ar(LFTri.ar(duration.reciprocal * 5), -1, 1, 3, 13).floor
			/ LinLin.ar(LFTri.ar(duration.reciprocal * 3), -1, 1, 13, 3).floor));
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration * 0.9, 0.25]), gate: 1, doneAction: 0);
		var leveler = LinLin.ar(LFTri.ar(duration.reciprocal * 15, 2), -1, 1, -72, 6).dbamp; // iphase: 2
	// sig 에 대한 코드는 위와 거의 동일함
	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				Pulse.ar(
					i * k + 2 / (k + 1) * rootFreq * (i + 1) * 0.0625 * 16,
					LinLin.ar(LFTri.ar(rootFreq * (i + 1) / 1024), -1, 1, 0.5, 0.95)
				)} ! (k/2 + 1).asInteger).product
				* LinExp.ar(Blip.ar(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.125, 3), -1, 1, -48.dbamp, 1).neg,
				LFTri.ar((k + 1).nthPrime * rootFreq / 256)
			)
		} ! 16).sum * -12.dbamp,
		40
	);
	var compsig = Compander.ar(
		sig, sig, -48.dbamp, 1, XLine.ar(1, 0.125, duration), mul: Line.ar(0, 36, duration).dbamp
	);
	var final = LeakDC.ar(SinOsc.ar(
		rootFreq * 4,
		GVerb.ar(
			compsig.sum,
			revtime: 2.5,
			drylevel: 0,
			earlyreflevel: 0,
			taillevel: -12.dbamp,
			mul: Line.ar(pi * 2, pi, duration), // 이 줄을 제외하고 동일
			add: compsig
		),
		mul: 0.5 * gate,
	), mul: leveler * AmpCompA.kr(root: rootFreq * 4)); // rootFreq * 4 이후의 주파수에 대해서 A-weight 보상 적용
	var verb = GVerb.ar(final.sum, 300, 4.5, drylevel: 0, earlyreflevel: 0.dbamp, taillevel: -24.dbamp, add: final);
	var env = DetectSilence.ar(gate + verb, doneAction: 2); // not using
	verb * -18.dbamp * masterVolume
};


play {
	var rootFreq = 26.midicps;
	var depthMod = LFSaw.kr(0.05).exprange(0.05, 5.0);
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration * 0.9, 0.25]), gate: 1, doneAction: 0);
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal, 3), -1, 1, -24, 6).dbamp;
	// iphase : 3, 위의 play 함수에서 각각 1, 2를 사용하여 leveler의 값이 증가하는 시점을 교차시키고 있음

	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				SinOsc.ar(i * k + 2 / (k + 1) * rootFreq * (i + 1))} ! 4).product
				* (k+1).reciprocal
				* LFSaw.kr(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.25, k/7 * 2
				).exprange(-24.dbamp, 1),
				LFTri.ar((k + 1).nthPrime * rootFreq)
			)
		} ! 16).sum * -18.dbamp, // 16, 가산되는 소리들의 갯수 결정
		40
	);
	var siggap = Amplitude.ar(sig).reciprocal.min(0.0625);
	var verb = GVerb.ar(
		sig.sum,
		roomsize: [80, 135, 283],
		revtime: depthMod * 2,
		drylevel: 0,
		taillevel: 0.dbamp * siggap,
		earlyreflevel: -6.dbamp * siggap,
		add: sig
	).sum * leveler * gate;
	// var env = DetectSilence.ar(verb, doneAction: 2);
	verb * masterVolume
}
)
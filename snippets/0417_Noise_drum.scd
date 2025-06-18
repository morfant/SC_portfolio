(
{
	arg index = 1, amp = 0.2;
	var size = 1024;
	var sig = Signal.newClear(size);
	var wt = sig.waveFill ({ |x, old, i|
		var jumpPoint = pi * 0.94;  // 이 값을 통해 불연속 지점 설정
		// x.postln;
		if (x.abs < jumpPoint, {
			sin(x)
		}, {
			// 파형의 끄트머리가 노이지 해진다 -> 분모가 0이 되면 server meter, freq analyzer가 먹통 되는 현상
			if (x < 0, {x / 20}, {x / (1 + 40.rand)});
		})
	}, -pi, pi);
	var buf = Buffer.loadCollection(s, wt.asWavetableNoWrap);
	// wt.plot;
	Out.ar(0, LeakDC.ar(Shaper.ar(buf, SinOsc.ar(40, [0, 0.5], mul: index))) * Env.perc().kr(doneAction: 2) * amp);
}.play
)

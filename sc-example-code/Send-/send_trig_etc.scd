(// SendTrig: UGen의 신호로 SynthDef의 아규먼트 제어
~syn_val = SynthDef(\valFromUGen, {
	arg tr_intv = 8, lfo_freq = 10;
	var impulse;

	impulse = Impulse.kr(tr_intv); // update rate

	SendTrig.kr(impulse, 100, MouseX.kr(0.0,1.0));
	SendTrig.kr(impulse, 101, MouseY.kr(0.0,1.0));
	SendTrig.kr(impulse, 102, LFSaw.ar(lfo_freq).range(0, 1));
}).play;

OSCdef(\getMouse, { arg ... args;
	var value, msg;
	msg = args[0];
	// Post <<< msg << nl;
	value = msg[3];
	switch (msg[2],
		100, {~mx = value},
		101, {~my = value},
		102, {~saw = value},
	);
}, '/tr');

CmdPeriod.doOnce{OSCdef(\getMouse).free};

// UGen 값을 통해 제어할 client 사이드 함수의 예시
// routine에서 .set
// 아두이노 등으로 신호를 보내는 함수가 될 수도 있다.
~syn_a = Synth(\default);

fork {
	inf.do {
		~syn_val.set(\tr_intv, ~mx.linlin(0.0, 1.0, 1, 64).postln);
		~syn_a.set(\freq, (~saw * 127).round.midicps, \amp, ~my);
		0.01.wait;
	}
}
)


(// ERROR: can't set a control to a UGen
~syn_a = Synth(\default);

fork {
	inf.do {
		~syn_a.set(\amp, LFSaw.kr(1).range(0.0, 1.0));
		0.01.wait;
	}
}
)



(// SendReply: Pitch, amp 값을 가져와 그림의 요소에 적용하기
var run = true, w = Window("canvas", Rect(100, 800, 300, 300)).front;
var px = 150, py = 150, mx = 150, my = 150;
var r = 15;
w.view.background = Color.white;

w.drawFunc = { |v|
	// Pen.fillColor = Color.blue;
	Pen.width = 1;
    Pen.strokeColor = Color.black;
    Pen.moveTo(px@py);
	mx = (~amp * 3000);
	my = ~freq.linlin(0, 700, 0, 300);
    Pen.lineTo(mx@my);
    Pen.fillStroke;
	px = mx;
	py = my;
};

{ while { run } { w.refresh; 0.05.rand.wait } }.fork(AppClock);
CmdPeriod.doOnce{w.close};

// SendReply
b = Buffer.read(s, ~path1);

SynthDef(\amplitudeAnalysis, {|in=0, rate=60|
	// PlayBuf의 numChannels 를 2로 하면 그 아래 amp, freq 값들이 채널 별로 하나 씩 만들어 지고 SendReply를 통해 보내지는 메시지 형식이 달라진다.
	var input = PlayBuf.ar(1, b, BufRateScale.kr(b) * 1.0, loop: 1, doneAction: 2);
	var amp = Amplitude.kr(input);
	var freq = Pitch.kr(input); // return [freq, hasFreq]
    var trig = Impulse.kr(rate);
	SendReply.kr(trig, '/analysis', [amp, freq[0], freq[1]],);
	Out.ar(0, input!2);
}).play;


OSCdef(\listenAnalysis, { arg ... args;
	var msg;
	msg = args[0];
	// Post <<< msg << nl;
	~amp = msg[3];
	~hasFreq = msg[5]; // Pitch UGen이 Pitch 측정에 성공했는지 알려주는 값. 1이면 성공, 0이면 실패로 간주.
	if (~hasFreq == 1, {~freq = msg[4]});
	// ~freq = msg[4];


}, '/analysis');

CmdPeriod.doOnce{OSCdef(\listenAnalysis).free};
)



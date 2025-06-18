b = Buffer.read(s, "/Users/giy/Desktop/audio_sample/beat.aiff");
b.play

(
var lastPeak1 = 0.0;
var lastPeak2 = 0.0;

OSCdef(\peakWatcher1, { |msg|
	var val = msg[3];
	if (val > lastPeak1) {
		lastPeak1 = val;
		("New peak ---BEFORE---: " + val.round(0.0001)).postln;
	};
}, '/peak/before');

OSCdef(\peakWatcher2, { |msg|
	var val = msg[3];
	if (val > lastPeak2) {
		lastPeak2 = val;
		("New peak +++AFTER+++: " + val.round(0.0001)).postln;
	};
}, '/peak/after');


{
	var sig, peak;

	sig = PlayBuf.ar(2, b, loop: 1);

	// Compander 적용 전에 peak 측정
    peak = PeakFollower.ar(sig);
    SendReply.kr(Impulse.kr(32), '/peak/before', peak);

	// 이후 컴팬더 적용
	sig = Compander.ar(sig, sig, 0.6, 1.0, 0.8, 0.001);

	// Compander 적용 후에 peak 측정
	peak = PeakFollower.ar(sig);
	SendReply.kr(Impulse.kr(32), '/peak/after', peak);

	sig;
}.play;
)
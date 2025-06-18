
(
// 마우스를 움직여 areal과 aimag를 바꾸어 가며 소리를 들어보자.
// scope, freqscope 창에서의 형태 변화를 관찰해 보자.
SynthDef("conformer2", { |out, amp = 0.5|
    var in, chain, sound;
	in = LFSaw.ar(100);
    chain = FFT(LocalBuf(2048), in);
	chain = PV_ConformalMap(chain, MouseX.kr(0.01,2.0, 'exponential').poll(5, \areal), MouseY.kr(0.01,10.0, 'exponential').poll(5, \aimag));
    sound = IFFT(chain);

    Out.ar(out, Pan2.ar(sound * amp, 0));
}).play;
)
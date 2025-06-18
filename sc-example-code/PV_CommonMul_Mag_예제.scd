
(
b = Buffer.alloc(s, 2048, 1);
c = Buffer.alloc(s, 2048, 1);
d = Buffer.read(s, Platform.resourceDir +/+"sounds/a11wlk01.wav");
)

(
// 마우스를 왼쪽으로 하면 tolerance가 작아진다 ==> uncommon 한 것들이 많아진다
// 마우스를 아래쪽으로 하면 remove 값이 0에 가까워진다(1보다 작다) ==> uncommon 한 것들의 magnitude가 작아진다.
SynthDef("help-commonMag", { arg out=0, bufnumA=0, bufnumB=1, soundBufnum=2;
    var inA, inB, chainA, chainB, chain;
    inA = HPF.ar(Mix(LFSaw.ar([100, 150], 0, 0.2)), 1200);
    inB = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
    chainA = FFT(bufnumA, inA);
    chainB = FFT(bufnumB, inB);
	// chain = PV_CommonMag(chainA, chainB, MouseX.kr(0, 50).poll(5, \tolerance), MouseY.kr(0, 1).poll(5, \remove)); // 1) PV_CommonMag
	chain = PV_CommonMul(chainA, chainB, MouseX.kr(0, 50).poll(5, \tolerance), MouseY.kr(0, 1).poll(5, \remove));	 // 2) PV_CommonMul
    Out.ar(out,  IFFT(chain).dup);
}).play(s,[\out, 0, \bufnumA, b.bufnum, \bufnumB, c.bufnum, \soundBufnum, d.bufnum]);
)


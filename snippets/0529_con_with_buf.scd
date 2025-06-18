b = Buffer.read(s, ~path1);
b.play;

(
a = {
    arg amp = 0.2;
    var sig, con, buf, chain;

    sig = LatoocarfianN.ar(
        a: LFNoise2.kr(16).range(0.1, 1.3),
        b: LFNoise2.kr(2).range(2.5, 3.5)
    );

    chain = FFT(LocalBuf(4096, 2), sig);
    chain = PV_BrickWall(chain, 0.01);

    buf = PlayBuf.ar(2, b, BufRateScale.kr(b) * 2, loop: 1);
    buf = LPF.ar(buf, 60);

    sig = IFFT(chain);

    con = Convolution.ar(sig * 40, buf * 0.05, 4096);

    sig = con;

    sig = Mix.fill(4, {
        CombL.ar(sig, 0.4, rrand(0.1, 0.2), rrand(0.3, 0.6)) * 0.5
    });

    4.do{
        sig = AllpassL.ar(sig, 0.4, rrand(0.1, 0.3), rrand(0.5, 1.0))
    };

    // sig = LeakDC.ar(sig);
    sig * amp!2;

}.play
)
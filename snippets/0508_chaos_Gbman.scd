

(
{
    arg freq = 20;
    var rx, ry, rsum, pulse, sig;
    rx = LFNoise1.kr(freq).range(-200, 200);
    ry = LFNoise2.kr(freq).range(-100, 100);
    rsum = rx + ry;
    // rsum.poll(10);
    pulse = LFPulse.kr(abs(rsum) * 0.2, width: max(abs(rsum).reciprocal * 2, 0.06));
    sig = LeakDC.ar(GbmanN.ar([50, 100, 220, 40] * abs(rsum) * pulse));
    sig = sig * 0.01;

}.play(s);
)

(//harmonizer
{
  var in, sig, speed, fil, pr, pd, td, ws;
  speed = 1;
  pr = 1;
  pd = 0;
  td = 0.05;
  ws = 0.1;
  // in = PlayBuf.ar(1, ~buf, BufRateScale.kr(~buf) * speed, loop: 1);

  in = SoundIn.ar(0);

  sig = Mix.ar([
    PitchShift.ar(in, ws, pr, pd, td, 0.5),
    PitchShift.ar(in, ws, pr*(2**(4/12)), pd, td, 0.3),
    PitchShift.ar(in, ws, pr*(2**(6/12)), pd, td, 0.12)
  ]);

  fil = FreeVerb.ar(sig, 0.5, 0.9, 0.1, 0.5) !2;

  }.play;
);
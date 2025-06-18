(// y[n] = a0x[n] + a1x[n-1] + a2x[n-2]
{
  var in, del1, del2, a0, a1, a2;
  a0 = 0.4032;
  a1 = 0.2355;
  a2 = 0.3612;
  in = WhiteNoise.ar(mul: 0.1);
  del1 = Delay1.ar(in);
  del2 = Delay2.ar(in);

  (in*a0) + (del1*a1) + (del2*a2);

}.play;
);


(
// y[n] = coefs[0]x[n] + coefs[1]x[n-1] ...
// 26th order FIR filter(Dodge p.204)
{
  var in, size, coefs, sigs, rslt;
  rslt = 0;
  coefs = [
    -0.001585, -0.001456, -0.001187, 0.00, 0.003046, 0.017826,
    0.030043, 0.044782, 0.060645, 0.075909, 0.088620, 0.097048, 0.1];

  coefs = coefs.mirror;
  // coefs.postln;
  size = coefs.size;
  // size.postln;
  sigs = Array.newClear(size);

  in = WhiteNoise.ar(mul: 0.1);
  // in = LFNoise0.ar(50, mul: 2.0);    // Delayed sig plot test
  size.do{|i| sigs[i] = in};

  // Delay part
  size.do{|i|
    (i+1).do{sigs[i] = Delay1.ar(sigs[i])};
  };

  // sigs;
  rslt = coefs*sigs;
  Mix.ar(rslt);

}.play;
);




(// y[n] = coefs[0]x[n] + coefs[1]x[n-1] ...
// 26th order FIR filter(Dodge p.204)
// Using DelayN
{
  var coefs, sigs, src, rslt;
  coefs = [-0.001585, -0.001456, -0.001187, 0.00, 0.003046, 0.008814, 0.017826, 0.030043, 0.044762, 0.060645, 0.075909, 0.088620, 0.097048, 0.1].mirror();
  src = WhiteNoise.ar(0.1);
  sigs = Array.fill(coefs.size, src);

  // Delay part
  27.do{|i| sigs[i] = DelayN.ar(src, i*(1/s.sampleRate), i*(1/s.sampleRate))};

  rslt = coefs*sigs;
  Mix.ar(rslt);

}.play;
)

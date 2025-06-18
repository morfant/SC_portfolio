Formant
(

var sig, table, parts, prons;
parts = #[sop, ten];
prons = #[a, e, i, o, u];

table = #[
  [// Sop
    [[800, 1150, 2900, 3900, 4950], [0, -6, -32, -20, -50], [80, 90, 120, 130, 140]], //sop_a
    [[350, 2000, 2800, 3600, 4950], [0, -20, -15, -40, -56], [60, 90, 100, 150, 200]], //sop_e
    [[270, 2140, 2950, 3900, 4950], [0, -12, -26, -26, -44], [60, 90, 100, 120, 120]], //sop_i
    [[450, 800, 2830, 3800, 4950], [0, -11, -22, -22, -50], [70, 80, 100, 130, 135]], //sop_o
    [[325, 700, 2700, 3800, 4950], [0, -16, -35, -40, -60], [50, 60, 170, 180, 200]], //sop_u
  ],
  [// Ten
    [[650, 1080, 2650, 2900, 3250], [0, -6, -7, -8, -22], [80, 90, 120, 130, 140]], //ten_a
    [[400, 1700, 2600, 3200, 3580], [0, -14, -12, -14, -20], [70, 80, 100, 120, 120]], //ten_e
    [[290, 1870, 2800, 3250, 3540], [0, -15, -18, -20, -30], [40, 90, 100, 120, 120]], //ten_i
    [[400, 800, 2600, 2800, 3000], [0, -10, -12, -12, -26], [40, 80, 100, 120, 120]], //ten_o
    [[350, 600, 2700, 2900, 3300], [0, -20, -17, -14, -26], [40, 60, 100, 120, 120]] //ten_u
  ]
];


parts.do{|pa, i|
  prons.do{|pr, j|

    // ex) formant_sop_a
    SynthDef.new("formant_"++pa++"_"++pr, {
      arg ampdiv = 10, midi = 72, gate = 1;
      var sig, freq, freq_fund, env;
      freq_fund = midicps(midi);

			env = Linen.kr(gate, releaseTime: 0.01, doneAction: 2);

      freq = freq_fund + SinOsc.kr(6, 0, midicps(midi + XLine.kr(0.008, 0.2, 1.3)) - freq_fund);

      sig = Mix.ar([
        Formant.ar(freq, table[i][j][0][0], table[i][j][2][0], table[i][j][1][0].dbamp),
        Formant.ar(freq, table[i][j][0][1], table[i][j][2][1], table[i][j][1][1].dbamp),
        Formant.ar(freq, table[i][j][0][2], table[i][j][2][2], table[i][j][1][2].dbamp),
        Formant.ar(freq, table[i][j][0][3], table[i][j][2][3], table[i][j][1][3].dbamp),
        Formant.ar(freq, table[i][j][0][4], table[i][j][2][4], table[i][j][1][4].dbamp)

      ]/ampdiv);

      Out.ar(0, Pan2.ar(sig * env, 0));

    }).add;

  }
}
)



Synth(\formant_ten_a, [\midi, 69, \ampdiv, 20]);
Synth(\formant_ten_e);
Synth(\formant_ten_i);
Synth(\formant_ten_o);

(
Synth(\formant_ten_u, [\midi, 64]);
Synth(\formant_sop_u, [\midi, 72]);
)


(
Pspawner({ | sp |
    sp.par(Pbind(*[
		instrument: Pseq([
			\formant_ten_a,
			\formant_ten_e,
			\formant_ten_i,
			\formant_ten_o,
			\formant_ten_u
		], inf),
		midi: Pseq((52,53..60).mirror, 2), dur: 0.5, legato: 1.2] ));

	sp.seq(
		Pbind(*[
		instrument: Pseq([
			\formant_sop_a,
			\formant_sop_e,
			\formant_sop_i,
			\formant_sop_o,
			\formant_sop_u,
		], inf),
			midi: Pseq(((52,53..60)+10).mirror, 2), dur: 0.5, legato: 1.2] ));
	sp.suspendAll;
}).play
)





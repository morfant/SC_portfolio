(
SynthDef(\chyap, {|fc = 2000, fl = 40, bus = 0, gate = 1, dense = 200, rq = 0.1, amp = 0.2|
    var in, filt;
	in = Blip.ar(EnvGen.kr(Env.perc(0.001, 0.1), gate, levelScale: fl, doneAction:2), dense);
    filt = RLPF.ar(in, fc, rq);
	filt = HPF.ar(filt, 600);
	Out.ar(bus, filt * amp)
}).add
);

Synth(\chyap, [\fc, 4000]);

(
Pbind(
	\instrument, \chyap,
	\fc, Pwhite(2000, 4000),
	\amp, 0.2,
	\dur, Prand([1, 2, 4, 8]/4, inf),
	\fl, 12
).trace.play
)


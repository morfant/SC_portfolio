(
SynthDef(\varPolyTest_2, {
	arg num = 30, freq = 300, envdur = 1.0;
	var maxNum = 30;
	var mixSig, env;
	env = EnvGen.kr(Env.sine(envdur), doneAction:2);
	mixSig = {|i| SinOsc.ar(freq * rrand(2.2, 5), mul: 1 / num * 0.5) * (i < num) } ! maxNum;
	Out.ar(0, mixSig.sum * env ! 2);
}).add;
)


(
{
var n = 10, sig;
sig = {|i| ("i: " + i).postln; SinOsc.ar(100 * i, mul: 1/n * 0.5); } ! n;
	sig.sum!2;
}.play

)



(

Pbind(
	\instrument, \varPolyTest_2,
	\freq, Pwhite(300, 700),
	\envdur, Pwhite(3, 5),
	\dur, 2,
	\num, Pexprand(2, 30, 20).round
).trace.play

)

(// ping pong delay
f = {
	arg dt = 0.1, dry = 0.5, wet = 0.5, note = 60, fbdk = 0.5;
	var source, local, trig, freq, env, feedback;
	trig = Impulse.kr(1);
	freq = LFPulse.kr(0.125).range(73, 77).midicps.varlag(0.5, warp:3);
	source = Mix.fill(5, {|i| VarSaw.ar(freq / (i + 1), width: TRand.kr(0.2, 0.9, trig), mul: 0.4/(i+1))});
	env = EnvGen.kr(Env.perc(), trig);
	source = source * env;

	feedback = LocalIn.ar(2);
	local = feedback + [source, 0]; // read feedback, add to source
	local = DelayN.ar(local, 0.5, dt); // delay sound
	// reverse channels to give ping pong effect, apply decay factor
	LocalOut.ar(local.reverse * fbdk);
	(dry * source) + (wet * local);
}.play;
)


(
d = 0.01;
w = 1.0 - d;
f.set(\dry, d, \wet, w, \dt, 0.25, \fbdk, 0.8)
)
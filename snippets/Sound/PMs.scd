
// PM
(
{
	var mod = LFSaw.ar(10).range(0, LFNoise2.ar(3).range(pi, 2pi)).poll(10);
	SinOsc.ar(220) *
	max(0, SinOsc.ar(120, mod))
		// SinOsc.ar(120, mod)
!2}.play;
)

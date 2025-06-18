// RM 시에
// mod 신호를 0 이상의 값들만 사용하면 배음들이 많이 생긴다
{SinOsc.ar(220, mul: max(0, SinOsc.ar(80)))*0.5!2}.play
{SinOsc.ar(220) * SinOsc.ar(80)*0.5!2}.play


{SinOsc.ar(220, mul: max(0, SinOsc.ar(80)))*0.5!2}.play; // Mod 신호의 양수만 사용
{SinOsc.ar(220) * min(0.2, max(0, SinOsc.ar(120)))*0.5!2}.play; // Mod 신호를 일정 amp 안으로 제한



(
{
	var mod = LFSaw.ar(10).range(0, LFNoise2.ar(3).range(pi, 2pi)).poll(10);
	SinOsc.ar(220) *
	max(0, SinOsc.ar(120, mod))
	// SinOsc.ar(120, mod)
	!2}.play;
)


(
// SynthDef 준비
SynthDef(\sound, {
	arg note = 60, amp = 0.1;
	var sig;
	sig = Saw.ar(note.midicps * [1, 1.25], mul: 0.01);
	Out.ar(0, sig !2);
}).add;


// Ndef 준비
Ndef(\sound, {|note = 60| Saw.ar(note.midicps * [1, 1.25], mul: 0.01)});
Ndef(\sound).set(\note, 40);
)


// MIDI 장치 준비
MIDIClient.init;

MIDIClient.sources;
MIDIClient.destinations;

MIDIIn.connectAll;
MIDIIn.disconnectAll;


// MIDI 입력에 대한 반응 정의
(
var state = Array.fill(2, {0});

MIDIdef.noteOn(\noteOnTest, {
	|val, num, chan, src|
	"noteOn".postln;
	[val, num, chan, src].postln;

	switch (num,
		64, {state[0] = (state[0] + 1) % 2; state.postln; if (state[0] == 1, {Ndef(\sound).play}, {Ndef(\sound).stop})},
		65, {state[1] = (state[1] + 1) % 2; state.postln; if (state[1] == 1, {~syn = Synth(\sound)}, {~syn.free})}
	);

}).permanent_(true);


MIDIdef.cc(\ccTest, {arg ...args;
	var val, num;
	"cc".postln;
	args.postln;
	val = args[0];
	num = args[1];
	switch (num,
		48, {Ndef(\sound) !? {Ndef(\sound).set(\note, val)} }, // set Ndef
		49, {~syn !? {~syn.set(\note, val)} }, // set Synth
	);

}).permanent_(true);
)

// 개별 MIDIdef들 free
MIDIdef(\noteOnTest).free;
MIDIdef(\ccTest).free;

// 모든 MIDIdef들 free
MIDIdef.freeAll;

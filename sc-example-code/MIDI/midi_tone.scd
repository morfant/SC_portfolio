MIDIClient.init;

MIDIClient.sources;
MIDIClient.destinations;


MIDIIn.connectAll;
MIDIIn.disconnectAll;


~busSrc.scope;
~busSrc.index;


(
~bend = 1;
~notes = Array.newClear(128);
~mod = 0;
~busSrc = Bus.audio(s, 2);
~fil = nil;
~filToggle = false;
~ff = 100;

MIDIdef.noteOn(\noteOnTest, {
  |vel, num, chan, src|
  var bus = 0;

  // "noteOn".postln;
  // [vel, num, chan, src].postln;



  if (~filToggle == true, {
    bus = ~busSrc;
  }, {
    bus = 0;
  });

  ~notes[num] = Synth(\note, [
    \freq, num.midicps,
    \bend, ~bend,
    \modf, ~mod,
    \amp, vel.linlin(0, 128, 0.0, 0.5),
    \gate, 1,
    \out, bus
  ]);

}).permanent_(false);

MIDIdef.noteOff(\noteOffTest, {
  |vel, num, chan, src|

  // "noteOff".postln;
  ~notes[num].set(\gate, 0);
  ~notes[num] = nil;
});


MIDIdef.bend(\bendTest, {
  |val, chan, src|
  [val, chan, src].postln;

  ~bend = val.linlin(0, 16383, -2.0, 2.0).midiratio;
  ~notes.do{|synth| synth.set(\bend, ~bend)};
});

MIDIdef.cc(\ccTest, {
  |vel, num, chan, src|

  [vel, num, chan, src].postln;

  if (num == 50, {
    if (vel == 127, {
      ~filToggle = true;
      ~notes.do{|synth| synth.set(\out, ~busSrc)};
      ~fil = Synth.tail(1, \fil, [\ff, ~ff]);

    }, {
      ~filToggle = false;
      ~notes.do{|synth| synth.set(\out, 0)};
      ~fil.free;
      ~fil = nil;
    });
  });


  if (num == 1, {
    if (~filToggle == false, {
      ~mod = vel.linlin(0, 127, 0, 20);
      ~notes.do{|synth| synth.set(\modf, ~mod)};
    }, {
      ~ff = vel.linlin(0, 127, 100, 2000);
      ~fil.set(\ff, ~ff);
    });
  });

});

SynthDef(\note, {
  |out = 0, freq = 500, amp = 0.5, gate = 0, bend = 1, modf = 0|
  var sig, env, sigmod;
  // sig = LFPar.ar(freq * bend);
  sig = Impulse.ar(freq * bend);
  sigmod = SinOsc.kr(modf).range(0.0, 1.0);
  env = EnvGen.kr(Env.adsr(), gate, doneAction: 2);

  Out.ar(out, Pan2.ar(sigmod * sig * env, 0, amp));

}).add;

SynthDef(\fil, {
  |out = 0, ff = 100|
  var sig;
  sig = RHPF.ar(In.ar(~busSrc, 1), ff, 0.2);
  Out.ar(out, Pan2.ar(sig, 0));
}).add;



)





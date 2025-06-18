
(
a = Signal.newClear(8192);
a.waveFill({ arg x, old, i; sin(frac(x));}, 0, pi);
l = Array.newFrom(a);
b = Buffer.loadCollection(s, l, 1, {|buf| {LeakDC.ar(OscN.ar(buf, 30, mul: 0.2))}.play});
)
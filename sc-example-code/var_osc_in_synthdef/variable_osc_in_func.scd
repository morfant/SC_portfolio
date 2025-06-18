
(
~vp = {arg n = 10, freq = 200;
	var ratio = Array.rand(n, 2.2, 5);
	~sig = Array.newClear(n);
	n.do{|i|
		~sig[i] = {SinOsc.ar(freq * ratio[i], mul: 1/n * 0.5)}
	};
	~sig.sum;
};
)

~synthTest = {~vp.value(1 + 10.rand.postln, 200)}.play;
(
SynthDef(\snd, {
	arg pitch, pos, amp;
	var snd, env, pan;
	snd = Saw.ar(midicps(pitch));
	env = EnvGen.ar(Env.perc(), 1, doneAction:2);
	snd = snd * env;
	pan = Pan2.ar(snd, pos);
	Out.ar(0, pan * amp);
}).add;
);


(
a =
Pbind(
	\instrument, \snd,
	\pitch, Pseq(60 + (0..14).scramble, 1),
	\dur, Pbrown(0.1, 1, 0.125, inf),
	\amp, Prand([0.2, 0.5, 1], inf),
	\pos, Pbrown(-1, 1, 0.125, inf),

);

(
b =
Pbind(
	\instrument, \snd,
	\pitch, Pseq(60 + (15..29).scramble, 1),
	\dur, Pwhite(0.05, 0.5, inf),
	\amp, Prand([0.2, 0.5, 1], inf),
	\pos, Pbrown(-1, 1, 0.125, inf),

)
);
(
c =
Pbind(
	\instrument, \snd,
	\pitch, Pseq(60+ (30..44).scramble, 1),
	\dur, Pgeom(0.05, 1.1, inf),
	\amp, Prand([0.2, 0.5, 1], inf),
	\pos, Pbrown(-1, 1, 0.125, inf),

));
)


/* event들로 이루어진 stream에서 각각의 event를 가져와 소리내기 */
// Pbind 도움말 문서의 Examples 참고

d = Pseq([a, b, c].scramble, 3).trace(\dur, prefix: "dur: "); // event의 속성 중 \dur 만 출력하고 싶을 때
r = d.asStream; // r 은 event들이 들어있는 Routine이 된다.
r.reset;
r.next(()); // 빈 event를 .next 메시지의 아규먼트로 전달해서, r.next를 통해 나오는 event의 속성들을 빈 event로 합친다.
r.next(()).play; // r의 속성들이 차례로 담겨 나오는 event를 play 한다.






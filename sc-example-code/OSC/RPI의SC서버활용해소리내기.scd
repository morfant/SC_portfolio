// 혹시 필요할 경우 모든 OSC 메시지 출력
a = OSCFunc.trace(true, false);
a.free;


// OSC 메시지 보내기
n = NetAddr("192.168.0.35", NetAddr.langPort);
n.sendMsg("/test", "hi")




// remote 서버 제어
// on machine running the server : RPI sclang 에서 실행
(
s.options.bindAddress = "0.0.0.0"; // allow connections from any address
s.options.maxLogins = 2; // set to correct number of clients
s.boot;
)


// on remote machine connecting to server : 노트북에서 실행
(
o = ServerOptions.new;
o.maxLogins = 2;
t = Server.remote(\remote, NetAddr("192.168.0.35", 57110), o); // 이제부터 t는 RPI의 SC 서버를 지칭
)


// *주의* 무엇이든 실행 후 free 할 수 있게 변수에 넣어두자
// t 서버에서 소리내기
a = {PinkNoise.ar(0.01)!2}.play(t);
a.free;


// Server Command 사용
t.sendBundle(0.2, ["/s_new", "default", x = t.nextNodeID, 0, 1], ["/n_set", x, "amp", 0.01] );
t.sendMsg("/n_free", x);



// SynthDef 사용
(
SynthDef.new(\mtest, {
	var sig = SinOsc.ar(\freq.ar(440), mul: 0.1);
	Out.ar(0, \amp.ar(0.1) * Pan2.ar(sig * EnvGen.kr(Env.perc(), \gate.kr(1), doneAction: 2), 0));
}).add;
)

// remote 서버에서 소리내기 : target 변경
a = Synth(\mtest, [\amp, 0.1], t);
a.free;


// Pbind에서 target server 변경
(
p = Pbind(
	\instrument, \mtest,
	\amp, 0.11,
	\freq, Pseries(60, 1, 12).midicps,
	\dur, 1,
	\server, t // t 서버에서 소리가 나도록
).play
)

p.play
p.stop
p.resume
p.reset






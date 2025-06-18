

NetAddr.localAddr; // Client(sclang)의 주소 확인. sclang의 기본 포트는 57120.

OSCFunc.trace(true); // Turn posting on
OSCFunc.trace(false); // Turn posting off

(
o.free;
o = OSCdef(\osctest, {
  arg msg, time, addr, recvPort;
  ("msg:" + msg).postln;
  ("time:" + time).postln;
  ("addr:" + addr).postln;
  ("recvPort:" + recvPort).postln;

  if (msg[1] != 0, {
    a.free;
    a = Synth(\default, [\freq, msg[1]]);
  }, {
    a.free;
  });


}, '/fromOutside'); // create the OSCFunc with address pattern
)

NetAddr.localAddr;


n = NetAddr("localhost", 57120);
n.sendMsg(\fromOutside, 400);


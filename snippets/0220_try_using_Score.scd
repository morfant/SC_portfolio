(
// SynthDef 등록

~tc = TempoClock.new(6); // 템포 클럭(4 bps = 분당 240 BPM 정도)

// ~setA, ~setB, ~setC를 'OSC 메시지'로 재정의
~setA = ["/s_new", \lone, -1, 1, 1, \n, 10, \freq, 450 + rand2(1.0), \amp, 0.3];
~setB = ["/s_new", \lone, -1, 1, 1, \n, 10, \freq, 1420 + rand2(1.0), \amp, 0.3];
~setC = ["/s_new", \lone, -1, 1, 1, \n, 10, \freq, 120 + rand2(1.0), \amp, 0.3];


~score1A = [
	[ ~setA, 2 ],   // ~setA 호출 후 3초 대기
	[ ~setB, 1 ],
	[ ~setC, 3 ],
	[ ~setC, 2 ],
	[ ~setA, 4 ],
	[ ~setA, 1 ]
];


~score1B = [
	[ ~setC, 1 ],
	[ ~setC, 1 ],
	[ ~setC, 2 ],
	[ ~setB, 3 ],
	[ ~setA, 1 ],
	[ ~setA, 5 ]
];

)

(
var sc = Score.new;
var currentTimeA = 0, currentTimeB = 0;

TempoClock.default.tempo = 2.0;

// 2) score1A 시퀀스 추가
~score1A.do { |item|
    var msg = item[0]; // 예: ["/n_set", ~synID, \freq, 440]
    var dur = item[1]; // 다음 이벤트까지 대기할 시간

    // 현재 시각 currentTimeA에 msg를 보낼 예정
    sc.add([currentTimeA, msg]);
    currentTimeA = currentTimeA + dur; // 다음 이벤트 시각으로 이동
};

// 3) score1B 시퀀스 추가
~score1B.do { |item|
    var msg = item[0];
    var dur = item[1];

    sc.add([currentTimeB, msg]);
    currentTimeB = currentTimeB + dur;
};

// 4) 시간 순으로 정렬(권장)
sc.sort;
sc.postcs;
// 5) 재생(실시간) 또는 오프라인 렌더링
// 실시간 플레이
sc.play;

// 또는 오프라인 렌더링 예시 (recordNRT)
// sc.recordNRT(
//   outputFilePath: Platform.userHome +/+ "Desktop/myScoreRender.aiff",
//   sampleRate: 44100,
//   headerFormat: "AIFF",
//   sampleFormat: "int16",
//   options: ServerOptions.new.numOutputBusChannels_(2),
//   action: { "NRT 렌더링 완료!".postln; }
//);
)

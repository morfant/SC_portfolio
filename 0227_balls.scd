(
~buf_1 = Buffer.read(s, "/Users/giy/Desktop/audio_sample/piano_sample2.wav");
~buf_1 = Buffer.read(s, "/Users/giy/Desktop/audio_sample/piano_sample3.wav");
~buf_1 = Buffer.read(s, "/Users/giy/Desktop/audio_sample/hat.wav");
)

~buf_1.numFrames
~buf_1.play

(

SynthDef(\bufReader, {
	arg out = 0, bufnum, speed = 1.0, amp = 0.2, pan = 0.0;
	var frames, phase, sig;
	// 버퍼의 전체 프레임 수
	frames = BufFrames.kr(bufnum);
	// Phasor: 초기 phase는 0, increment로 speed를 사용, phase 범위는 0 ~ frames
	phase = Phasor.ar(
		0,
		speed * BufRateScale.kr(bufnum),  // speed 값에 BufRateScale을 곱해 보정
		0,
		frames,
		0
	);
	sig = BufRd.ar(2, bufnum, phase, loop: 1, interpolation: 4);
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;


)


a = Synth(\bufReader, [\bufnum, ~buf_1])



(
// 초기 변수 설정
var ballPos = Point(200, 200);  // 공의 초기 위치 (중심)
var ballVel = Point(3, 2);      // 공의 속도 (픽셀 단위)
var ballRadius = 10;            // 공의 반지름
var canvasSize = 400;           // 캔버스 크기
var centerY = canvasSize / 2;


// 창과 UserView 생성
var win = Window("Bouncing Ball", Rect(0, 800, canvasSize, canvasSize)).front;
var view = UserView(win, win.view.bounds);

~balls = Array.new;

~createBall = {|pos|
	(
		pos: pos,
		vel: Point((2.0.rand - 1) * 0.5, (2.0.rand - 1) * 0.5),  // -1 ~ 1 사이의 랜덤 속도
		// vel: Point((2.0.rand - 1) * 3, 0),  // -3~3 사이의 랜덤 속도
		// vel: Point(0.5, 0),  // -3~3 사이의 랜덤 속도
		radius: 10 + (10.rand)  // 10 ~ 20 사이의 반지름
	)
};

// 초기에는 중앙에 하나의 공 추가
/*~balls = [
{
// var ball = ~createBall.(Point(canvasSize/2, canvasSize/2));
var ball = ~createBall.(Point(canvasSize/2, canvasSize/2));
var normAmp = 0.1 + (1.0 - 0.1) * ((ball[\pos].y - centerY).abs / centerY);
// 공의 x좌표에 따라 버퍼 재생 시작 위치(sp)를 매핑
ball[\synth] = Synth(\bufReader, [
\bufnum, ~buf_1,
\pos, (ball[\pos].x / canvasSize).postln,
\amp, normAmp
]);
ball;
}.value
];*/


// 마우스 클릭 시: 클릭 위치에서 새로운 공 생성
view.mouseDownAction = { |view, x, y, modifiers|
	var newBall = ~createBall.(Point(x, y));
	// var normAmp = 0.1 + (1.0 - 0.1) * ((y - centerY).abs / centerY);
	var r = newBall[\radius].asFloat;

	newBall[\synth] = Synth(\bufReader, [
		\bufnum, ~buf_1,
		\pos, ((x.asFloat - r) / (canvasSize - (newBall[\radius] * 2))),
		// \amp, normAmp
	]);
	~balls = ~balls.add( newBall );
};

// 그리기 함수: 배열에 있는 모든 공을 그림
view.drawFunc = {
	Pen.fillColor = Color.black;
	~balls.do { |ball|
		var pos = ball[\pos];
		var r = ball[\radius];
		Pen.addOval( Rect(pos.x - r, pos.y - r, r*2, r*2) ); // addOvar (left, top, withd, height)
		Pen.fill;
	};
};

// 애니메이션 루틴: 매 프레임마다 위치를 업데이트합니다.
Routine({
	loop {
		var normPos, normAmp, phaseSpeed, damping;

		// 1. 각 공의 위치 업데이트 및 synth 파라미터 갱신
		~balls = ~balls.collect { |ball|
			ball[\pos] = ball[\pos] + ball[\vel];

			// normPos = ball[\pos].x / canvasSize;
			// normAmp = 0.1 + (1.0 - 0.1) * (((ball[\pos].y - centerY).abs) / centerY);
			// ball[\synth].set(\pos, normPos);
			// ball[\synth].set(\amp, normAmp);

			phaseSpeed = ball[\vel].x * 0.001 * (~buf_1.numFrames / canvasSize);
			ball[\synth].set(\speed, phaseSpeed);

			ball;
		};

		// 2. 공 간 충돌 처리 (동일 질량의 완전 탄성 충돌 + 감쇠 적용)
/*		~balls.do({ |ball, i|
			~balls.do({ |other, j|
				if (i < j) {
					var diff, dist, minDist, sqSum, velDiff, dotVal, factor;
					diff = ball[\pos] - other[\pos];
					dist = ball[\pos].dist(other[\pos]);
					minDist = ball[\radius] + other[\radius];

					if (dist < minDist) {
						// squared sum: diff.x^2 + diff.y^2
						sqSum = diff.x * diff.x + diff.y * diff.y;
						// 두 공의 속도 차이를 계산
						velDiff = ball[\vel] - other[\vel];
						// 내적: velDiff.dot(diff) 대신 수동 계산
						dotVal = velDiff.x * diff.x + velDiff.y * diff.y;
						factor = dotVal / (sqSum + 0.001);
						ball[\vel] = ball[\vel] - diff * factor;
						other[\vel] = other[\vel] + diff * factor;
					}
				}
			});
		});*/

		// 3. 충돌 처리 후 경계 클램핑
		~balls = ~balls.collect { |ball|
			if (ball[\pos].x - ball[\radius] < 0) {
				ball[\pos].x = ball[\radius];
				ball[\vel].x = ball[\vel].x.abs;
			};
			if (ball[\pos].x + ball[\radius] > canvasSize) {
				ball[\pos].x = canvasSize - ball[\radius];
				ball[\vel].x = -1 * ball[\vel].x.abs;
			};
			if (ball[\pos].y - ball[\radius] < 0) {
				ball[\pos].y = ball[\radius];
				ball[\vel].y = ball[\vel].y.abs;
			};
			if (ball[\pos].y + ball[\radius] > canvasSize) {
				ball[\pos].y = canvasSize - ball[\radius];
				ball[\vel].y = -1 * ball[\vel].y.abs;
			};
			ball;
		};

		view.refresh;  // 화면 갱신
		0.01.wait;     // 10ms 대기 (약 100fps)
	}
}).play(AppClock);

CmdPeriod.doOnce({ win.close });

)



// 캔버스를 가로지르면 버퍼가 0부터 1까지 재생 되도록한다.
// 공이 생겨난 위치에서 버퍼의 0번째 frame이 재생된다. 캔버스의 맨 왼쪽이 아니라. 즉 공마다 버퍼 재생의 시작 지점이 다른 것.)

// 공의 Y 좌표는 소리의 어떤 부분과 연결시키면 좋을까?

// 공끼리 충돌 구현이 어렵다면, 공 끼리 겹칠 때만 체크해서 무언가 이벤트로 사용하는 방식도 가능하다.
// 미리 정해진 소리가 발생한다든지. 속도가 조금 변한다든지.

// 블랙혹, 콩나무 대가리, 사악한 검은 공, 사각형이 무대고 사람들이 공을 들고 올라온다
// 공들이 많아 질 때 뭔가 다르게 전체적으로 변하는 양상이 생기도록
// 공들이 많아지면 산소가 희박해지고...
// 지연이가 연주한 피아노 샘플로 만들어 보기 - 페달 소리라든지 숨소리라든지 악기 소리 외의 엠비언스도 들어가면 좋겠다.

// 어느 순간 공들 모두에게 어떤 힘이 작용한다든지.. (바람, 가속도..)
// 다른 버퍼를 싣은 공도 중간에 등장하도록 (말소리 라든지..)

(
var numBall = 100;
var canvasSize = 400;
var win = Window("Bouncing Balls", Rect(100, 100, canvasSize, canvasSize)).front;
var view = UserView(win, win.view.bounds);

// 100개의 공 생성: 각 공은 위치(pos), 속도(vel), 반지름(radius)를 가짐.
var balls = Array.fill(numBall, {
    (
		pos: Point(100.rrand(canvasSize-100), 100.rrand(canvasSize-100)),
		vel: Point((rand(2.0) - 1) * 3, (rand(2.0) - 1) * 3),
        radius: 5 + (10.rand)  // 5~15 사이의 반지름
    )
});

// 공 하나를 업데이트하는 함수
var updateBall = { |ball|
    // 공의 위치 업데이트
    ball[\pos] = ball[\pos] + ball[\vel];
    // x축 충돌 검사
    if ((ball[\pos].x - ball[\radius] < 0) or: { ball[\pos].x + ball[\radius] > canvasSize }, {
        ball[\vel] = ball[\vel] * Point(-1, 1);
    });
    // y축 충돌 검사
    if ((ball[\pos].y - ball[\radius] < 0) or: { ball[\pos].y + ball[\radius] > canvasSize }, {
        ball[\vel] = ball[\vel] * Point(1, -1);
    });
    ball;
};

// 그리기 함수: 모든 공을 그립니다.
view.drawFunc = {
    Pen.fillColor = Color.black;
    balls.do { |ball|
        var pos = ball[\pos];
        var r = ball[\radius];
        Pen.addOval(Rect(pos.x - r, pos.y - r, r*2, r*2));
        Pen.fill;
    };
};

// 애니메이션 루틴: 매 프레임마다 모든 공의 상태를 업데이트합니다.
Routine({
    loop {
        balls = balls.collect({ |ball| updateBall.(ball) });
        view.refresh;
        0.02.wait;
    }
}).play(AppClock);

CmdPeriod.doOnce{win.close;};
)
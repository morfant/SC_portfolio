

(
var maxGroupNum = 20;
var w, wc, run = true;
var numSquares = 1; // 그릴 사각형 수
var size, pos, angle, direction, dirBase = 2; // 사각형 크기, 위치, 회전 각도
var spex, labels, initVals;
var list_rect = List.newClear(0);
var rect;
var frameCount;
var fillGR;
var rectColors = [
    [Color.new255(255, 120, 100, 70), Color.new255(0, 180, 120, 80)],   // 그룹 0
    [Color.new255(240, 130, 110, 60), Color.new255(100, 190, 110, 70)], // 그룹 1
    [Color.new255(230, 140, 120, 75), Color.new255(0, 170, 130, 90)],   // 그룹 2
    [Color.new255(220, 150, 130, 65), Color.new255(90, 160, 100, 85)],  // 그룹 3
    [Color.new255(250, 160, 140, 60), Color.new255(10, 190, 110, 75)],  // 그룹 4
    [Color.new255(240, 170, 150, 55), Color.new255(120, 200, 120, 80)], // 그룹 5
    [Color.new255(255, 110, 90, 80), Color.new255(30, 180, 140, 85)],   // 그룹 6
    [Color.new255(230, 125, 105, 70), Color.new255(140, 190, 130, 75)], // 그룹 7
    [Color.new255(245, 135, 115, 65), Color.new255(20, 170, 150, 90)],  // 그룹 8
    [Color.new255(255, 145, 125, 60), Color.new255(110, 180, 120, 70)]  // 그룹 9
];


/*var rectColors = [
    [Color.new255(30, 60, 120, 90), Color.new255(10, 80, 140, 100)],    // 딥 블루 - 미드 블루
    [Color.new255(80, 30, 100, 80), Color.new255(140, 20, 180, 90)],    // 퍼플 블루 - 퍼플 핑크
    [Color.new255(20, 100, 90, 85), Color.new255(0, 140, 120, 95)],     // 티얼 블루 - 아쿠아 그린
    [Color.new255(10, 40, 90, 100), Color.new255(90, 50, 180, 95)],     // 블루 바이올렛 - 퍼플
    [Color.new255(5, 20, 70, 100), Color.new255(40, 80, 150, 90)],      // 다크 블루 - 딥 스카이 블루
    [Color.new255(100, 10, 40, 80), Color.new255(180, 30, 70, 85)],     // 다크 핑크 - 마젠타
    [Color.new255(0, 50, 100, 95), Color.new255(30, 100, 140, 100)],    // 시안 - 블루 그린
    [Color.new255(50, 20, 120, 90), Color.new255(80, 60, 180, 85)],     // 네이비 블루 - 바이올렛
    [Color.new255(15, 30, 80, 95), Color.new255(0, 70, 120, 100)],      // 다크 아쿠아 - 딥 블루
    [Color.new255(10, 90, 50, 85), Color.new255(50, 140, 90, 95)]       // 초록 블루 - 라이트 그린
];*/
var isFilling = Array.fill(maxGroupNum, false);
var currentRectNum = Array.fill(maxGroupNum, 0); // 각 그룹의 현재 사각형 개수
var targetGroup = 0;



// 창과 드로잉 설정
w = Window("Fibonacci Rectangles",
	Rect(0, 0, 800, 800)).front.background_(Color.white);
w.onClose = {run = false;};


// GR 그룹 컨테이너 추가
maxGroupNum.do{
	list_rect.add(List.newClear(0));
};


// Functions
// group index, rect number, posx, posy, interval
fillGR = {|g_idx, r_num, x, y, interval = 0.5, syn_name = \unit_of_sound_1|
	// 중복 실행 및 목표 개수가 동일한 경우 방지
	if (isFilling[g_idx] == false and: (currentRectNum[g_idx] != r_num), {
		isFilling[g_idx] = true; // 실행 중 플래그 설정


		direction = dirBase;
		("dirBase: "++dirBase).postln;
		pos = Point(x, y);


		if (currentRectNum[g_idx] < r_num, { // 늘어난다
			"inc".postln;

			Routine({
				var diff = r_num - currentRectNum[g_idx];
				("diff: "++diff).postln;
				"===============".postln;
				diff.do{|i|
					var idx = currentRectNum[g_idx] + i;
					var side = fib(idx + 1)[idx] * 20;
					("idx: "++idx).postln;
					("side: "++side).postln;

					// 사각형 객체 추가
					list_rect[g_idx].add(
						("idx%4: "++(idx%4)).postln;
						GradRect.new(pos, side, idx % 4,
							rectColors[g_idx][0],
							rectColors[g_idx][1],
							0, side * 0.1
						).setSound(syn_name).sound();

					);


					("list size: "++list_rect[g_idx].size).postln;
					("list: "++list_rect[g_idx]).postln;
					("direction: "++direction).postln;

					// 다음 사각형 위치 업데이트
					switch(direction,
						0, { pos = pos + Point(side, 0); },  // 오른쪽
						1, { pos = pos + Point(0, side); },  // 아래쪽
						2, { pos = pos - Point(side, 0); }, // 왼쪽
						3, { pos = pos - Point(0, side); }  // 위쪽
					);
					direction = (direction + 1) % 4; // 시계방향으로 90도 회전
					("pos: "++pos).postln;
					"-----------".postln;
					interval.wait; // 대기 시간

				};
				// 실행 완료 후 플래그 해제 및 현재 개수 업데이트
				currentRectNum[g_idx] = currentRectNum[g_idx] + diff;
				isFilling[g_idx] = false;
			}).play(AppClock)
		});

		if (currentRectNum[g_idx] > r_num, { // 줄어든다

			"dec".postln;
			("currentRectNum[g_idx]: "++currentRectNum[g_idx]).postln;
			Routine({
				var diff = (currentRectNum[g_idx] - r_num);
				("diff: "++diff).postln;
				diff.do{|i|
					var removed = nil;
					removed = list_rect[g_idx].pop;
					if (removed.notNil, {removed.sound();});
					("list size: "++list_rect[g_idx].size).postln;
					("list: "++list_rect[g_idx]).postln;
					currentRectNum[g_idx] = currentRectNum[g_idx] - 1;
					interval.wait; // 대기 시간
				};
			}).play(AppClock);

			// 실행 완료 후 플래그 해제 및 현재 개수 업데이트
			// currentRectNum[g_idx] = r_num;
			isFilling[g_idx] = false;
		});




		// list_rect[g_idx].clear(); // 기존 사각형 초기화

		// direction = dirBase;
		// pos = Point(x, y);
		//
		// Routine({
		// 	r_num.do{|i|
		// 		var side = fib(i+1)[i] * 20;
		//
		// 		// 사각형 객체 추가
		// 		list_rect[g_idx].add(
		// 			GradRect.new(pos, side, i % 4,
		// 				rectColors[g_idx][0],
		// 				rectColors[g_idx][1],
		// 				0, side * 0.1
		// 			)
		// 		);
		//
		//
		// 		// 다음 사각형 위치 업데이트
		// 		switch(direction,
		// 			0, { pos = pos + Point(side, 0); },  // 오른쪽
		// 			1, { pos = pos + Point(0, side); },  // 아래쪽
		// 			2, { pos = pos - Point(side, 0); }, // 왼쪽
		// 			3, { pos = pos - Point(0, side); }  // 위쪽
		// 		);
		// 		direction = (direction + 1) % 4; // 시계방향으로 90도 회전
		//
		// 		interval.wait; // 대기 시간
		// 	};
		// 실행 완료 후 플래그 해제 및 현재 개수 업데이트
		// currentRectNum[g_idx] = r_num;
		// isFilling[g_idx] = false;
	});
};


frameCount = 20; // 시작 지점 설정
w.drawFunc = {

	// ("frameCount: "++frameCount).postln;

	// 그리기 기본 설정
	Pen.translate(w.bounds.width/2, w.bounds.height/2); // 캔버스의 중앙으로 이동
	Pen.strokeColor = Color.black;


	// 모든 그룹의 GR draw ??
	maxGroupNum.do{|i|
		// ("size of list_rect["++i++"]: "++list_rect[i].size()).postln;
		if (list_rect[i].size() > 0, {
			list_rect[i].do{|item, idx|
				item.draw;
				// item.sound;
			};
		});

	};








	// pos의 위치 표시
	// Pen.fillColor = Color.red;
	// Pen.addOval(Rect(pos.x, pos.y, 10, 10));
	// Pen.fill;



	frameCount = frameCount + 1;
	if (frameCount % 10 == 0) {Post << "FrameCount: " << frameCount << nl;}
};
// w.refresh;
{ while { run } { w.refresh; 0.1.wait } }.fork(AppClock);


/*
fork{
	1.do{
		"fork start".postln;
		1.0.wait;
		// fillGR.(0, 6, 0, 0, 0.2, \unit_of_sound);
		// 4.0.wait;
		// fillGR.(0, 4, 200, 100, 0.2);
		// 3.0.wait;
		// fillGR.(1, 3, 200, 100, 0.2, \unit_of_sound_2);


		if (frameCount > 30, {
			fillGR.(0, 6, 0, 0, 0.2, \unit_of_sound_1);
		});
		4.0.wait;


		if (frameCount > 60, {
			fillGR.(0, 4, 200, 100, 0.2);
		});
		3.0.wait;


		if (frameCount > 90, {
			fillGR.(1, 3, 200, 100, 0.2, \unit_of_sound_2);
		});
		3.0.wait;

		if (frameCount > 110, {
			fillGR.(2, 10, -200, -100, 0.1, \unit_of_sound_1);
			fillGR.(3, 4, -200, 0, 0.25, \unit_of_sound_2);
		});
		6.0.wait;


	}
};
*/

fork {
    // 프레임 카운트와 시간에 따라 그룹의 동작을 추가적으로 정의
    loop {
        if (frameCount > 30, {
            "Activating group 0".postln;
            fillGR.(0, 6, 0, 0, 0.2, \unit_of_sound_1); // 그룹 0 생성
        });

        if (frameCount > 60, {
            "Modifying group 0".postln;
            fillGR.(0, 4, 200, 100, 0.2); // 그룹 0 크기 줄이기
        });

        if (frameCount > 90, {
            "Activating group 1".postln;
            fillGR.(1, 3, 200, 100, 0.2, \unit_of_sound_2); // 그룹 1 생성
        });

        if (frameCount > 110, {
            "Activating groups 2 and 3".postln;
            fillGR.(2, 10, -200, -100, 0.1, \unit_of_sound_1); // 그룹 2 생성
            fillGR.(3, 4, -200, 0, 0.25, \unit_of_sound_2);    // 그룹 3 생성
        });

        // 그룹 4와 5 추가적으로 생성
        if (frameCount > 150, {
            "Activating groups 4 and 5".postln;
            fillGR.(4, 7, 100, -150, 0.15, \unit_of_sound_1);  // 그룹 4 생성
            fillGR.(5, 5, -100, 150, 0.2, \unit_of_sound_3);   // 그룹 5 생성
        });

        // 그룹 삭제: 프레임 카운트와 규칙에 따라 그룹을 정리
        if (frameCount > 180, {
            "Removing random groups".postln;

            // 랜덤하게 그룹 하나 삭제
            targetGroup = (0..maxGroupNum - 1).choose;
            list_rect[targetGroup].do { |rect| rect.clear }; // 모든 GradRect 삭제
            list_rect[targetGroup].clear;                   // 리스트 초기화
            currentRectNum[targetGroup] = 0;                // 현재 개수 초기화
            ("Group " ++ targetGroup ++ " removed.").postln;
        });

        // 전체 루프의 주기
        1.0.wait;
    }
};


//===================================================================
// Control panel
wc = Window("Control", Rect(800, 100, 400, 100)).front.background_(Color.white);
wc.view.decorator=FlowLayout(wc.view.bounds);
wc.view.decorator.gap=2@2;
spex = [
	[1, 20].asSpec,
	[0, 3].asSpec
];
labels = #[num, dir];
initVals = [1, 2];
2.do{|i|
	EZSlider(wc, // parent,
		390@20,    // bounds
		labels[i],  // label
		spex[i],     // controlSpec
		{ |ez| switch(i,

			0, {
				direction = dirBase;
				size = 0;
				pos = Point(0, 0);
				angle = 0;

				numSquares = ez.value.asInteger;
				// ("numSquares: "++numSquares).postln;
				list_rect[0].clear;

				numSquares.do { |i|
					var side = fib(i+1)[i] * 20;
					// ("side: "++side).postln;
					// ("i: "++i).postln;

					// list_rect[0].size.postln;
					// 사각형 객체 추가
					list_rect[0].add(
						GradRect.new(pos, side, i % 4,
							Color.new255(255, 100, 100, 60),
							Color.new255(0, 200, 100, 60),
							1, (0.5 * (i+1))
						)
					);

					// 다음 사각형 위치 업데이트
					switch(direction,
						0, { pos = pos + Point(side, 0); },  // 오른쪽
						1, { pos = pos + Point(0, side); },  // 아래쪽
						2, { pos = pos - Point(side, 0); }, // 왼쪽
						3, { pos = pos - Point(0, side); }  // 위쪽
					);
					// ("direction: " ++ direction).postln;
					// ("pos: "++pos).postln;
					direction = (direction + 1) % 4; // 시계방향으로 90도 회전

				};



			},
			1, {dirBase = ez.value.asInteger;},
			{}
		);
		},
		initVals[i],
	);
};

// clear 버튼 추가
Button(wc,
	Rect(400, 100, 100, 50))
.states_([
	["Clear GradRect", Color.black, Color.white]
]
)
.action_({
	list_rect[0].do { |rect| rect.clear }; // 각 GradRect에 clear 메서드 호출
});
CmdPeriod.doOnce({w.close; wc.close});
)
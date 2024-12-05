GradRect {
	var pos, size, angle, beginColor, endColor, gradStyle, lerpTime;
	var rect, startPoint, endPoint, innerColor, outterColor;
	var clearColor, currentColorA, currentColorB, routine;
	var synthName = \unit_of_sound_1;

	*new {
		arg
		pos = Point(0, 0),
		size = 20,
		angle = 0,
		beginColor = Color.red,
		endColor = Color.white,
		gradStyle = 0,
		lerpTime = 1.0;
		^super.newCopyArgs(pos, size, angle, beginColor, endColor, gradStyle, lerpTime).init;
	}

	init {
		"GradRect init()".postln;
		clearColor = Color.new255(255, 255, 255, 100);
		rect = Rect(pos.x, pos.y, size, size);
		currentColorA = beginColor;
		currentColorB = endColor;

		switch(angle,
			0, {startPoint = rect.leftTop; endPoint = rect.rightBottom;},
			1, {startPoint = rect.rightTop; endPoint = rect.leftBottom;},
			2, {startPoint = rect.rightBottom; endPoint = rect.leftTop;},
			3, {startPoint = rect.leftBottom; endPoint = rect.rightTop;},
			{ "angle should be the one of '0, 1, 2, 3'".warn; };
		);

		switch(angle,
			0, {innerColor = beginColor; outterColor = endColor},
			1, {innerColor = endColor; outterColor = beginColor},
			2, {innerColor = beginColor; outterColor = endColor},
			3, {innerColor = endColor; outterColor = beginColor},
		);

	}

	draw {

		// Pen.strokeColor = Color.red;

		Pen.addRect(rect.insetBy(0));

		if (gradStyle == 0, {
			Pen.fillAxialGradient(
				startPoint, endPoint,
				currentColorA, currentColorB
			);
		});

		if (gradStyle == 1, {
			Pen.fillRadialGradient(
				rect.center, rect.center,
				0, rect.width,
				currentColorA, currentColorB
			);
		});

		// if (gradStyle != 0 && gradStyle != 1, {
		// 	("gradStyle: "++gradStyle).warn;
		// 	"gradStyle should be the one of '0, 1'".warn;
		// 	// gradStyle = 0;
		// });


		// Pen.rotate(angle, rect.bounds.center.x, rect.bounds.center.y);
	}

	// make transparently
	clear {
		this.stopClear;

		// 초기 색상을 clearColor로 설정
		currentColorA = clearColor;
		currentColorB = clearColor;


        // lerp를 통해 `beginColor`와 `endColor`로 복귀하는 `Routine`
		routine = Routine {
			var steps = 100; // 단계 수
			(0..steps).do { |i|
				var t = i / steps;
				currentColorA = clearColor.blend(beginColor, t);
				currentColorB = clearColor.blend(endColor, t);
				// this.changed(\draw); // redraw 요청
				// currentColorA.postln;
				(lerpTime / steps).wait; // 시간 조정
			};
		}.play;
	}

    stopClear {
        // 이미 실행 중인 `Routine`을 종료
        if (routine.notNil) {
            routine.stop;
            routine = nil;
        }
    }

	setSound {|syn_name|
		synthName = syn_name;
	}

	sound {
		// Synth(\unif_of_sound);

		Synth(synthName);
	}

}




(
~clock = TempoClock.default;
~clock.tempo = 1;

~t = Task.new({
	a = (instrument: \default, degree: 0, sustain: 0.1).play;
	0.5.wait;
	a = (instrument: \default, degree: 5.rand, sustain: 0.1).play;
	0.5.wait;
	a = (instrument: \default, degree: -5.rrand(5), sustain: 0.1).play;
	0.5.wait;
});

~u = Task.new({
	a = (instrument: \default, degree: 0 + 3, sustain: 2).play;
	1.5.wait;
	a = (instrument: \default, degree: 5.rand + 3, sustain: 2).play;
	1.5.wait;
	a = (instrument: \default, degree: -5.rrand(5) + 3, sustain: 2).play;
	1.5.wait;
});

~v = Task.new({
	a = (instrument: \default, degree: [3, 3 + 3.rand], sustain: 0.02, amp: 0.03).play;
	0.25.wait;
	a = (instrument: \default, degree: [5.rand, 5.rand] + 6, sustain: 0.02, amp: 0.03).play;
	0.25.wait;
	a = (instrument: \default, degree: -5.rrand(5) + 7.rand.dup, sustain: 0.02, amp: 0.03).play;
	0.25.wait;
});


/*fork 1과 fork 2는 병렬 실행*/
// fork 1
fork{
	1.do{
		("current beat:" + ~clock.beats.asInteger).postln;
		1.0.wait;
	}
};

/*fork 2 - 3은 범위 A 안의 부분이 한 번 실행된 이후에 실행 (직렬)*/
/*범위 A는 실제로는 한 번 실행되는 것이지만
그 안의 fork 2 - 1, fork 2 - 2 내부에서 다시 loop이 돌아서 계속 실행 되는 듯*/
// fork 2
fork {
	1.do { // 범위 A
		// fork 2 - 1
		fork{
			loop{
				~t.reset;~t.play; // Task는 Pause/Resume이 가능한 Routine
				4.0.wait;
				~t.reset; // 한 번 실행한 후에는 Routine처럼 reset를 해줘야 다시 소리 남.
				~t.play; // Task는 play하면 끝까지 진행되고 끝남.
				4.0.wait;
			};
		};

		12.0.wait;

		// fork 2 - 2
		fork{
			loop{
				~u.reset;~u.play;
				8.0.wait;
				~u.reset;~u.play;
				8.0.wait;
			}
		};
		4.wait;
	};

	/*범위 B 는 계속 반복 실행*/
	// fork 2 - 3
	fork{
		loop { // 범위 B
			"hello".post;
			// ("current beat:" + ~clock.beats.asInteger).postln;
			4.wait;

			" my".post;
			// ("current beat:" + ~clock.beats.asInteger).postln;
			4.wait;

			" name is".post;
			// ("current beat:" + ~clock.beats.asInteger).postln;
			4.wait;

			[" smith", " frioct", " shaewal".scramble].choose.postln;
			// ("current beat:" + ~clock.beats.asInteger).postln;
			4.wait;
		}
	}
};

/*fork 1, fork 2, fork 3은 병렬 실행*/
// fork 3
fork {
	loop{
		~v.reset;~v.play;
		(1 + 3.rand).wait;
	}
};

)

(// Parallel fork morning, 211017
~rou = fork{
	1.do{

		~rou_1 = fork{
			loop{
				(server: s, amp: 0.2).play;
				0.5.wait;
				(server: s, amp: 0.1).play;
				0.5.wait;
			}
		};

		// offset 1.0
		1.0.wait;
		~rou_2 = fork{
			loop{
				(server: s, degree: 3, amp: 0.2).play;
				1.0.wait;
				(server: s, degree: 3, amp: 0.1).play;
				1.0.wait;
			}
		};

		// offset 1.0 + 5.0
		5.wait;
		~rou_3 = fork{
			c = 0;
			d = Pseq([6, 3, 2, 2, 3, 6], inf).asStream;
			loop{
				(server: s, degree: -12 + d.next, amp: 0.3).play;
				(1.0/3).wait;
				c = c + 1;
			}
		};

		// offset 1.0 + 5.0 + 10.0
		10.wait;
		~rou_4 = fork{
			t = Pwrand([1.0, 2.0, 1.0/3, 1.0/4, 1.0/6, 1.0/8], [2, 3, 5, 4, 3, 2].normalizeSum, inf).asStream;
			b = Pbrown(-12, 10, 4, inf).trace.asStream;
			loop{
				(server: s, degree: (b+6).next, dur: t.next, amp: ([1.0, 0.9, 0.6, 0.5, 0.5, 0.3, 0.2]/2).choose).play;
				t.next.wait;
			}
		};


	}
}
)

// To stop
~rou_4.stop;~rou_3.stop;~rou_2.stop;~rou_1.stop;~rou.stop;

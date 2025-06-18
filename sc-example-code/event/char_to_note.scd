
(
// 1) 변수에 text 내용 직접 넣기
// ~str = "Several world leaders have denied wrongdoing after featuring in a huge leak of financial documents from offshore companies.
//
// Dubbed the Pandora Papers, the 12 million files constitute the biggest such leak in history.
//
// Russian President Vladimir Putin and Jordan's King Abdullah II bin Al-Hussein are among some 35 current and former leaders linked to the files.
//
// Both have issued statements saying they have done nothing wrong.
//
// Jordan's royal palace said it was \"not unusual nor improper\" that King Abdullah owned property abroad.
//
// Leaked documents show the leader secretly spent more than £70m ($100m) on a property empire in the UK and US since taking power in 1999.";

// 2) .txt 파일에서 읽은 내용 사용하기
// 텍스트 파일 읽어오기
~path = "/Users/giy/Projects/sc-example-code/event/sample.txt";
~str = File.readAllString(~path);

~noteNames = ();
~noteNames.putPairs(['c', 60, 'd', 62, 'e', 64, 'f', 65, 'g', 67, 'a', 69, 'b', 71]);

fork{
	inf.do{
		~str.do {|char, i| // 위 문자열의 문자 하나씩이 char 아규먼트로 들어옴
			var charRaw = char, amp = 0.1, sym = nil;
			if (charRaw.isUpper, {amp = 0.3}, {amp = 0.1}); // 대문자인 경우 amp = 0.3, 소문자인 경우 amp = 0.1
			sym = charRaw.toLower.asSymbol; // 문자를 소문자로 바꾼 후, symbol 타입으로 변경
			if (~noteNames.includesKey(sym), { // ~noteNames가 해당 문자를 포함하고 있다면,
				var n = ~noteNames[sym]; // 문자에 해당하는 노트 값을 가져와 n에 넣음
				("char: " ++ charRaw ++ ", " ++ "note: " ++ n).postln;
				(midinote: n, amp: amp).play;
			},
			{ // 해당 문자가 ~noteNames에 없다면
				("char: " ++ charRaw ++ ", " ++ "note: " ++ "Not defined, amp: " ++ amp).postln;
			});
			0.25.wait;
		};
		"loop...".postln;
	}
}
)

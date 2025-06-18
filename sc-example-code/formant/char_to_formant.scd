
(
SynthDef.new(\vowel, {
	arg fund_midi = 72, amp = 0.2, gate = 1, vib_time = 1.3,
	form_freq = #[800, 1050, 2900, 3900, 4950],
	bw_form_freq = #[80, 90, 120, 130, 140],
	sub_db = #[0, 6, 32, 20, 50],
	outH = 0, outV = 0;
	var fund_freq, vib, db, sig, env;

	fund_freq = midicps(fund_midi);
	db = ampdb(amp);

	vib = SinOsc.kr(6, 0, midicps(fund_midi + XLine.kr(0.008, 0.2, vib_time)) - fund_freq); //vibrato
	fund_freq = fund_freq + vib;

	env = EnvGen.kr(Env.perc(0.1, 0.5, curve: 10), gate, doneAction: 2);
	sig = Formant.ar(fund_freq, form_freq, bw_form_freq, dbamp(db - sub_db)).sum;
	// Out.ar(0, Pan4.ar(sig * env, outH, outV, 1.0));
	Out.ar(0, Pan2.ar(sig * env, 0, 1.0));

}, variants:(
	a: [form_freq: #[800, 1050, 2900, 3900, 4950], bw_form_freq: #[80, 90, 120, 130, 140], sub_db: #[0, 6, 32, 20, 50], outH: -1, outV: 1],
	e: [form_freq: #[350, 2000, 2800, 3600, 4950], bw_form_freq: #[60, 100, 120, 150, 200], sub_db: #[0, 20, 15, 40, 56], outH: 1, outV: 1],
	i: [form_freq: #[270, 2140, 2950, 3900, 4950], bw_form_freq: #[60, 90, 100, 120, 120], sub_db: #[0, 12, 26, 26, 44], outH: -1, outV: -1],
	o: [form_freq: #[450, 800, 2830, 3800, 4950], bw_form_freq: #[70, 80, 100, 130, 135], sub_db: #[0, 11, 22, 22, 50], outH: 1, outV: -1],
	u: [form_freq: #[325, 700, 2700, 3800, 4950], bw_form_freq: #[50, 60, 170, 180, 200], sub_db: #[0, 16, 35, 40, 60], outH: 0, outV: 0])

).add
)


Synth('vowel.a')
Synth('vowel.e')
Synth('vowel.i')
Synth('vowel.o')
Synth('vowel.u')


// https://www.bbc.com/news/science-environment-24021772
(
// 1) 직접 변수에 내용 담기

~str = "World temperatures are rising because of human activity, and climate change now threatens every aspect of human life.
Left unchecked, humans and nature will experience catastrophic warming, with worsening droughts, greater sea level rise and mass extinction of species.
We face a huge challenge, but there are potential solutions.
What is climate change?
Climate is the average weather in a place over many years. Climate change is a shift in those average conditions.
The rapid climate change we are now seeing is caused by humans using oil, gas and coal for their homes, factories and transport.
When these fossil fuels burn, they release greenhouse gases - mostly carbon dioxide (CO2). These gases trap the Sun's heat and cause the planet's temperature to rise.
The world is now about 1.2C warmer than it was in the 19th Century - and the amount of CO2 in the atmosphere has risen by 50%";



// 2) 파일에서 내용 읽어오기
// ~path = "/Users/giy/Projects/sc-example-code/event/sample.txt";
// ~str = File.readAllString(~path);

~vowelNames = ();
~vowelNames.putPairs(['a', 'vowel.a', 'e', 'vowel.e' , 'i', 'vowel.i', 'o', 'vowel.o', 'u', 'vowel.u']);

~prevChar = '0';
fork{
	inf.do{
		~str.do {|char, i|
			var sym = char.toLower.asSymbol; // 입력된 Char를 소문자로 바꾸고 Symbol 타입으로 변환
			if (~vowelNames.includesKey(sym), { // ~vowelNames가 입력된 글자를 포함하고 있는지 확인
				var synth_variant = ~vowelNames[sym]; // 입력된 모음을 바탕으로 그에 맞는 synth variant 이름 가져오기
				"[".post; char.post; "]".post; // 모음에 해당하는 글자만 [ ] 로 감싸서 표시
				Synth(synth_variant, [\fund_midi, (50 + ((~prevChar.ascii) % 24))]); // 이전 문자의 ascii 코드를 24로 나눈 나머지로 formant의 fund_midi 결정
			}, {
				char.post;
			});
			0.2.wait;
			~prevChar = char;
		};
		"loop...".postln;
	}
}
)



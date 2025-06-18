
(
var num = 8;

// "1010" -> 10
~binStr2Dec = {|binStr = "1010"|
	var result = 0;
	var digits = Array.newClear(binStr.size);
	binStr.do{ |char, i| digits[i] = char.asInteger - 48;};
	digits.do{|d, i|var exp = digits.size - (i + 1); result = result + (d * (2**exp)) };
	// ("dec: " ++ result.asInteger).postln;
	result.asInteger;
};

// [0, 1, 0] -> "010"
~arr2BinStr = {|arr = #[0, 1, 0]|
	var binaryString = arr.collect { |digit| digit.asString }.join;
	// ("binStr: " ++ binaryString).postln;
	binaryString;
};


// ~ca를 실행할 때마다 다음 세대의 결과가 나오도록
~ruleSet = Array.fill(num, {0.5.coin.asInteger});
// ~ruleSet = #[0, 1, 0, 1, 1, 0, 1, 0];
~nextGen = Array.fill(num, {0.5.coin.asInteger});
// ~nextGen = [1, 0, 0, 1, 0, 1, 0, 1];
~ca = {|init|
	var size = num;
	var arr = init.copy;
	var result = Array.newClear(size);

	~nextGen[0] = arr[0];
	~nextGen[size - 1] = arr[size - 1];

	(size - 2).do{|i|
		var neighborBinStr = ~arr2BinStr.(arr[i..(i + 2)]);
		var idx = ~binStr2Dec.(neighborBinStr);
		var nextValue = ~ruleSet[idx];
		// nextValue.postln;
		~nextGen[i + 1] = nextValue;
	};
	~nextGen.postln;
};
)
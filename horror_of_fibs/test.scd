2.fib

fib(2)
fib(5)[4]


~fibo = { |n| if(n < 2) { 1 } { ~fibo.(n - 1) + ~fibo.(n - 2) } };

~fibo.(0)
~fibo.(1)
~fibo.(2)
~fibo.(3)

fib(1)[0]
fib(2)[1]
fib(3)[2]
fib(4)[3]

a = 0;
a = a + 1;
a = Point(-10, 0)
b = Point(5, 5)
a + b


lerp


(0, 1, 0.01).do{|i| i.postln}






(
c = [
	[
		Color.new255(255, 100, 100, 60),
		Color.new255(0, 200, 100, 60),
	],
	[
		Color.new255(255, 100, 100, 60),
		Color.new255(100, 200, 100, 60),
	]
];
)

c[0][0]
c[0][1]
c[1][0]
c[1][1]
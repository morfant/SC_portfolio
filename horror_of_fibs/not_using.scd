// NOT_USING
func_grad = {|rect|
	// fill the gradient
	Pen.addRect(rect.insetBy(0));
	Pen.fillAxialGradient(rect.leftTop, rect.rightBottom,
		Color.new255(255, 100, 100, 60),
		Color.new255(0, 200, 100, 60)
	);
	// Pen.rotate([pi/2, -pi/2, pi].choose, rect.bounds.left, rect.bounds.top);
};
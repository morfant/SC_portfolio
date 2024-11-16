(
w = Window.new.front;

w.drawFunc = {
    // fill the gradient
    Pen.addRect(w.view.bounds.insetBy(30));
    Pen.fillAxialGradient(w.view.bounds.leftTop, w.view.bounds.rightBottom, Color.red, Color.white);
};
w.refresh;
)
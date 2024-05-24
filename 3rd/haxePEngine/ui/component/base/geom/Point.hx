package haxePEngine.ui.component.base.geom;

class Point extends h2d.col.Point {
    public function new(x = 0., y = 0.) {
        super(x,y);
    }

	public function setTo(newOffsetX:Float, newOffsetY:Float) {
        this.x = newOffsetX;
        this.y = newOffsetY;
    }

	public function copyFrom(value:Point) {
        this.x = value.x;
        this.y = value.y;
    }
}
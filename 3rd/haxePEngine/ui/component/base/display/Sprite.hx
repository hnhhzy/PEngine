package haxePEngine.ui.component.base.display;

class Sprite extends DisplayObjectContainer {
	public var graphics:Graphics;
	public var hitArea:Any;
    public var __buttonMode:Bool;
	public var useHandCursor:Bool;
	public var buttonMode:Bool;



    public function new(?parent:h2d.Object) {
        super();
        graphics = new Graphics(parent);
    }
}
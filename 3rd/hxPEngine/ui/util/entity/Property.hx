package hxPEngine.ui.util.entity;

class Property {
	public var collision : Int;
	public var mask : Int;
	public var x : Float;
	public var y : Float;
    public var width : Float;
    public var height : Float;
	public var polygon :  Array<{ x: Float, y: Float }>;
	public function new() {
	}
}
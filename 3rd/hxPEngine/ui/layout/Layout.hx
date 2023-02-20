package hxPEngine.ui.layout;

import h2d.Object;
import hxPEngine.ui.base.IObject;

class Layout implements ILayout {
	public var paddingLeft:Null<Float>;

	public var paddingRight:Null<Float>;

	public var paddingTop:Null<Float>;

	public var paddingBottom:Null<Float>;

	public var padding:Null<Float>;

	public function new() {}

	public function updateLayout(self:IObject, children:Array<Object>) {}

	public var autoLayout:Bool = true;
}
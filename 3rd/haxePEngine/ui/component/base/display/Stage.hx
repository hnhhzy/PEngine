package haxePEngine.ui.component.base.display;

import haxePEngine.ui.component.base.text.TextField;

class Stage extends DisplayObjectContainer {
	public var stageHeight(default, null):Int;

	public var stageWidth(default, null):Int;

	var __mouseX(default, null):Float;

	var __mouseY(default, null):Float;

	public var focus:TextField;

    //public function new(#if commonjs width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null, documentClass:Class<Dynamic> = null,
	//	windowAttributes:Dynamic = null #else window:Window, color:Null<Int> = null #end)
}
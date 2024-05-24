package haxePEngine.ui.component.base.text;

import haxePEngine.ui.component.base.display.InteractiveObject;

class TextField extends InteractiveObject {
    public var text:String;
    public var selectable:Bool;
    public var multiline:Bool;
    public var wordWrap:Bool;
    public var autoSize:TextFieldAutoSize;
    public var defaultTextFormat:TextFormat;
    public var embedFonts:Bool;
    public var htmlText:String;
    public var numLines:Int;
    public var textWidth:Float;
    public var textHeight:Float;
	public var type(default, null):TextFieldType;


    public function new() {
        super();
    }

    public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void
    {
    }

    public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
    {
    }
}
package haxePEngine.ui.base.text;


import haxePEngine.ui.component.base.display.DisplayObject;

interface IRichTextObjectFactory
{

    function createObject(src : String, width : Int, height : Int) : DisplayObject;
    function freeObject(obj : DisplayObject) : Void;
}

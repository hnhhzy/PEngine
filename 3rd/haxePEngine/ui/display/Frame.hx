package haxePEngine.ui.display;


import haxePEngine.ui.component.base.display.BitmapData;
import haxePEngine.ui.component.base.geom.Rectangle;

class Frame
{
    public var rect : Rectangle;
    public var addDelay : Int = 0;
    public var image : BitmapData;
    
    public function new()
    {
        rect = new Rectangle();
    }
}

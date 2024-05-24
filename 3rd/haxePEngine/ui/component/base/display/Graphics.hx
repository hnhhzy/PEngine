package haxePEngine.ui.component.base.display;

import haxePEngine.ui.component.base.geom.Matrix;
import haxePEngine.ui.component.base.geom.Rectangle;

class Graphics extends h2d.Graphics {
	

    public function new(?parent:h2d.Object) {
        super(parent);
    }

	function __cleanup() {}

	function __getBounds(rect:Rectangle, matrix:Matrix) {}

	function __hitTest(x:Float, y:Float, shapeFlag:Bool, arg3:Matrix) : Bool {
        // 待补
        return true;
	}

	function __readGraphicsData(graphicsData:Vector<IGraphicsData>) {}

	public function copyFrom(arg0:Graphics) {}

	public function beginBitmapFill(_fillBitmapData:BitmapData) {}

	public function drawRoundRect(arg0:Int, arg1:Int, w:Int, h:Int, arg4:Null<Int>, arg5:Null<Int>) {}

	public function drawRoundRectComplex(arg0:Int, arg1:Int, w:Int, h:Int, arg4:Null<Int>, arg5:Null<Int>, arg6:Null<Int>, arg7:Null<Int>) {}
}
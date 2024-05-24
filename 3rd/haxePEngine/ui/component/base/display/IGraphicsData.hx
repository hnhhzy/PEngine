package haxePEngine.ui.component.base.display;


#if !flash
import haxePEngine.ui.component.base.display._internal.GraphicsDataType;

interface IGraphicsData
{
	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
}
#else
typedef IGraphicsData = flash.display.IGraphicsData;
#end
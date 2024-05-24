package haxePEngine.ui.component.base.display;

#if !flash

@:final class Scene
{
	public var labels(default, null):Array<FrameLabel>;
	public var name(default, null):String;
	public var numFrames(default, null):Int;

	public function new(name:String, labels:Array<FrameLabel>, numFrames:Int)
	{
		this.name = name;
		this.labels = labels;
		this.numFrames = numFrames;
	}
}
#else
typedef Scene = flash.display.Scene;
#end
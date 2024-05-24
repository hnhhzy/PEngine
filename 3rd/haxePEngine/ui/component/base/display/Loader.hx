package haxePEngine.ui.component.base.display;

import haxePEngine.ui.component.base.net.URLRequest;

class Loader extends DisplayObjectContainer {
	public var contentLoaderInfo(default, null):Any;
	public var content(default, null):DisplayObject;


    public function new() {
        super();
    }
    

	public function load(arg0:URLRequest) {}
}
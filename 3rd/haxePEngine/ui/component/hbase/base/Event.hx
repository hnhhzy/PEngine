package haxePEngine.ui.component.hbase.base;

class Event {
	/**
	 * CLICK事件
	 */
	public static inline var CLICK:EventType<Event> = "click";

	/**
	 * 按下事件
	 */
	public static inline var PUSH:EventType<Event> = "push";

	/**
	 * 松开事件
	 */
	public static inline var RELEASE:EventType<Event> = "release";

	/**
	 * 数据更改事件
	 */
	public static inline var CHANGE:EventType<Event> = "change";

	public var type:String;

	/**
	 * 触发事件的目标
	 */
	public var target(get, null):Any;

	private var __target:Any;

	private function get_target():Any {
		return __target;
	}

	public function new(type:String) {
		this.type = type;
	}

	private var _preventDefault:Bool = false;

	public function preventDefault():Void {
		_preventDefault = true;
	}
}
package hxPEngine.ui.base;
import hxPEngine.ui.events.Event;
import hxPEngine.ui.events.EventType;

/**
 * 事件侦听器
 */
 interface IEventListener {
	public function addEventListener<T>(type:EventType<T>, listener:T->Void):Void;

	public function removeEventListener<T>(type:EventType<T>, listener:T->Void):Void;

	public function hasEventListener<T>(type:EventType<T>):Bool;

	public function dispatchEvent(event:Event, bubble:Bool = false):Void;
}
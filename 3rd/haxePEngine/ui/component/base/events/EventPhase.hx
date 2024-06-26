package haxePEngine.ui.component.base.events;

@:enum abstract EventPhase(Int) from Int to Int from UInt to UInt
{
	/**
		The target phase, which is the second phase of the event flow.
	**/
	public var AT_TARGET = 2;

	/**
		The bubbling phase, which is the third phase of the event flow.
	**/
	public var BUBBLING_PHASE = 3;

	/**
		The capturing phase, which is the first phase of the event flow.
	**/
	public var CAPTURING_PHASE = 1;
}
package haxePEngine.ui.component.base.display;

@:enum abstract BitmapDataChannel(Int) from Int to Int from UInt to UInt
{
	/**
		The alpha channel.
	**/
	public var ALPHA = 8;

	/**
		The blue channel.
	**/
	public var BLUE = 4;

	/**
		The green channel.
	**/
	public var GREEN = 2;

	/**
		The red channel.
	**/
	public var RED = 1;
}
package haxePEngine.ui.component.base.error;

class RangeError extends Error
{
	public function new(message:String = "")
	{
		super(message, 0);

		name = "RangeError";
	}
}
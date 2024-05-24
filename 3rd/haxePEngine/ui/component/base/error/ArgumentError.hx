package haxePEngine.ui.component.base.error;

class ArgumentError extends Error
{
	public function new(message:String = "")
	{
		super(message, 0);

		name = "ArgumentError";
	}
}
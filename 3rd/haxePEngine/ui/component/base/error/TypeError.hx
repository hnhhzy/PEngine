package haxePEngine.ui.component.base.error;

class TypeError extends Error
{
	public function new(message:String = "")
	{
		super(message, 0);

		name = "TypeError";
	}
}
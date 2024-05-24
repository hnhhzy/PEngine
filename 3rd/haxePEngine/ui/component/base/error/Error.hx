package haxePEngine.ui.component.base.error;

class Error extends haxe.Exception
{
	public var errorID:Int;
    public var name:String;

	public function new(message:String = "", errorID:Int = 0)
	{
		super(message, 0);

		name = "Error";
		this.errorID = errorID;
	}
}
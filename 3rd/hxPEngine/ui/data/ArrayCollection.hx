package hxPEngine.ui.data;

class ArrayCollection<Dynamic> {
	public var source:Array<Dynamic> = [];

	public function new(array:Array<Dynamic>) {
		this.source = array;
	}

	public function add(data:Dynamic):Void {
		this.source.push(data);
		if (onChange != null)
			this.onChange();
	}

	public function remove(data:Dynamic):Void {
		this.source.remove(data);
		if (onChange != null)
			this.onChange();
	}

	dynamic public function onChange():Void {}
}
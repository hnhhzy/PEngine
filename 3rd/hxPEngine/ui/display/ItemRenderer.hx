package hxPEngine.ui.display;
import hxPEngine.ui.base.IItemRenderer;
import h2d.Object;
import hxPEngine.ui.events.Event;
import h2d.RenderContext;
import hxPEngine.ui.base.IListView;

class ItemRenderer extends UIEntity implements IItemRenderer {
	public var data(default, set):Dynamic;

	public function set_data(value:Dynamic):Dynamic {
		this.data = value;
		return value;
	}

	public var selected(default, set):Bool;

	public function set_selected(value:Bool):Bool {
		this.selected = value;
		return value;
	}

	public function new(?parent:Object) {
		super(parent);
		this.enableInteractive = true;
		this.interactive.propagateEvents = true;
		this.interactive.onClick = function(e) {
			this.dispatchEvent(new Event(Event.CLICK), true);
		}
	}

	override function draw(ctx:RenderContext) {
		if(dirt){
			this.updateLayout();
		}
		super.draw(ctx);
	}

	public var listView:IListView;
}
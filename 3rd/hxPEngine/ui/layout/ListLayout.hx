package hxPEngine.ui.layout;
import hxPEngine.ui.base.IObject;
import h2d.Object;
import hxPEngine.ui.display.ListView;
import hxPEngine.ui.display.DefalutItemRenderer;
import hxPEngine.ui.data.ObjectRecycler;

class ListLayout extends Layout {

	public function new() {
		super();
		this.autoLayout = false;
	}

	override function updateLayout(self:IObject, children:Array<Object>) {
		super.updateLayout(self, children);
		var list:ListView = cast self;
        @:privateAccess list.__moveUpdateData = false;
		if (list.dataProvider == null) {
			return;
		}
		var recycler = list.itemRendererRecycler;
		if (recycler == null) {
			recycler = cast DefalutItemRenderer.recycler;
		}
		// 布局渲染
		var box = @:privateAccess list._box;
		var childs = @:privateAccess box.children;
		if (childs.length > 0) {
			if (recycler.testClass(childs[0])) {
				for (object in childs) {
					// 回收
					recycler.release(cast object);
				}
			}
			// 直接清空
			box.removeChildren();
		}
		updateListLayout(list, recycler);
	}

	/**
	 * 统一实现布局更新的入口
	 * @param list 
	 * @param recycler 
	 */
	public function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>):Void {}
}
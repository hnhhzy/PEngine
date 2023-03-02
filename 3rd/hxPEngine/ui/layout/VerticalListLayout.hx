package hxPEngine.ui.layout;
import hxPEngine.ui.display.ListView;
import hxPEngine.ui.data.ObjectRecycler;
import hxPEngine.ui.display.ItemRenderer;

/**
 * 竖向的ListView布局
 */
class VerticalListLayout extends ListLayout {

	public var gap:Float = 0;

	override function updateListLayout(list:ListView, recycler:ObjectRecycler<Dynamic>) {
		super.updateListLayout(list, recycler);
		list.enableHorizontalScroll = false;
		list.enableVerticalScroll = true;
		var offestY = 0.;
		for (index => value in list.dataProvider.source) {
			var item:ItemRenderer = recycler.create();
			item.listView = list;
			item.x = 0;
			item.width = list.width;
			item.data = value;
			item.selected = list.hasSelectedIndex(index);
			item.y = offestY;
			list.addChild(item);
			offestY += gap;
			offestY += item.contentHeight;
		}
	}
}

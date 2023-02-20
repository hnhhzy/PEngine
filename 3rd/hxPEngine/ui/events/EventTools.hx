package hxPEngine.ui.events;

import h2d.Object;
import hxPEngine.ui.base.IEventListener;

class EventTools {
	public static function dispatchParentEvent(self:Object, event:Event, bubble:Bool):Void {
		if (@:privateAccess event._preventDefault)
			return;
		if (bubble) {
			// 向上冒泡
			if (self.parent != null) {
				if (self.parent is IEventListener)
					cast(self.parent, IEventListener).dispatchEvent(event, bubble);
				else
					dispatchParentEvent(self.parent, event, bubble);
			}
		}
	}
}
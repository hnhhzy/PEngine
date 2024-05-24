package haxePEngine.utils.loader.parser;

import haxePEngine.ui.component.base.utils.ByteArray;
import haxePEngine.ui.base.UIPackage;
import haxePEngine.ui.utils.*;

/**
 * UI载入解析器
 */
 class UIParser extends BaseParser {

	public static function support(type:String):Bool {
		var ext = type.toLowerCase();
		return ext == "pui";
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			var bytesInput = new ByteArray(data);
			UIPackage.addPackage(bytesInput, null);

			// 对它进行引用
			this.out(this, UI, data, 1);
		}, error);
	}
}
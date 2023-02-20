package hxPEngine.ui.loader.parser;

import haxe.Json;
import hxPEngine.ui.util.AssetsUtils;

/**
 * JSON数据解析器
 */
class JSONDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "json";
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			var obj = Json.parse(data.toString());
			this.out(this, JSON, obj, 1);
		}, error);
	}
}
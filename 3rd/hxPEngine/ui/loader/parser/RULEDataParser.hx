package hxPEngine.ui.loader.parser;


import haxe.Json;
import hxPEngine.ui.util.AssetsUtils;

/**
 * JSON数据解析器
 */
class RULEDataParser extends BaseParser {
	public static function support(type:String):Bool {
		//var ext = type.toLowerCase();
		//trace(type+"  TYPE");
		return type == "rule" ;
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			trace(data.toString()+"  TYPE11");
			var obj = Json.parse(data.toString());
			trace(obj+"  TYPE");
			this.out(this, RULE, obj, 1);
		}, error);
	}
}
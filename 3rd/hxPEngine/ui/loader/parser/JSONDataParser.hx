package hxPEngine.ui.loader.parser;

import haxe.Json;
import hxPEngine.ui.util.AssetsUtils;

/**
 * JSON数据解析器
 */
class JSONDataParser extends BaseParser {
	public static function support(type:String):Bool {
		//trace("JSONDataParser.support", type);
		return type == "json" || type == "rule" || type == "spines";
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			//trace("JSONDataParser.support:"+ data.toString());
			if(data == null || data.toString() == "," || data.toString() == ""){
				//error("JSONDataParser.process: data is null");
				//trace("1111111:", data.toString());
				this.out(this, JSON, null, 1);
				
			
			}else{
				//trace("2222222:", data.toString());
				var obj = Json.parse(data.toString());
			
				this.out(this, JSON, obj, 1);

			}
			
		}, error);
	}
}
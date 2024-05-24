package hxPEngine.ui.loader.parser;

import hxd.res.Image;
import hxd.fs.BytesFileSystem;
import hxPEngine.ui.util.AssetsUtils;

/**
 * 加载图片解析器
 */
 @:keep
 class BitmapDataParser extends BaseParser {
	public static function support(type:String):Bool {
		return type == "png" || type == "jpg" || type == "PNG" || type == "JPG";
	}

	override function process() {
		AssetsUtils.loadBytes(getData(), function(data) {
			var fs = new BytesFileEntry(getData(), data);
			var image:Image = new Image(fs);
			this.out(this, BITMAP, image, 1);
		}, error);
	}
}
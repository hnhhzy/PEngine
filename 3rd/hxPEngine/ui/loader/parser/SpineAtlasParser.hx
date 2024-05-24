package hxPEngine.ui.loader.parser;
import hxd.res.Image;
import hxPEngine.ui.util.AssetsUtils;
import hxPEngine.ui.util.StringUtils;
import hxPEngine.ui.res.SpineTextureAtlas;

class SpineAtlasParser extends BaseParser {
	private var bitmapIndex = 0;

	private var _images:Map<String, Image> = [];

	override function process() {
		super.process();
		if (getData().pngs[bitmapIndex] == null) {
			// 开始加载atlas
			AssetsUtils.loadBytes(getData().atlas, function(bytes) {
				// 开始解析精灵图
				var atlas = new SpineTextureAtlas(_images, bytes.toString());
				this.out(this, SPINE_ATLAS, atlas, 1);
			}, error);
			return;
		}
		var bitmapParser = new BitmapDataParser(getData().pngs[bitmapIndex]);
		bitmapParser.error = error;
		bitmapParser.out = function(parser:BaseParser, type:AssetsType, assetsData:Image, pro:Float) {
			//_images.set(StringUtils.getName(getData().pngs [bitmapIndex]), assetsData);
			_images.set(StringUtils.getName(bitmapParser.getName()), assetsData);
			//._images.set(bitmapParser.getName(), assetsData);
			bitmapIndex++;
			process();
		}
		bitmapParser.process();
	}

	override function getName():String {
		return StringUtils.getName(this.getData().pngs[0]);
	}
}
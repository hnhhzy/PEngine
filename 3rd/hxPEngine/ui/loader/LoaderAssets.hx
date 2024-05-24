package hxPEngine.ui.loader;

import hxPEngine.ui.loader.parser.BaseParser;
import hxPEngine.ui.loader.parser.BitmapDataParser;
import hxPEngine.ui.loader.parser.JSONDataParser;
import hxPEngine.ui.loader.parser.RULEDataParser;
import hxPEngine.ui.loader.parser.SoundParser;
import hxPEngine.ui.loader.parser.HMDParser;
import hxPEngine.ui.loader.parser.XMLDataParser;
import hxPEngine.ui.loader.parser.BytesDataParser;

/**
 * ZAssets核心载入器，可简易使用扩展
 */
 class LoaderAssets {
	/**
	 * 单独载入文件路径支持的格式载入解析器，可通过继承ParserBase来扩展自定义载入方式。supportType直接返回true的解析器请勿加入到此列表。
	 */
	public static var fileparser:Array<Class<BaseParser>> = [
		BitmapDataParser,
		XMLDataParser,
		JSONDataParser,
		RULEDataParser,
		SoundParser,
		HMDParser,
		BytesDataParser // SparticleParser,
		// MP3Parser,
		// TextParser,
		// #if castle
		// CDBParser,
		// #end
		// XMLParser,
		// JSONParser,
		// BitmapDataParser
		// #if (ldtk), LDTKParser
		// #end
	];
}
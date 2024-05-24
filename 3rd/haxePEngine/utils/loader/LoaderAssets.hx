package haxePEngine.utils.loader;

import haxePEngine.utils.loader.parser.*;

class LoaderAssets {
	/**
	 * 单独载入文件路径支持的格式载入解析器，可通过继承ParserBase来扩展自定义载入方式。supportType直接返回true的解析器请勿加入到此列表。
	 */
	public static var fileparser:Array<Class<BaseParser>> = [
		UIParser,
		BytesDataParser
	];
}
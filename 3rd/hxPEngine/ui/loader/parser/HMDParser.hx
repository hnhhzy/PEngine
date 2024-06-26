package hxPEngine.ui.loader.parser;

import hxPEngine.ui.util.StringUtils;
import hxPEngine.ui.util.AssetsBuilder;
import hxPEngine.ui.util.Assets;
import hxd.res.Model;
import hxd.fs.BytesFileSystem;
import hxPEngine.ui.util.AssetsUtils;

/**
 * 加载HMD格式的3D数据，如果提供的路径是fbx后缀，也可以加载
 */
class HMDParser extends BaseParser {
	private var _setName:String = null;

	public static function support(type:String):Bool {
		if(type==null){
			return false;
		}
		var ext = type.toLowerCase();
		return ext == "fbx" || ext == "hmd";
	}

	public function toHmd(m:Model) : hxd.fmt.hmd.Library {
		var fs = m.entry.open();
		//var hmd = new hxd.fmt.hmd.Reader(fs).readHeader(true);
		var hmd = new hxd.fmt.hmd.Reader(fs).read();
		fs.close();
		return new hxd.fmt.hmd.Library(m, hmd);
	}

	override function process() {
		var path:String = getData();
		if (StringUtils.getExtType(path).toLowerCase() == "fbx") {
			var fileExt = StringUtils.getExtType(path);
			path = StringTools.replace(path, "." + fileExt, ".hmd");
		}
		AssetsUtils.loadBytes(path, function(data) {
			var fs = new BytesFileEntry(path, data);
			var m = new Model(fs);
			var hmd = m.toHmd();
			//var hmd = toHmd(m);
		
			// 解析这里的所有图片
			var rootName = getName();
			var rootPath = path.substr(0, path.lastIndexOf("/") + 1);
			var assets:Assets = new Assets();
			var pngs = [];
			function pushToList(path:String) {
				if (pngs.indexOf(path) == -1) {
					pngs.push(path);
				}
			}
			for (material in hmd.header.materials) {
				if (material.diffuseTexture != null && !checkExist(rootName, material.diffuseTexture)) {
					pushToList(material.diffuseTexture);
				}
				if (material.specularTexture != null && !checkExist(rootName, material.specularTexture)) {
					pushToList(material.specularTexture);
				}
				if (material.normalMap != null && !checkExist(rootName, material.normalMap)) {
					pushToList(material.normalMap);
				}
			}
			if (pngs.length > 0) {
				for (file in pngs) {
           			var parser = new HMDTextureParser(rootPath + file);
					parser.assetsId = file;
					assets.loadParser(parser);
				}
				assets.start((f) -> {
					if (f == 1) {
						// 使用HMDid返回
						var map = @:privateAccess assets._loadedData.get(BITMAP);
						if (map != null) {
							for (key => value in map) {
								_setName = key;
								this.out(this, BITMAP, value, 0);
							};
							_setName = null;
							this.out(this, HMD, hmd, 1);
						}
					}
				});
			} else {
				this.out(this, HMD, hmd, 1);
			}
		}, error);
	}

	/**
	 * 检测是否已经存在一样的资源
	 * @param id 
	 * @param path 
	 * @return Bool
	 */
	function checkExist(id:String, path:String):Bool {
		return AssetsBuilder.getTexture3D(path) != null;
	}

	override function getName():String {
		return _setName != null ? _setName : super.getName();
	}
}

/**
 * HMD加载的图片希望使用原生路径，以便资源复用
 */
class HMDTextureParser extends BitmapDataParser {
	public var assetsId:String = null;

	override function getName():String {
		// 这里直接返回路径
		assetsId = StringTools.replace(assetsId, ".", "_");
		assetsId = StringTools.replace(assetsId, "/", "_");
		return assetsId;
	}
}

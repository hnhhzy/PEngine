package hxPEngine.ui.util;

import hxPEngine.ui.res.SpineTextureAtlas;
import domkit.CssStyle.Rule;
import hxd.fs.Convert;
import hxd.poly2tri.Node;
import hxd.fmt.hmd.Data.Material;
import hxPEngine.ui.loader.parser.BaseParser;
import hxPEngine.ui.loader.parser.AssetsType;
import hxPEngine.ui.loader.parser.AtlasParser;
import hxPEngine.ui.loader.LoaderAssets;
import hxd.BitmapData;
import hxd.res.Image;
import hxd.clipper.Rect;
import hxPEngine.ui.loader.parser.XMLAtlas;
import h3d.mat.Texture;
import hxd.fmt.hmd.Library;
import h3d.scene.Object;
import h2d.Tile;
import haxe.Exception;
import haxe.io.Bytes;
import hxd.res.Sound;
import hxd.res.Atlas;
// import hxPEngine.ui.display.Label;
import hxPEngine.ui.display.Label;
import h2d.Font;

using Reflect;

/**
 * 资源管理器
 */
class Assets {
	/**
	 * 加载最大线程
	 */
	public var maxLoadCounts:Int = #if hl 30 #else 10 #end;

	/**
	 * 可提供路径，更改默认的加载路径，它会拼接在所有的加载资源的前面
	 */
	public var repath:String = null;

	/**
	 * 当前已载入的线程
	 */
	private var _currentLoadCounts:Int = 0;

	private var _loadlist:Array<BaseParser> = [];

	private var _loadedData:Map<AssetsType, Map<String, Dynamic>> = [];

	/**
	 * 当前载入进度
	 */
	private var _currentLoadIndex = 0;

	/**
	 * 已载入完成的数量
	 */
	private var _loadedCounts:Int = 0;

	/**
	 * 加载回调
	 */
	private var _onProgress:Float->Void;

	public function new() {}

	/**
	 * 拼接repath的加载路径
	 * @param path 
	 * @return String
	 */
	public function addRepath(path:String):String {
		if (repath == null)
			return path;
		if (!StringTools.endsWith(repath, "/")) {
			return repath + "/" + path;
		}
		return repath + path;
	}

	/**
	 * 加载单个文件
	 * @param file 
	 */
	public function loadFile(file:String):Void {
		var ext = StringUtils.getExtType(file);
		//trace("loadFile:", file, ext);
		for (parser in LoaderAssets.fileparser) {
			//trace("parser:", parser);
			var bool = parser.callMethod(parser.getProperty("support"), [ext]);
			if (bool) {
				_loadlist.push(Type.createInstance(parser, [addRepath(file)]));
				break;
			}
		}
	}

	/**
	 * 加载一个解析器
	 * @param parser 
	 */
	public function loadParser(parser:BaseParser):Void {
		_loadlist.push(parser);
	}

	/**
	 * 加载单个fbx
	 * @param file 
	 */
	public function loadFbx(file:String):Void {
		var ext = StringUtils.getExtType(file);
		for (parser in LoaderAssets.fileparser) {
			var bool = parser.callMethod(parser.getProperty("support"), [ext]);
			if (bool) {
				_loadlist.push(Type.createInstance(parser, [addRepath(file)]));
				break;
			}
		}
	}

	/** 
		加载精灵图
	**/
	public function loadAtlas(png:String, xml:String):Void {
		_loadlist.push(new AtlasParser({
			png: addRepath(png),
			xml: addRepath(xml)
		}));
	}

	/**
	 * 加载Spine精灵图
	 * @param pngs 
	 * @param atlas 
	 */
	public function loadSpineAtlas(pngs:Array<String>, atlas:String):Void {
		#if spine_hx
		for (index => value in pngs) {
			pngs[index] = addRepath(value);
		}
		atlas = addRepath(atlas);
		_loadlist.push(new hxPEngine.ui.loader.parser.SpineAtlasParser({
			pngs: pngs,
			atlas: atlas
		}));
		#end
	}

	/**
	 * 用于重写解析路径名称
	 * @param path
	 * @return String
	 */
	dynamic public function onPasingPathName(path:String):String {
		return StringUtils.getName(path);
	}

	/**
	 * 开始加载
	 * @param cb 
	 */
	public function start(cb:Float->Void):Void {
		_onProgress = cb;
		_currentLoadIndex = 0;
		_currentLoadCounts = 0;
		_loadedCounts = 0;
		loadNext();
	}

	/**
	 * 开始加载下一个
	 */
	private function loadNext():Void {
		if (_currentLoadCounts >= maxLoadCounts)
			return;
		if (_loadedCounts >= _loadlist.length) {
			// 加载完成
			_onProgress(1);
			return;
		} else {
			_onProgress((_loadedCounts) / _loadlist.length);
		}
		_currentLoadCounts++;
		_currentLoadIndex++;
		var parser = _loadlist[_currentLoadIndex - 1];
		if (parser == null)
			return;
		parser.out = onAssetsOut;
		parser.error = onError;
		parser.load(this);
		// 发起多个加载
		if (_currentLoadCounts < maxLoadCounts)
			loadNext();
	}

	public function onError(msg:String):Void {
		trace("load fail:", msg);
	}

	/**
	 * 加载完成资源输出
	 * @param parser 
	 * @param type 
	 * @param assetsData 
	 * @param pro 
	 */
	private function onAssetsOut(parser:BaseParser, type:AssetsType, assetsData:Dynamic, pro:Float):Void {
		if (assetsData != null) {
			setTypeAssets(type, parser.getName(), assetsData);
		}
		if (pro == 1) {
			// 下一个
			_loadedCounts++;
			_currentLoadCounts--;
			this.loadNext();
		}
	}

	/**
	 * 判断此类型的资源是否存在
	 * @param type 
	 * @param name 
	 * @return Bool
	 */
	public function hasTypeAssets(type:AssetsType, name:String):Bool {
		if (_loadedData.exists(type)) {
			return _loadedData.get(type).exists(name);
		}
		return false;
	}

	/**
	 * 获取此类型的资源
	 * @param type 
	 * @param name 
	 * @return Dynamic
	 */
	public function getTypeAssets(type:AssetsType, name:String):Any {
		if (_loadedData.exists(type)) {
			return _loadedData.get(type).get(name);
		}
		return null;
	}

	/**
	 * 设置此类型的资源
	 * @param type 
	 * @param name 
	 * @param data 
	 */
	public function setTypeAssets(type:AssetsType, name:String, data:Any):Void {
		if (!_loadedData.exists(type)) {
			_loadedData.set(type, []);
		}
		_loadedData.get(type).set(name, data);
	}

	/**
	 * 获取纹理对象，请注意，ImageBitmap使用的是`Tile`数据，可直接通过`getBitmapDataTile`获取。
	 * @param id 
	 * @return BitmapData
	 */
	public function getBitmapData(id:String):BitmapData {
		if (hasTypeAssets(BITMAP_DATA, id))
			return getTypeAssets(BITMAP_DATA, id);
		if (hasTypeAssets(BITMAP, id)) {
			var bitmap:Image = getTypeAssets(BITMAP, id);
			var bmd = bitmap.toBitmap();
			setTypeAssets(BITMAP_DATA, id, bmd);
			return bmd;
		}
		return null;
	}

	/**
	 * 获取对应的九宫格图数据
	 * @param id 
	 * @return Rect
	 */
	public function getScale9Grid(id:String):Rect {
		var arr = id.split(":");
		var atlas = this.getAtlas(arr[0]);
		if (atlas != null && atlas is XMLAtlas) {
			return cast(atlas, XMLAtlas).getScale9GridById(arr[1]);
		}
		return null;
	}

	/**
	 * 通过id获取3D纹理
	 * @param id 
	 * @return Texture
	 */
	public function getTexture3D(id:String):Texture {
		if (hasTypeAssets(TEXTURE_3D, id))
			return getTypeAssets(TEXTURE_3D, id);
		if (hasTypeAssets(BITMAP, id)) {
			var bitmap:Image = getTypeAssets(BITMAP, id);
			var bmd = bitmap.toBitmap();
			var t3d = Texture.fromBitmap(bmd);
			setTypeAssets(TEXTURE_3D, id, t3d);
			return t3d;
		}
		return null;
	}

	/**
	 * 获取HMDLibrary
	 * @param id 
	 * @return Library
	 */
	public function getHMDLibrary(id:String):Library {
		if (hasTypeAssets(HMD, id))
			return getTypeAssets(HMD, id);
		return null;
	}

	/**
	 * 创建3D模型
	 * @param id 
	 * @return Object
	 */
	public function create3DModel(id:String):Object {
		var hmd = getHMDLibrary(id);
		if (hmd != null) {
			return hmd.makeObject((path) -> {
				// 这里直接使用全路径
				path = StringTools.replace(path, ".", "_");
				path = StringTools.replace(path, "/", "_");
				return AssetsBuilder.getTexture3D(path);
			});
		}
		return null;
	}

	/**
	 * 加载fbx模型
	 * @param id 
	 * @return Object
	 */
	public function loadFbxModel(id:String):Object {
		var hmd = getHMDLibrary(id);
		if (hmd != null) {
			return hmd.makeObject((path) -> {
				path = StringTools.replace(path, ".", "_");
				path = StringTools.replace(path, "/", "_");
				return AssetsBuilder.getTexture3D(path);
			});
		}
		return null;
	}
	/**
	 * [Description]
	 * @param id 
	 * @return h3d.anim.Animation
	 */
	public function getHMDAnimation(id:String):h3d.anim.Animation {
		var hmd = getHMDLibrary(id);
		if (hmd != null) {
			return hmd.loadAnimation();
		}
		return null;
	}

	/**
	 * 返回HMD 动画集合
	 * @param id 
	 * @return Array<hxd.fmt.hmd.Data.Animation>
	 */
	public function getHMDAnimationList(id:String):Array<hxd.fmt.hmd.Data.Animation>{
		var hmd = getHMDLibrary(id);
		
		if (hmd != null) {
			return hmd.header.animations;
		}

		return null;


	}

	/**
	 * 返回Model集合
	 * @param id 
	 * @return Array<hxd.fmt.hmd.Data.Model>
	 */
	public function getHMDModelsList(id:String):Array<hxd.fmt.hmd.Data.Model>{
		var hmd = getHMDLibrary(id);
		if (hmd != null) {
			return hmd.header.models;
		}

		return null;
	}

	/**
	 * 返回Material集合
	 * @param id 
	 * @return Array<hxd.fmt.hmd.Data.Material>
	 */
	public function getHMDMaterialList(id:String):Array<hxd.fmt.hmd.Data.Material>{
		var hmd = getHMDLibrary(id);
		if (hmd != null) {
					//trace(hmd.header.version);
					// Material mm = new Material();
					// mm.blendMode = None;

					
					// if(hasTypeAssets(BITMAP,"I:/Myproject/HeapsPlus/PEngine/res/img/sword01.png")  ){
					// 	trace(1);
		
					// }

					// if(AssetsBuilder.getTexture3D("sword01.png")!=null){
					// 	trace(2);
					// }
					//trace(_loadedData);
					
			return hmd.header.materials;
		}

		return null;
	}

	public function setHMDMaterialList1(id:String):Void{
		var hmd = getHMDLibrary(id);
		if (hmd != null) {

			// var fbx = try hxd.fmt.fbx.Parser.parse(srcBytes) catch( e : Dynamic ) throw Std.string(e) + " in " + srcPath;
			// var hmdout = new hxd.fmt.fbx.HMDOut("I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.hmd");
			// hmdout.load()
			// trace(hmdout);

			
			// var url = "I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx";
			// var c = new hxPEngine.ui.util.Conver.ConvertFBX2HMDNew();
			// c.originalFilename = "Model.fbx";
			// c.srcPath = url;
			// c.srcBytes = sys.io.File.getBytes(url);
			// c.dstPath = StringTools.replace(url, "." + StringUtils.getExtType(url), "_new.hmd");			
			// c.modify(hmd.header);
			// trace("FBX2HDM:", c.dstPath);

 			
			

			


		}
	}



	public function setHMDMaterialList(id:String, materials:Array<hxd.fmt.hmd.Data.Material>):Void{
		var hmd = getHMDLibrary(id);
		if (hmd != null) {

			// var fbx = try hxd.fmt.fbx.Parser.parse(srcBytes) catch( e : Dynamic ) throw Std.string(e) + " in " + srcPath;
			// var hmdout = new hxd.fmt.fbx.HMDOut("I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.hmd");
			// hmdout.load()
			// trace(hmdout);

			hmd.header.materials = materials;
			// var url = "I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx";
			// var c = new hxPEngine.ui.util.Conver.ConvertFBX2HMDNew();
			// c.originalFilename = "Model.fbx";
			// c.srcPath = url;
			// c.srcBytes = sys.io.File.getBytes(url);
			// c.dstPath = StringTools.replace(url, "." + StringUtils.getExtType(url), "_new.hmd");			
			// c.modify(hmd.header);
			// trace("FBX2HDM:", c.dstPath);

 			for (i in hmd.header.materials){
				//trace(StringTools.replace(, "\\", "/"));.
				trace(getName(i.diffuseTexture));
				
				trace(i.normalMap);
				trace(i.specularTexture);
				if(isNULL(i.diffuseTexture)){
					if(AssetsBuilder.getTexture3D(getName(i.diffuseTexture))== null){
						loadFile(StringTools.replace(i.diffuseTexture, "\\", "/"));
					}
					
				}
				if(isNULL(i.normalMap)){
					trace(getName(i.normalMap));
					trace(StringTools.replace(i.normalMap, "\\", "/"));
					if(AssetsBuilder.getTexture3D(getName(i.normalMap))== null){
						loadFile(StringTools.replace(i.normalMap, "\\", "/"));
					}
					
				}
				if(isNULL(i.specularTexture)){
					trace(getName(i.specularTexture));
					trace(StringTools.replace(i.specularTexture, "\\", "/"));
					if(AssetsBuilder.getTexture3D(getName(i.specularTexture))== null){
						loadFile(StringTools.replace(i.specularTexture, "\\", "/"));
					}
					
				}
				
				
				
			}
			// start(function(f) {
            //     if (f == 1) {
			// 		for (i in hmd.header.materials){
			// 			var obj = loadFbxModel(id);
			// 			var m = obj.getMaterialByName(i.name);
			// 			trace(getName(i.diffuseTexture));
			// 			var tex = AssetsBuilder.getTexture3D(getName(i.diffuseTexture));
			// 			m.texture = tex;
			// 		}
					
                    
                    
            //     }
            // });

			// var obj = loadFbxModel("Model");
			// var m = obj.getMaterialByName("Sword01");
			// //trace(getName(i.diffuseTexture));
			// var tex = AssetsBuilder.getTexture3D("btn_LvSe");
			// m.texture = tex;


			


		}
	}

	public function isNULL(string:String):Bool{
		if(string != null && string != ""){
			return true;
		}
		return false;
	

	}
	public function getName(name): String{
        var path = StringTools.replace(name, "\\", "/");
        var fileName = StringUtils.getName(path);
        return fileName;
    }







	/**
	 * 获取位图瓦片对象
	 * @return Tile
	 */
	public function getBitmapDataTile(id:String):Tile {
		try {
			if (id.indexOf(":") != -1) {
				// 精灵图格式
				var arr = id.split(":");
				return getBitmapDataAtlasTile(arr[0], arr[1]);
			}
			if (!hasTypeAssets(BITMAP_TILE, id)) {
				var bitmap:Image = getTypeAssets(BITMAP, id);
				setTypeAssets(BITMAP_TILE, id, bitmap.toTile());
			}
		} catch (e:Exception) {}
		return getTypeAssets(BITMAP_TILE, id);
	}

	/**
	 * 获取精灵图对象
	 * @param id 精灵图名称
	 * @param sprid 精灵名称
	 * @return Tile
	 */
	public function getBitmapDataAtlasTile(id:String, sprid:String):Tile {
		var atlas:XMLAtlas = getTypeAssets(ATLAS, id);
		return atlas.get(sprid);
	}

	/**
	 * 获取JSON对象
	 * @param id 
	 * @return Dynamic
	 */
	public function getJson(id:String):Dynamic {
		return getTypeAssets(JSON, id);
	}
	/**
	 * 获取JSON对象
	 * @param id 
	 * @return Dynamic
	 */
	 public function getRule(id:String):Dynamic {
		return getTypeAssets(JSON, id);
	}

	/**
	 * 获取XML对象
	 * @param id 
	 * @return Xml
	 */
	public function getXml(id:String):Xml {
		return getTypeAssets(XML, id);
	}

	/**
	 * 获取二进制对象
	 * @param id 
	 * @return Bytes
	 */
	public function getBytes(id:String):Bytes {
		return getTypeAssets(BYTES, id);
	}

	/**
	 * 获取音频对象
	 * @param id 
	 * @return Sound
	 */
	public function getSound(id:String):Sound {
		return getTypeAssets(SOUND, id);
	}

	/**
	 * 获取精灵图
	 * @param id 
	 * @return Atlas
	 */
	public function getAtlas(id:String):Atlas {
		return getTypeAssets(ATLAS, id);
	}

	/**
	 * 获取Spine的精灵图
	 * @param id 
	 * @return SpineTextureAtlas
	 */
	public function getSpineAtlas(id:String):#if spine_hx SpineTextureAtlas #else Dynamic #end {
		return getTypeAssets(SPINE_ATLAS, id);
	}

	/**
	 * 创建Spine对象
	 * @param atlasName 
	 * @param jsonName 
	 * @return Spine
	 */
	public function createSpine(atlasName:String, jsonName:String):#if spine_hx hxPEngine.ui.display.Spine #else Dynamic #end {
		return this.getSpineAtlas(atlasName).buildSpriteSkeleton(atlasName, this.getJson(jsonName));
	}

	/**
	 * 构造一个缓存文字
	 * @param id 缓存文字ID
	 * @param size 缓存文字的尺寸
	 * @param chars 缓存文字字符串
	 * @param font 缓存文字的字体，如果不提供的话，会使用`Label.defaultFont`的字体
	 */
	public function createCacheFont(id:String, size:Int, chars:String, font:String = null):Void {
		var font = FontBuilder.getFont(font == null ? Label.defaultFont : font, size, {
			chars: chars
		});
		this.setTypeAssets(FONT, id, font);
	}

	/**
	 * 根据ID获取缓存字体
	 * @param id 
	 * @return Font
	 */
	public function getFont(id:String):Font {
		var font = this.getTypeAssets(FONT, id);
		return font;
	}

	/**
	 * 卸载所有资源
	 */
	public function unloadAll():Void {
		unloadTypeAssets(AssetsType.ATLAS);
		unloadTypeAssets(AssetsType.BITMAP);
		unloadTypeAssets(AssetsType.BITMAP_TILE);
		unloadTypeAssets(AssetsType.BYTES);
		unloadTypeAssets(AssetsType.JSON);
		unloadTypeAssets(AssetsType.SOUND);
		unloadTypeAssets(AssetsType.SPINE_ATLAS);
		unloadTypeAssets(AssetsType.XML);
	}

	/**
	 * 卸载对应类型的资源
	 * @param type 
	 */
	public function unloadTypeAssets(type:AssetsType):Void {
		if (_loadedData.exists(type)) {
			var m = _loadedData.get(type);
			for (key => value in m) {
				if (value is Tile) {
					cast(value, Tile).dispose();
				}
			}
			_loadedData.remove(type);
		}
	}
}

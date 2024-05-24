
import hxd.Res;
import h3d.Camera;
import h3d.Vector;
import format.abc.Data.ABCData;
import haxe.ds.Map;
import h3d.scene.CameraController;
import h2d.Object;
import hxPEngine.ui.util.StringUtils;
import hxd.res.Loader;
import hxPEngine.ui.util.AssetsBuilder;
import haxe.io.Bytes;
import h3d.scene.fwd.DirLight;
import hxPEngine.ui.util.Assets;
import haxe.Json;
#if hl
import hxd.fs.Convert.ConvertFBX2HMD;
#end
import hxd.fmt.pak.FileSystem;
#if js
import js.html.CanvasElement;
import js.Browser.document;
import js.html.RequestInit;
#end
import hxPEngine.ui.display.Button;
import hxPEngine.ui.UIEntity;
import hxPEngine.ui.UIWindow;

// @:expose
// class FbxLoader {
//   var url:String;

//   function new(url:String) {
//     this.url = url;
//     var main = new MainJS();
//     main.load(url);
//   }
// }

@:expose
class MainJS {
    static var mainApp:MainApp = null;
    public static function load(url:String) {
        if(mainApp == null) {
            mainApp = new MainApp();
            mainApp.setUrl(url);


        }else{
            mainApp.setinit(url);
        }
        
    }

    public static function getHMDMaterialList(): Array<hxd.fmt.hmd.Data.Material>{
        if(mainApp!=null){
            return mainApp.getHMDMaterialList();
        }
        return null;
       
    }
    public static function getHMDModelList(): Array<hxd.fmt.hmd.Data.Model>{
        if(mainApp!=null){
            return mainApp.getHMDModelList();
        }
        return null;
       
    }
    public static function getHMDAnimationList(): Array<hxd.fmt.hmd.Data.Animation>{
        if(mainApp!=null){
            return mainApp.getHMDAnimationList();
        }
        return null;
       
    }

    public static function getName():String{
        if(mainApp!=null){
            return mainApp.getName();
        }
        return "";
    }

    public static function setHMDMaterialList(materialList:Array<hxd.fmt.hmd.Data.Material>): Array<hxd.fmt.hmd.Data.Material>{
        if(mainApp!=null){
            mainApp.setHMDMaterialList(materialList);
        }
        trace(materialList);
        return materialList;
    }


    public static function changeE() {
        if(mainApp!=null){
            mainApp.changeE();
        }
    }

    static function main() {
        var a = new MainApp();
        //a.setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx');
    }
}


class MainApp extends hxd.App {
    
    var cache : h3d.prim.ModelCache;
    var url:String;
    var assets:Assets = new Assets();
    var cameraController:CameraController = null;
    var fbxList:Map<String,Int> = new Map<String,Int>();
    var fbxListPos:Map<Int,Vector> = new Map<Int,Vector>();
    var fbxListTarget:Map<Int,Vector> = new Map<Int,Vector>();
   // var fbxListCamera:Map<Int,Camera> = new Map<Int,Camera>();
    var indexObj:Int = -1;
    private static var _sceneMap:Map<String, UIWindow> = [];
    var scene1:TestUI = null;
    var obj:h3d.scene.Object = null;

    function setCarmerInfoToMap(){
        if(indexObj == -1) {
            return;
        }
        var json = Json.parse(getCarmerInfo());
        var pos = json.pos;
        var target = json.target;
        //fbxListPos[indexObj] = new Vector(pos.x,pos.y,pos.z);
        fbxListPos[indexObj] = new Vector(pos.x,pos.y,pos.z);
        fbxListTarget[indexObj] = new Vector(target.x,target.y,target.z);
    }

    function setCarmerFromMap(index:Int){
        if(index == -1) {
            return;
        }
        var pVector = fbxListPos[index];
        var tVector = fbxListTarget[index];

        s3d.camera.pos.x = pVector.x;
        s3d.camera.pos.y = pVector.y;
        s3d.camera.pos.z = pVector.z;
        s3d.camera.target.x = tVector.x;
        s3d.camera.target.y = tVector.y;
        s3d.camera.target.z = tVector.z;

        // s3d.camera.pos.set(pVector.x,pVector.y,pVector.z);
        // s3d.camera.target.set(tVector.x,tVector.y,tVector.z);
        // s3d.camera.update();
    }

    function getfbxListPos():String{
        var jsonStr:String = "";
        for(i in fbxListPos.keys()){
            var pos = fbxListPos[i];
            jsonStr += i+":"+pos.x+","+pos.y+","+pos.z+"|";
        }
        return jsonStr;
    }

    function getCarmerInfo():String{
        var camera = s3d.camera;
        //var pos = camera.pos;
        var pos = new Vector(camera.pos.x,camera.pos.y,camera.pos.z);
        //var target = camera.target;
        var target = new Vector(camera.target.x,camera.target.y,camera.target.z);
        var jsonStr:String = Json.stringify({pos:pos,target:target});
        return jsonStr;
    }


    public function new() {
        super();
        
    }
    private static function createScene<T:UIWindow>(cName:Class<T>):T {
		var name = Type.getClassName(cName);
		if (_sceneMap.exists(name)) {
			return cast _sceneMap.get(name);
		}
		var scene = Type.createInstance(cName, []);
		_sceneMap.set(name, scene);
		return scene;
	}


    override function update(dt : Float) {
        // trace("update");
        #if hl
        hxPEngine.ui.util.hl.Thread.loop( );
        #end
        //scene1.setFps(hxd.Timer.fps(),getCarmerInfo(),getfbxListPos());
     }
    
    public function getName(): String{
        var path = StringTools.replace(this.url, "\\", "/");
        var fileName = StringUtils.getName(path);
        return fileName;
    }
    public function getName1(string:String): String{
        var path = StringTools.replace(string, "\\", "/");
        var fileName = StringUtils.getName(path);
        return fileName;
    }

    // 调取动画
    public function getHMDAnimationList(): Array<hxd.fmt.hmd.Data.Animation>{
        
        var animations:Array<hxd.fmt.hmd.Data.Animation> = assets.getHMDAnimationList(getName());
        //var jsonStr:String = Json.stringify(animations);
        return animations;
    }

    // 模型层级
    public function getHMDModelList(): Array<hxd.fmt.hmd.Data.Model>{
        var model:Array<hxd.fmt.hmd.Data.Model> = assets.getHMDModelsList(getName());
        //var jsonStr:String = Json.stringify(model);
        return model;
    }

    // 贴图
    public function getHMDMaterialList(): Array<hxd.fmt.hmd.Data.Material>{
        var material:Array<hxd.fmt.hmd.Data.Material> = assets.getHMDMaterialList(getName());
        for (materialElement in material) {
            if (materialElement.normalMap == null) {
                materialElement.normalMap = null; // 将缺失的漫反射属性设置为默认值
            }
            if (materialElement.specularTexture == null) {
                materialElement.specularTexture = null; // 将缺失的漫反射属性设置为默认值
            }
            if(materialElement.diffuseTexture == null) {
                materialElement.diffuseTexture = null;
            }
            
            
        }
        
        return material;
    }

    public function setHMDMaterialList(materials:Array<hxd.fmt.hmd.Data.Material>) :Void{
        assets.setHMDMaterialList(getName(),materials);

       // var obj = assets.loadFbxModel("Model");

       assets.start(function(f) {
                if (f == 1) {
					for (i in materials){
						
						var m = obj.getMaterialByName(i.name);
						trace(getName1(i.diffuseTexture));
                        if(i.diffuseTexture!=null){
                            var tex = AssetsBuilder.getTexture3D(getName1(i.diffuseTexture));
                            m.texture = tex;
                        }
						
                        m.blendMode = i.blendMode;
                        if(i.normalMap != null){
                            m.normalMap  = AssetsBuilder.getTexture3D(getName1(i.normalMap));
                        }
                        if(i.specularTexture != null){
                            m.specularTexture = AssetsBuilder.getTexture3D(getName1(i.specularTexture));
                        }
                        //m.specularTexture = null;
                        
					}
                }
            });
			// var m = obj.getMaterialByName("Sword01");
			// //trace(getName(i.diffuseTexture));
			// var tex = AssetsBuilder.getTexture3D("btn_LvSe");
			// m.texture = tex;

    
        
    }
    public function changeE() {
        //var hmd = assets.getHMDLibrary("Model_new");
        var m = obj.getMaterialByName("Sword01");
        


        // accesss the logo resource and convert it to a texture
        //var tex = assets.getTexture3D("inventory_button");
         var tex = AssetsBuilder.getTexture3D("btn_LvSe");

        // create a material with this texture
        //var mat = h3d.mat.Material.create(tex)


         //m.normalMap = tex;
         m.specularTexture = tex;
         m.blendMode = h2d.BlendMode.Add;
         m.texture = tex;
        //m.
        //trace(m);

        //h3d.mat.Texture = hmd.header.materials;

        //hmd.header.materials[0].diffuseTexture = "sword01.png";
        //trace("change");
    }



    public function getFbx(){
        for(i in fbxList) {
            s3d.getChildAt(i).visible = false;
        }

        if(fbxList[url] == null) {
            var path = StringTools.replace(this.url, "\\", "/");
            var fileName = StringUtils.getName(path);
            cache = new h3d.prim.ModelCache();
            
            obj = assets.loadFbxModel(fileName);
            //trace(Json.stringify(getHMDAnimationList()));
            
            
            
            //var obj = cache.loadModel(hxd.Res.img.Model);                    
            obj.scale(0.1);
            s3d.addChild(obj);
            //s3d.camera.pos.set( -3, -5, 3, 1);
            //s3d.camera.target.set(0, 0, 0, 1);

            s3d.camera.pos.set( 0.125, -7, 3, 1);
            s3d.camera.target.set(0.06, 0.26, 0.66, 1);
            //s3d.camera.target.z = 1;
            //s3d.camera.target.z += 1;
            obj.playAnimation(assets.getHMDAnimation(fileName));

            
            //getHMDMaterialList();
            //trace(getHMDMaterialList().toString());
            //obj.playAnimation(cache.loadAnimation(hxd.Res.img.model));
    
    
            // add lights and setup materials
            var dir = new DirLight(new h3d.Vector( -1 , 3, -10), s3d);
            //var dir = new DirLight(new h3d.Vector( -1 ,3, 1), s3d);
            for( m in obj.getMaterials() ) {
            var t = m.mainPass.getShader(h3d.shader.Texture);
            if( t != null ) t.killAlpha = true;
            m.mainPass.culling = None;
            m.getPass("shadow").culling = None;
            }
            var shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
            shadow.power = 20;
            shadow.color.setColor(0x301030);
            dir.enableSpecular = true;
    
        

            // 暂时去掉
            if(cameraController == null) {
                cameraController = new h3d.scene.CameraController(s3d);
                cameraController.loadFromCamera();
            }else {
                cameraController.loadFromCamera();
            }
            
            indexObj = s3d.getChildIndex(obj);
            fbxList[url] = indexObj;
            setCarmerInfoToMap();


        }else {
            setCarmerInfoToMap();
            indexObj = s3d.getChildIndex(s3d.getChildAt(fbxList[url]));
            s3d.getChildAt(fbxList[url]).visible = true;    
            setCarmerFromMap(indexObj);
            cameraController.loadFromCamera();
            
        
        }
    }

    public function setinit(url:String){

        if(s3d == null) {
            return;
        }

        this.url = url;

        if(assets.hasTypeAssets(HMD,getName())){
            trace('hasTypeAssets');
            getFbx();
            
        }else{
        
            assets.loadFile(StringTools.replace(this.url, "\\", "/"));
            //assets.loadFile("res/img/images.png");
            assets.start(function(f) {
                if (f == 1) {
                    trace('loading over');
                    
                
                    getFbx();
                    
                    
                }
            });
        }

    }

    public function setUrl(url:String){
        this.url = url;
    }

    


    override function init() {
        super.init();





        #if hl
        // trace("=========loading path====================");
        // trace(this.url);
        // trace("=========start to convert fbx====================");
        // var e;
        // var resourceDir = "I:\\Myproject\\HeapsPlus\\PEngine\\res";

        // hxd.Res.initLocal();

        

        // //setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx');

        // this.url = "I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\model111.fbx";

        // // 转换为HMD
        // var c = new ConvertFBX2HMD();
        // c.originalFilename = "model111.fbx";
        // c.srcPath = this.url;
        // c.srcBytes = sys.io.File.getBytes(this.url);
        // c.dstPath = StringTools.replace(this.url, "." + StringUtils.getExtType(this.url), ".hmd");
        // c.convert();
        // trace("FBX2HDM:", c.dstPath);
        #end
       // hxd.Res.initEmbed();
        hxd.res.Loader.currentInstance = new Loader(new FileSystem());
        AssetsBuilder.bindAssets(assets);
        setinit(this.url);

        //
        //hxd.res.Loader.currentInstance = new CustomLoader(new hxd.fs.LocalFileSystem(localDir,fsconf));
		//hxd.res.Image.ASYNC_LOADER = new hxd.impl.AsyncLoader.NodeLoader();
        //hxd.res.Loader.currentInstance.load("I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\model.fbx");


        //assets = new Assets(); 
        
        //assets.loadFile("res/img/skeleton01.png");
        //assets.loadFile("res/img/sword01.png");
        //assets.loadFile("res/img/model.hmd");
        //setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx');

        // scene1 = createScene(TestUI);
        // s2d.addChild(scene1);
        
        
      // creates three tiles with different color
// var t1 = Res.role.image0.toTile();
// var t2 = Res.role.image1.toTile();
// var t3 = Res.role.image2.toTile();
// var t4 = Res.role.image3.toTile();
// var t5 = Res.role.image4.toTile();
// var t6 = Res.role.image5.toTile();
// var anim = new h2d.Anim([t1,t2,t3,t4,t5,t6],s2d); 

        // assets.loadFile("package.xml") {
           // var UIWindow = assets.getUILibrary("uiWindow")
           // s2d.add(UIWindow);
           // if (extention == "Button") {
         //       var this_btn = createaBtn()
         //       this_btn.x 
         //  }
        // }

        // assets.loadFile(StringTools.replace(this.url, "\\", "/"));
        // assets.start(function(f) {
        //     if (f == 1) {
        //          trace('loading over');
        //         /*
        //         var hmd = assets.getHMDLibrary("Model");
        //         //for(var i in hmd.header.materials) {
        //         var path = StringTools.replace(this.url, "\\", "/");
        //         var fileName = StringUtils.getName(path);
        //         var fileExt = StringUtils.getExtType(path);
        //         path = StringTools.replace(path, fileName + "." + fileExt, "");
        //         for (pass in hmd.header.materials) {
        //             assets.loadFile(path + "/" + StringTools.replace(pass.diffuseTexture, "\\", "/"));
        //         }
        //         assets.start(function(k) {
        //             if (k == 1) {
                       

        //             }
        //         });
        //         */



        //         var path = StringTools.replace(this.url, "\\", "/");
        //         var fileName = StringUtils.getName(path);
        //         // var ss = assets.getHMDAnimationList(fileName);
        //         // var animations:Array<hxd.fmt.hmd.Data.Animation> = assets.getHMDAnimationList(fileName);
        //         // var jsonStr:String = Json.stringify(animations);
        //         // var dd = assets.getHMDAnimationList(fileName).toString;
        //         // var haa = Json.stringify(assets.getHMDAnimationList(fileName).toString);
        //         cache = new h3d.prim.ModelCache();
                  
        //         var obj = assets.loadFbxModel(fileName);
                
                
        //         //var obj = cache.loadModel(hxd.Res.img.Model);
        //         obj.scale(0.1);
        //         s3d.addChild(obj);
        //         s3d.camera.pos.set( -3, -5, 3);
        //         s3d.camera.target.z += 1;
        //         obj.playAnimation(assets.getHMDAnimation(fileName));
        //         //obj.playAnimation(cache.loadAnimation(hxd.Res.img.model));
        
        
        //         // add lights and setup materials
        //         var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
        //         for( m in obj.getMaterials() ) {
        //         var t = m.mainPass.getShader(h3d.shader.Texture);
        //         if( t != null ) t.killAlpha = true;
        //         m.mainPass.culling = None;
        //         m.getPass("shadow").culling = None;
        //         }
        //         var shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
        //         shadow.power = 20;
        //         shadow.color.setColor(0x301030);
        //         dir.enableSpecular = true;
        
        //         new h3d.scene.CameraController(s3d).loadFromCamera();
                
                
        //     }
        // });


       // hxd.Res.initEmbed();
        //hxd.Res.initLocal();
       // hxd.Res.initLocal();
        
       // hxd.Res.load("res/img/Model.fbx");

        //var hmdOut = new hxd.fmt.fbx.HMDOut("res/img/model.fbx");
        //trace(hmdOut);

        /*
        var data:Bytes;
        var d = hxd.res.Any.fromBytes("",sys.io.File.getBytes("res/img/model.fbx"));
        trace(d);
        */

        /*
        var assets = new Assets();        
        assets.loadFile("res/img/model.fbx");
        assets.start(function(f) {
            if (f == 1) {
                trace('加载完成');
            }
        });
     
        */

        /*
        
        cache = new h3d.prim.ModelCache();
        
        var obj = cache.loadModel(hxd.Res.img.model);
        //var obj = cache.loadModel(hxd.Res.img.Model);
        obj.scale(0.1);
        s3d.addChild(obj);
        s3d.camera.pos.set( -3, -5, 3);
        s3d.camera.target.z += 1;
        obj.playAnimation(cache.loadAnimation(hxd.Res.img.model));


        // add lights and setup materials
        var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
        for( m in obj.getMaterials() ) {
        var t = m.mainPass.getShader(h3d.shader.Texture);
        if( t != null ) t.killAlpha = true;
        m.mainPass.culling = None;
        m.getPass("shadow").culling = None;
        }
        var shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
        shadow.power = 20;
        shadow.color.setColor(0x301030);
        dir.enableSpecular = true;

        new h3d.scene.CameraController(s3d).loadFromCamera();
*/
        

    }
    static function main() {
        #if mac_run
        new MainJS('res/img/model.fbx');
        #else
       // var a = new MainApp();
       // a.setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx');
        
        #end
    }
}
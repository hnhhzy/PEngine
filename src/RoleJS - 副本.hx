
import hxd.Pixels;
import h2d.Tile;
import haxe.macro.Expr.Case;
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
class RoleJS {
    static var mainApp:RoleApp = null;
    public static function load(url:String) {
        if(mainApp == null) {
            mainApp = new RoleApp();
            mainApp.setUrl(url);


        }else{
            mainApp.setinit(url);
        }
        
    }


    static function main() {
        var a = new RoleApp();
        a.setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa.json');
    }
}


class RoleApp extends hxd.App {
    
   
    var url:String;
    var assets:Assets = new Assets();
   
    private static var _sceneMap:Map<String, UIWindow> = [];
    var scene1:TestUI = null;
    var arrTile:Map<String,Array<String>> = new Map<String,Array<String>>();
    

   


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

    public function setinit(url:String){

        if(s3d == null) {
            return;
        }

        this.url = url;

        assets.loadFile(StringTools.replace(this.url, "\\", "/"));

        // assets.loadFile("res/role/image0.png");
		//  assets.loadFile("res/role/image1.png");
		//  assets.loadFile("res/role/image2.png");
		//  assets.loadFile("res/role/image3.png");
		//  assets.loadFile("res/role/image4.png");
		//  assets.loadFile("res/role/image5.png");
        //  assets.loadFile("res/role/dandan.png");
        assets.loadFile("res/role/dandan.png");
        assets.start(function(f) {
            if (f == 1) {
                trace('loading over');

                var aa= haxe.Json.stringify(assets.getJson(getName()));

                

                var jsonObject = Json.parse(aa);

                arrTile.clear();

               

                var images:Array<Dynamic> = jsonObject.animation.images;
                for (image in images) {
                    trace(image.type); // 输出 "images"
                    var images:Array<Dynamic> = image.data;

                    var arrImage:Array<String> = new Array<String>();

                    for (image in images) {
                        trace(image); // 输出 "images"
                        assets.loadFile(image);
                        trace(getName1(image));
                        arrImage.push(getName1(image));

                    }
                    trace(image.name);
                    arrTile.set(image.name, arrImage);
                }
                
                PlayAnimation("攻击");
                
                var t0:Tile = assets.getBitmapDataTile("dandan");
                var hh: Array<Tile>= t0.gridFlatten(420,3,2);
                var t1:Tile = t0.sub(0,0,391,428,200,200);
                var t2:Tile = t0.sub(391,0,391,428,200,200);
                var t3:Tile = t0.sub(782,0,391,428,200,200);
                var t4:Tile = t0.sub(0,428,391,428,200,200);
                var t5:Tile = t0.sub(391,428,391,428,200,200);
                var t6:Tile = t0.sub(782,428,391,428,200,200);
                trace(hh);
                //var anim = new h2d.Anim([t1,t2,t3,t4,t5,t6],s2d); 


                // var atlas:Pixels = null;
		        // var brush = new Pixels(0, 0, null, RGBA);


                // var t2 = assets.getBitmapDataTile("image1");
                // var t3 = assets.getBitmapDataTile("image2");
                // var t4 = assets.getBitmapDataTile("image3");
                // var t5 = assets.getBitmapDataTile("image4");
                // var t6 = assets.getBitmapDataTile("image5");
               
                // var jsonObject:StringArray  = Json.parse(aa);
                
                // for (k in jsonObject) {
                //     trace(k);
                // }
                
                //trace(jsonObject);
                //var anim = new h2d.Anim([t1,t2,t3,t4,t5,t6],s2d); 
                //anim.x = 300;
                
                
                
            }
        });

        // if(assets.hasTypeAssets(JSON,getName())){
        //     trace('hasTypeAssets');
        //     //getFbx();
            
        // }else{
        
            
        // }

    }

    public function PlayAnimation(name:String){
        assets.start(function(f) {
            if (f == 1) {
                // for (k in arrTile.keys()) {
                //     trace(k);
                    
                // }
                var arr:Array<String> = arrTile.get("攻击");
                if(arr == null){
                }else{
                    var arrTile1:Array<h2d.Tile> = new Array<h2d.Tile>();
                    for (i in arr) {
                        trace(i);
                        arrTile1.push(assets.getBitmapDataTile(i));
                    }
                    var anim = new h2d.Anim(arrTile1,s2d); 
                    anim.x = 300;

                }
                
            }
        });
    

    }

    public function setUrl(url:String){
        this.url = url;
    }

    


    override function init() {
        super.init();





       
        hxd.res.Loader.currentInstance = new Loader(new FileSystem());
        AssetsBuilder.bindAssets(assets);

        //setinit(this.url);
        

        scene1 = createScene(TestUI);
        s2d.addChild(scene1);
        
      

    }
    static function main() {
        #if mac_run
        new MainJS('res/img/model.fbx');
        #else
       //var a = new RoleApp();
       //a.setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa.json');
        
        #end
    }
}
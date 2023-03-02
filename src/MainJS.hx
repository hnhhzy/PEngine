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
class MainJS extends hxd.App {
    
    var cache : h3d.prim.ModelCache;
    var url:String;

    function new(url:String) {
        super();
        this.url = url;
    }


    override function update(dt : Float) {
        // trace("update");
        #if hl
        hxPEngine.ui.util.hl.Thread.loop( );
        #end
     }

    override function init() {
        super.init();

        #if hl
        trace("=========loading path====================");
        trace(this.url);
        trace("=========start to convert fbx====================");
        var e;
        var resourceDir = "I:\\Myproject\\HeapsPlus\\PEngine\\res";

        hxd.Res.initLocal();

        // 转换为HMD
        var c = new ConvertFBX2HMD();
        c.originalFilename = "model.fbx";
        c.srcPath = this.url;
        c.srcBytes = sys.io.File.getBytes(this.url);
        c.dstPath = StringTools.replace(this.url.toLowerCase(), ".fbx", ".hmd");
        c.convert();
        trace("FBX2HDM:", c.dstPath);
        #end
        //hxd.Res.initEmbed();
        hxd.res.Loader.currentInstance = new Loader(new FileSystem());

        //
        //hxd.res.Loader.currentInstance = new CustomLoader(new hxd.fs.LocalFileSystem(localDir,fsconf));
		//hxd.res.Image.ASYNC_LOADER = new hxd.impl.AsyncLoader.NodeLoader();
        //hxd.res.Loader.currentInstance.load("I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\model.fbx");


        var assets = new Assets(); 
        AssetsBuilder.bindAssets(assets);
        //assets.loadFile("res/img/skeleton01.png");
        //assets.loadFile("res/img/sword01.png");
        //assets.loadFile("res/img/model.hmd");
        assets.loadFile(StringTools.replace(this.url, "\\", "/"));
        assets.start(function(f) {
            if (f == 1) {
                trace('loading over');
                /*
                var hmd = assets.getHMDLibrary("Model");
                //for(var i in hmd.header.materials) {
                var path = StringTools.replace(this.url, "\\", "/");
                var fileName = StringUtils.getName(path);
                var fileExt = StringUtils.getExtType(path);
                path = StringTools.replace(path, fileName + "." + fileExt, "");
                for (pass in hmd.header.materials) {
                    assets.loadFile(path + "/" + StringTools.replace(pass.diffuseTexture, "\\", "/"));
                }
                assets.start(function(k) {
                    if (k == 1) {
                       

                    }
                });
                */

                var path = StringTools.replace(this.url, "\\", "/");
                var fileName = StringUtils.getName(path);
                cache = new h3d.prim.ModelCache();
                  
                var obj = assets.loadFbxModel(fileName);
                
                //var obj = cache.loadModel(hxd.Res.img.Model);
                obj.scale(0.1);
                s3d.addChild(obj);
                s3d.camera.pos.set( -3, -5, 3);
                s3d.camera.target.z += 1;
                obj.playAnimation(assets.getHMDAnimation(fileName));
                //obj.playAnimation(cache.loadAnimation(hxd.Res.img.model));
        
        
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
                
                
            }
        });


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
        new MainJS('E:\\MarkProject\\HeapsPlus\\heapsProject\\art_resource\\model\\monster\\goblin\\Model.FBX');
    }
}
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
class MainUI extends hxd.App {
    
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


        var assets = new Assets(); 
        AssetsBuilder.bindAssets(assets);
     

        assets.loadFile(StringTools.replace(this.url, "\\", "/"));
        assets.start(function(f) {
            if (f == 1) {
                 trace('loading over');
           
            }
        });



    }
    static function main() {
        #if mac_run
        new MainJS('res/img/model.fbx');
        #else
        new MainUI('I:\\Myproject\\HeapsPlus\\PEngine\\res\\ui\\Basics.fui');
        
        #end
    }
}
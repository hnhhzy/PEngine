import h3d.scene.fwd.DirLight;
import hxPEngine.ui.util.hl.Thread;
import hxPEngine.ui.UIWindow;
import hxPEngine.ui.util.SceneManager;
import h2d.col.Point;
import hxd.Event;
import hxPEngine.ui.display.Button;

import hxPEngine.ui.display.Image;

import hxPEngine.ui.util.Assets;
class Main extends hxd.App {

    private var gx:Float = 0;

	private var gy:Float = 0;

    private static var _sceneMap:Map<String, UIWindow> = [];

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
        Thread.loop( );
       #end



    }

    var cache : h3d.prim.ModelCache;

    // 加强库
    // https://github.com/Yanrishatum/heeps#manifest-fs
    override function init() {
        super.init();

        
        hxd.Res.initEmbed();
        //hxd.Res.initLocal();
        var scene1 = createScene(TestUI);
        s2d.addChild(scene1);


        /*
        var scene1 = createScene(TestUI);
        var cache = new h3d.prim.ModelCache();
        cache.loadLibrary(hxd.Res.img.Anime_character);
        // Create a model instance. Compared to manual model creation, ModelCache loads textures automatically.
        var obj = cache.loadModel(hxd.Res.img.Anime_character);
        // Load an animation.
        //var anim = cache.loadAnimation(hxd.Res.img.Anime_character);
        // play it on the object
        //obj.playAnimation(anim);

        s3d.addChild(obj);

        // Clear the cache instance. Note that cache will dispose all cached model textures as well.
       // cache.dispose();
*/

        

        //s2d.addChild(scene1);

        // var a = new Assets();
        // a.loadFile("res/img/btn_LvSe.png");
        // a.loadFile("res/img/images.png");
        // a.start(function(f) {
        //     if (f == 1) {
        //         //var g:Button = Button.create("btn_LvSe", null, scene1);

        //         var g = new Image(a.getBitmapDataTile("images"), scene1);
        //         //g.text = "哈哈哈";
        
        //         var isDown = false;
        //         var pos:Point = new Point();
        //         var beginpos:Point = new Point();

                
                
                
        
        //         s2d.startCapture((e:Event) -> {
        //             // mx = e.relX;
        //             // my = e.relY;
        //             switch e.kind {
        //                 case EPush:
        //                     g.alpha = 0.7;
        //                     var localPos = s2d.globalToLocal(new Point(e.relX, e.relY));
        //                     pos.x = localPos.x;
        //                     pos.y = localPos.y;
        //                     beginpos.x = g.x;
        //                     beginpos.y = g.y;
        //                     isDown = true;
        //                 case ERelease:
        //                     g.alpha = 1;
        //                     isDown = false;
        //                 case EMove:
        //                     if (isDown) {
        //                         var localPos = s2d.globalToLocal(new Point(e.relX, e.relY));
        //                         gx = beginpos.x - (pos.x - localPos.x);
        //                         gy = beginpos.y - (pos.y - localPos.y);
        //                         g.x = gx;
        //                         g.y = gy;
        //                     }
        //                 case EOver:
        //                 case EOut:
        //                 case EWheel:
        //                 case EFocus:
        //                 case EFocusLost:
        //                 case EKeyDown:
        //                 case EKeyUp:
        //                 case EReleaseOutside:
        //                 case ETextInput:
        //                 case ECheck:
        //             }
        //         });
        //         s2d.addChild(g);
        
                
        //     }
        // });



       
        

       // SceneManager.replaceScene(TestUI);

        


        // var myimage = hxd.Res.img.btn_LvSe;

        // trace(myimage.getSize);
        
        // var mytile = myimage.toTile();
        // var mybitmap = new h2d.Bitmap(mytile);
        // mybitmap.x = 0;
        // mybitmap.y = 0;
        // mybitmap.width = 200;
        // mybitmap.height = 100;
        // s2d.addChild(mybitmap);



        


        //Create a custom graphics object by passing a 2d scene reference.
        // var customGraphics = new h2d.Graphics(s2d);

        // //specify a color we want to draw with
        // customGraphics.beginFill(0xEA8220);
        // //Draw a rectangle at 10,10 that is 300 pixels wide and 200 pixels tall
        // customGraphics.drawRect(10, 10, 300, 200);
        // //End our fill
        // customGraphics.endFill();





       // var view = new SampleView(h2d.Tile.fromColor(0xFF,32,32),s2d);
       // view.mybmp.alpha = 0.8;

        /*
        var myimage = hxd.Res.img.test;
        var mytile = myimage.toTile();
        var mybitmap:h2d.Bitmap = new h2d.Bitmap(mytile);
        mybitmap.x = 10;
        mybitmap.y = 10;
        s2d.addChild(mybitmap);
        */

    }
    static function main() {
        new Main();
    }
}
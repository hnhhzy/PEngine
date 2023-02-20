import hxPEngine.ui.util.hl.Thread;
import hxPEngine.ui.UIWindow;
import hxPEngine.ui.util.SceneManager;
class Main extends hxd.App {


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

    override function init() {
        super.init();

        
        //hxd.Res.initEmbed();
        hxd.Res.initLocal();

        var scene1 = createScene(TestUI);
        s2d.addChild(scene1);

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
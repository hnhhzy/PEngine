import hxd.res.Loader;
import hxd.fmt.pak.FileSystem;
import MyProject;

class Map2d extends hxd.App {
    override function init() {
        super.init();
        //var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
       // tf.text = "Hello Hashlink !";
        // var assets = new Assets();
		
		// AssetsBuilder.bindAssets(assets);

        //hxd.res.Loader.currentInstance = new Loader(new FileSystem());
        hxd.Res.initEmbed();

        s2d.setScale( dn.heaps.Scaler.bestFit_i(528,528) ); // scale view to fit
        //RoleJS.load('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa4.rule');

        // Read project JSON
        var project = new MyProject();
        trace(project);


        var level = project.all_worlds.Default.all_levels.West;

		// Prepare a container for the level layers
		var levelBg = new h2d.Object();
		s2d.addChild(levelBg);
        engine.backgroundColor = level.bgColor_int;
       
		//levelBg.alpha = 0.5; // opacity
		//levelBg.filter = new h2d.filter.Blur(4,1,2);  // blur it a little bit

		// Render IntGrid layer named "Collisions"
        levelBg.addChild( level.getBgBitmap() );
        levelBg.addChild( level.l_Cavern_background.render());
		levelBg.addChild( level.l_Collisions.render() );
        // 判断某个坐标是否在level.l_Collisions中
        //level.l_Collisions.isCoordValid(0,0);
        //trace(level.l_Collisions.isCoordInTile(0,0));
        
		// Render tiles layer named "Custom_tiles"
		levelBg.addChild( level.l_Custom_tiles.render() );


        //levelBg.addChild( level.l_Entities.render() );

		// Render each "Item" entity
		for( item in level.l_Entities.all_Item ) {
			// Read h2d.Tile based on the "type" enum value from the entity
            trace(item.f_type);
           // item.getTile();
			//var tile = project.getEnumTile( item.f_type );
           // trace(tile);

			// Apply the same pivot coord as the Entity to the Tile
			// (in this case, the pivot is the bottom-center point of the tile)
			//tile.setCenterRatio( item.pivotX, item.pivotY );

			// Display it
			var bitmap = new h2d.Bitmap(item.getTile());
            bitmap.width = item.width;
            bitmap.height = item.height;
            bitmap.x = item.pivotX;
            bitmap.y = item.pivotY;
			s2d.addChild(bitmap);
			bitmap.x = item.pixelX;
			bitmap.y = item.pixelY;
		}

















        //trace(project.all_worlds);
        //project.loadFromFile("assets/ldtk/level.ldtk");
        // Render each level
        
        // for( level in project.levels ) {
        //     // Create a wrapper to render all layers in it
        //     var levelWrapper = new h2d.Object( s2d );
        //     trace(level);

        //     // Position accordingly to world pixel coords
        //     levelWrapper.x = level.worldX;
        //     levelWrapper.y = level.worldY;

        //     trace(levelWrapper.x);

        //     trace(levelWrapper.y);
        //     //trace(level.getBgBitmap()  );
        //    // trace(level.l_Custom_tiles.render()  );
            


        //     // Level background image
        //     if( level.hasBgImage() )
        //         levelWrapper.addChild( level.getBgBitmap() );
            

        //     //Render background layer
        //     levelWrapper.addChild( level.l_Cavern_background.render() );

        //     // Render collision layer tiles
        //     levelWrapper.addChild( level.l_Collisions.render() );

        //     // Render custom tiles layer
        //     //levelWrapper.addChild( level.l_Custom_tiles.render() );


            
        // }


      
    }
    static function main() {

        new Map2d();
    }
}
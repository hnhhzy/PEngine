import hxd.res.Loader;
import hxd.fmt.pak.FileSystem;
//import MyProject;

class Map2d1 extends hxd.App {
    override function init() {
        super.init();
        //var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
       // tf.text = "Hello Hashlink !";
        // var assets = new Assets();
		
		// AssetsBuilder.bindAssets(assets);

        // Init general heaps stuff
		hxd.Res.initEmbed();
		//s2d.setScale( dn.heaps.Scaler.bestFit_i(650,256) ); // scale view to fit

		// Read project JSON
		var project = new LdtkProject();

		var level1 = project.all_levels.Level_0;
		
		

		trace(level1.hasBgImage());
		trace(level1.identifier);
		trace(level1.iid);
		trace(level1.bgColor_hex);
		
		//var levelWrapper = new h2d.Object( s2d );
		engine.backgroundColor = level1.bgColor_int;
		//s2d.x = level1.worldX;
		//s2d.y = level1.worldY;
		
		if( level1.hasBgImage() ){
			s2d.addChild( level1.getBgBitmap() );
			s2d.addChild( level1.l_Floor.render() );
			//s2d.addChild( level1.l_Entities.render() );
			
			//s2d.addChild( level1.l_Backgound2.render() );
			//s2d.addChild( level1.l_Background.render() );
				//levelWrapper.addChild( level.l_Entities.render() );


		 }

		

		// var level = project.all_worlds.Default.all_levels.Level_0;
		
		// //trace(project.all_worlds.Default.all_levels.Level_1);
		// //trace(project.all_worlds.Default.all_levels.Level_2);

		// for( level in project.all_worlds.Default.levels ) {
		// 	// Create a wrapper to render all layers in it
		// 	var levelWrapper = new h2d.Object( s2d );

		// 	// Position accordingly to world pixel coords
		// 	levelWrapper.x = level.worldX;
		// 	levelWrapper.y = level.worldY;


		// 	trace(level);
		// 	//Level background image
		// 	trace(level.hasBgImage());
		// 	if( level.hasBgImage() )
		// 		levelWrapper.addChild( level.getBgBitmap() );
		// 		levelWrapper.addChild( level.l_Floor.render() );
		// 		//levelWrapper.addChild( level.l_Entities.render() );


		//  }


		// var levelWrapper = new h2d.Object( s2d );
		// levelWrapper.x = level.worldX;
		// levelWrapper.y = level.worldY;

		// trace(level.hasBgImage());
		// if( level.hasBgImage() ){
		// 	// Level background image
		// 	levelWrapper.addChild( level.getBgBitmap() );

		// 	// Render "pure" auto-layer (ie. background walls)
		// 	levelWrapper.addChild( level.l_Floor.render() );
		// 	//s2d.addChild( level.l_Backgound2.render() );
		// 	//s2d.addChild( level.l_Background.render() );
		// 	//s2d.addChild( level.l_Entities.render() );
		// 	// Render IntGrid Auto-layer tiles (ie. walls, ladders, etc.)
		// 	//s2d.addChild( level.l_Collisions.render() );

		// 	// Render traditional Tiles layer (ie. manually added details)
		// 	//s2d.addChild( level.l_Custom_tiles.render() );
		// }
		
		
		

		
		
		// for( level in project.all_worlds.Default.levels ) {
		// 	// Create a wrapper to render all layers in it
		// 	var levelWrapper = new h2d.Object( s2d );

		// 	// Position accordingly to world pixel coords
		// 	levelWrapper.x = level.worldX;
		// 	levelWrapper.y = level.worldY;


		// 	trace(level);
		// 	//Level background image
		// 	if( level.hasBgImage() )
		// 		levelWrapper.addChild( level.getBgBitmap() );

		// 	//Render background layer
		// 	levelWrapper.addChild( level.l_Cavern_background.render() );

		// 	//Render collision layer tiles
		// 	levelWrapper.addChild( level.l_Collisions.render() );

		// 	// Render custom tiles layer
		// 	levelWrapper.addChild( level.l_Custom_tiles.render() );

		//  }

		    // s2d.setScale( dn.heaps.Scaler.bestFit_i(256,256) );
			// var layer = project.all_worlds.Default.all_levels.West.l_Collisions;
			// var g = new h2d.Graphics(s2d);

			// // Render background
			// g.beginFill(project.bgColor_int);
			// g.drawRect(0, 0, layer.cWid*layer.gridSize, layer.cHei*layer.gridSize);
			// g.endFill();

			// // Render IntGrid layer cells
			// for(cx in 0...layer.cWid)
			// for(cy in 0...layer.cHei) {
			// 	if( !layer.hasValue(cx,cy) ) // skip empty cells
			// 		continue;

			// 	var color = layer.getColorInt(cx,cy);
			// 	g.beginFill(color);
			// 	g.drawRect(cx*layer.gridSize, cy*layer.gridSize, layer.gridSize, layer.gridSize);
			// }



			// for( level in project.all_worlds.Default.levels ) {
			// 	// Create a wrapper to render all layers in it
			// 	var levelWrapper = new h2d.Object( s2d );
	
			// 	// Position accordingly to world pixel coords
			// 	levelWrapper.x = level.worldX;
			// 	levelWrapper.y = level.worldY;
	
			// 	// Level background image
			// 	if( level.hasBgImage() )
			// 		levelWrapper.addChild( level.getBgBitmap() );
	
			// 	Render background layer
			// 	levelWrapper.addChild( level.l_Cavern_background.render() );
	
			// 	// Render collision layer tiles
			// 	levelWrapper.addChild( level.l_Collisions.render() );
	
			// 	// Render custom tiles layer
			// 	levelWrapper.addChild( level.l_Custom_tiles.render() );
			// }

		// 	var level = project.all_worlds.Default.all_levels.West;

		// // Prepare a container for the level layers
		// var levelBg = new h2d.Object();
		// s2d.addChild(levelBg);
		// levelBg.alpha = 0.5; // opacity
		// levelBg.filter = new h2d.filter.Blur(4,1,2);  // blur it a little bit

		// // Render IntGrid layer named "Collisions"
		// levelBg.addChild( level.l_Collisions.render() );

		// // Render tiles layer named "Custom_tiles"
		// levelBg.addChild( level.l_Custom_tiles.render() );


		// // Render each "Item" entity
		// for( item in level.l_Entities.all_Item ) {
		// 	// Read h2d.Tile based on the "type" enum value from the entity
		// 	var tile = project.getEnumTile( item.f_type );

		// 	// Apply the same pivot coord as the Entity to the Tile
		// 	// (in this case, the pivot is the bottom-center point of the tile)
		// 	tile.setCenterRatio( item.pivotX, item.pivotY );

		// 	// Display it
		// 	var bitmap = new h2d.Bitmap(tile);
		// 	s2d.addChild(bitmap);
		// 	bitmap.x = item.pixelX;
		// 	bitmap.y = item.pixelY;
		// }

		// var level = project.all_worlds.Default.all_levels.West;

		// // Level background image
		// s2d.addChild( level.getBgBitmap() );

		// // Render "pure" auto-layer (ie. background walls)
		// s2d.addChild( level.l_Cavern_background.render() );

		// // Render IntGrid Auto-layer tiles (ie. walls, ladders, etc.)
		// s2d.addChild( level.l_Collisions.render() );

		// // Render traditional Tiles layer (ie. manually added details)
		// s2d.addChild( level.l_Custom_tiles.render() );

      
    }
    static function main() {

        new Map2d1();
    }
}
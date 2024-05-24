package levels;

//import object.SpineEntity;
import object.RoleEntity1;
import h2d.Bitmap;

class SnowLevel {
    private var _root:h2d.Object;
    
    //var player:object.SpineEntity;

    var player:object.RoleEntity;

    //var player1:object.SpineEntity;
    //var l_Collisions:levels.Levels.Layer_Collisions;
    var _camera:h2d.Camera;

    

    var l_Obstacle:levels.Levels.Layer_Obstacle;
    public function new(?parent:h2d.Scene) {
        _root = new h2d.Object();        
        _camera = parent.camera;
        //RoleJS.load('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa4.rule');

       // var mainApp = new RoleApp();
        //mainApp.setUrl("I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa4.rule");


        var b:Bitmap = new Bitmap();
        
        _root.setScale( dn.heaps.Scaler.bestFit_i(1600,960) ); // scale view to fit

        var p = new Levels();
        var level = p.all_worlds.Default.all_levels.Level_0;
        if( level.hasBgImage() ) {
            var background = level.getBgBitmap();
            _root.addChild( background );
        }
        l_Obstacle =  level.l_Obstacle;
        var l_Road =  level.l_Road;
        var l_Entities =  level.l_Entities;
        _root.addChild(l_Road.render());
        
        _root.addChild(l_Obstacle.render());

        




        var layer = l_Obstacle;
		for( cy in 0...layer.cHei ) {
			var row = "";
			for( cx in 0...layer.cWid )
				if( layer.hasAnyTileAt(cx,cy) )
					row+="#";
				else
					row+=".";
			trace(row+"  "+cy);
		}


        for( _player in l_Entities.all_PlaceBirth ) {
            //trace(_player.f_life);
            //trace(_player.f_ammo);
            //player = new h2d.Bitmap();
            //player = new object.SpineEntity("res//role//spine5.spines", "tiao", "1", _root);

            player = new object.RoleEntity("res//role//aa666.rule", "tiao", "3", _root);

            

            player.x = _player.pixelX;
			player.y = _player.pixelY;

            _camera.follow = player;
            _camera.anchorX = 0.5;
            _camera.anchorY = 0.5;
            _root.addChild(player);
            
        }

        for( _player in l_Entities.all_Props ) {
           // trace(_player.getTile());
            //trace(_player.f_ammo);
            var player1 = new h2d.Bitmap();
            //var player1 = new object.RoleEntity("res/test/jiaose1.rule", "tiao", "1", null);
           // var player1 = new object.SpineEntity("res/role/spine5.spines", "tiao", "1", _root);



            player1.x = _player.pixelX;
			player1.y = _player.pixelY;

            
            _root.addChild(player1);
            
        }
        

        parent.addChild(_root);

    }

    public function update(dt : Float) {
        // 检查键盘输入并更新相机位置
        if (hxd.Key.isDown(hxd.Key.W)) {
            if(l_Obstacle.hasAnyTileAt(Std.int(player.x/32),Std.int((player.y-1)/32))) {
                return;
            }
            player.y = player.y - 1;
        }
        if (hxd.Key.isDown(hxd.Key.S)) {
            if(l_Obstacle.hasAnyTileAt(Std.int(player.x/32),Std.int((player.y+1)/32))) {
                return;
            }
            player.y = player.y + 1;
        }
        if (hxd.Key.isDown(hxd.Key.A)) {
            if(l_Obstacle.hasAnyTileAt(Std.int((player.x-1)/32),Std.int((player.y)/32))) {
                return;
            }
            player.x = player.x - 1;
        }
        if (hxd.Key.isDown(hxd.Key.D)) {
            if(l_Obstacle.hasAnyTileAt(Std.int((player.x+1)/32),Std.int((player.y)/32))) {
                return;
            }
            player.x = player.x + 1;
        }

        if (hxd.Key.isPressed(hxd.Key.MOUSE_WHEEL_DOWN)) {
            _camera.scaleX = _camera.scaleX - 0.1;
            _camera.scaleY = _camera.scaleY - 0.1;
        }

        if (hxd.Key.isPressed(hxd.Key.MOUSE_WHEEL_UP)) {        
            _camera.scaleX = _camera.scaleX + 0.1;
            _camera.scaleY = _camera.scaleY + 0.1;
        }

       //parent.camera.scaleX = 3.0; // 设置初始缩放级别
       //parent.camera.scaleY = 3.0; // 设置初始缩放级别


     }

}
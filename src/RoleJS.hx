
import h2d.filter.AbstractMask;
import h2d.Mask;
import dn.heaps.slib.AnimManager;
import hxPEngine.ui.util.entity.AnimBase;
import h2d.col.Matrix;
import h2d.Bitmap;
import hxPEngine.ui.display.Image;
import hxd.System;
import hxd.Window;
import h2d.Graphics;
import hxPEngine.ui.util.entity.Property;
import hxPEngine.ui.util.entity.DataImage;
import format.agal.Data.C;
import hxPEngine.ui.loader.parser.AssetsType;
import format.amf3.Reader.Traits;
import hxPEngine.ui.util.entity.MapImage;
import hxPEngine.ui.util.entity.Keyboard;
import hxPEngine.ui.util.entity.RolejsTile;
import hxPEngine.controller.KeyboardControl;
import hxd.Key;
import h2d.Anim;
import hxPEngine.ui.util.entity.Segmentation;
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
import js.Browser;
import js.html.CanvasRenderingContext2D;



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
    public static function load(url:String,?param:String = "default",?param1:String = "default") {
        if(mainApp == null) {
            mainApp = new RoleApp();
            mainApp.setUrl(url,param,param1);
            //trace("加载");


        }else{
            //mainApp = new RoleApp();
            mainApp.setinit(url,param,param1);
            //trace("重载");
        }
        
    }
    public static function GraphicsCanvas(type:Int,x:Float,y:Float,width:Float,height:Float){
        mainApp.GraphicsCanvas(type,x,y,width,height);
    }
    public static function GraphicsMask(type:Int,x:Float,y:Float,width:Float,height:Float){
        mainApp.GraphicsMask(type,x,y,width,height);
    }

    public static function PlayAnimation(name:String,direction:String,atFrame:Float = 0){
        mainApp.PlayAnimation(name,direction,atFrame);
    
    }
    public static function PlayName(name:String):String{
        return mainApp.PlayAnimationName(name);
    
    }
    public static function PlayDirection(direction:String):String{
        return mainApp.PlayAnimationDirection(direction);
    
    }
    public static function bind(key:Int,name:String,direction:Int){
        mainApp.bind(key,name,direction);
        
    

    }
    public static function bindArr(arr:Array<Int>,name:String,direction:String){
        
       mainApp.bindArr(arr,name,direction);
    

    }
    public static function bindArrClick(arr:Array<Int>,name:String,direction:String){
        
        mainApp.bindArrClick(arr,name,direction);
     
 
    }

    public static function scale(x:Float,y:Float){
        mainApp.scale(x,y);
    }
    //添加图片 测试模式
    public static function setImg(imgName:String){
        mainApp.setImg(imgName);
    }
    public static function restores(){
        mainApp.restores();
    }

    //添加roleEntity
    public static function setRoleEntity(url:String,?param:String = "default",?param1:String = "default"){
        mainApp.setRoleEntity(url,param,param1);
    }

    public static function restoresRole(){
        mainApp.restoresRole();
    }
    //添加SpineEntity
    public static function setSpineEntity(url:String,?param:String = "default",?param1:String = "default"){
        mainApp.setSpineEntity(url,param,param1);
    }

    public static function Loop() {

        mainApp.Loop();
        
    }
    public static function unloadAll(){
        mainApp.unloadAll();
    }

    public static function Callback():Int{
        return mainApp.Callback();
    }

    
    


    static function main() {
        //var a = new RoleApp();
        #if hl
        RoleJS.load('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa444.rule');
        #end
       // a.setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa4.rule');



        // keyboard = new KeyboardControl();
        // mapbind.set(Key.W,this,"pao1");
        // mapbind.set(Key.D,a,"pao3");

    }
}


class RoleApp extends hxd.App {
    
   
    var url:String;
    var path:String;
    var assets:Assets = new Assets();
    var anim:AnimBase = null;
    
   
    private static var _sceneMap:Map<String, UIWindow> = [];
    var scene1:TestUI = null;
    var arrTile:Map<String,Array<String>> = new Map<String,Array<String>>();
    //名称，方向，动画 图片
    var arrTile1:Map<String,RolejsTile> = new Map<String,RolejsTile>();
    var arrTile2:Map<String,Map<String,RolejsTile>> = new Map<String,Map<String,RolejsTile>>();
    var arrSegmentation:Map<String,Array<Segmentation>> = new Map<String,Array<Segmentation>>();

    var mapImage:Map<String,Array<MapImage>> = new Map<String,Array<MapImage>>();

    //默认动画
    var defaultAnimation:RolejsTile = new RolejsTile();

    //默认动画
    var defaultAnimationMap:Map<String,RolejsTile> = new Map<String,RolejsTile>();


    //Role 实体
    var player:object.RoleEntity;

    //spine实体
    var spinePlayer:object.SpineEntity;


    //加载成功失败 0未加载 1成功
    var callback:Int = 0;


    var defauldirction:Int = 0;


    var PlayName:String = "";
    var PlayDirction:String = "";

    var param:String;
    var param1:String;


    var scaleX:Float = 1;
    var scaleY:Float = 1;


    var _vbox:h2d.Object;
    

    var grcollision:Graphics; //碰撞


    var grmask:Graphics; //遮罩



    var postionLine:h2d.Graphics;
    var  currentwindow:Window;
   

    override function onResize() {
        #if hl
        var stage = hxd.Window.getInstance();
        trace('Resized to ${stage.width}px * ${stage.height}px');

        // s2d.scaleX = stage.width / 1366;
        // s2d.scaleY = stage.height / 768;


        if(postionLine != null){
            s2d.removeChild(postionLine);
        }
        postionLine = new h2d.Graphics(s2d);
        postionLine.beginFill(0xFF0000, 0.5);

        postionLine.drawRect(0, stage.height/2,stage.width,1);
        postionLine.drawRect(stage.width/2, 0, 1, stage.height);

        postionLine.endFill();


        //_vbox = new h2d.Object(s2d);

        _vbox.x = stage.width/2;
        _vbox.y = stage.height/2;


        #end
        #if js

                


        var canvas = Browser.document.getElementById("rolejs");
                // 获取canvas的宽度和高度

        //var windowWidth1: Int = Browser.window.innerWidth;
        //var windowHeight1: Int = Browser.window.innerHeight;

        //trace('Resized to ${windowWidth1}px * ${windowHeight1}px');



        // if(postionLine != null){
        //     s2d.removeChild(postionLine);
        // }
        // postionLine = new h2d.Graphics(s2d);

        postionLine.clear();
        postionLine.beginFill(0xFF0000, 0.5);

        postionLine.drawRect(0, canvas.clientHeight/2,canvas.clientWidth,1);
        postionLine.drawRect(canvas.clientWidth/2, 0, 1, canvas.clientHeight);

        postionLine.endFill();


        //_vbox = new h2d.Object(s2d);

        _vbox.x = canvas.clientWidth/2;
        _vbox.y = canvas.clientHeight/2;
        


        #end
      




       

        
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

        //updates(dt);

        updateplayer(dt);

        updateSpine(dt);

        // var ff = keyboard.getPressDown();
        // //trace("按下"+ff);
        // var keyboardmap:Map<Int,Int> = keyboard.getMap();
        // trace(keyboardmap);

       
        

        // for (key in mapbind.keys()) {
        //     for (ss in keyboardmap.keys()){
        //         if(key == ss && keyboardmap.get(ss) == 1){
        //             PlayAnimation1(mapbind.get(key));
        //         }
               

        //     }
            
        // }
        //var arr:Array<Int> = keyboard.getArray();
       // trace(arr);
        //getUpdate();
        //getArr();
        
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

    var mapbind:Map<Int,String> = new Map<Int,String>();

    var arrbind:Array<Keyboard> = new Array<Keyboard>();

    public function bind(key:Int,name:String,direction:Int){
        mapbind.set(key,name+direction);

        var sss:Array<Int> = new Array<Int>();
        //sss.sort().join("+");
        
    

    }

    // 一组图按下触发
    public function bindArr(arr:Array<Int>,name:String,direction:String){
        keyboard.setKeyBind(arr, function(): Void {
            combo1Action(name+direction);
        });
        //keyboard.setKeyBind([Key.S, Key.D], combo2Action);

        
        //keyboard.setKeyBindClick([Key.J], combo3Action);
        
    

    }
    private function combo1Action(param: String):Void {
        // 执行按键组合1对应的操作
        //trace("222");
        //trace(param +"param");

        var ss = arrTile1.get(param);
        if(ss == null){
            //trace("ss == null");
            return;
        }
        // anim = null;
        // anim = new h2d.Anim(ss,s2d);
        // //anim.x = 200;

        //trace("调用" );
        //trace("调用" );


        defauldirction = Std.parseInt(ss.direction);

       // trace("action:" + ss);
        //trace("anim.loop3:" + defauldirction);
        anim.play(ss.data, 1);
        anim.degreesList = ss.rotate;
        //anim.x = 200;
        anim.speed = ss.rate;
        anim.loop = true;
        setOverturn();
        //anim.scaleX = scaleX;
        //anim.scaleY = scaleY;

        setRoleJSTile(ss);
        
        //trace("调用2222:" +anim.loop);

        // if(anim == null){
        //     anim = new h2d.Anim(null,_vbox);
        //     anim.play(ss.data, 1);
        //     //anim.x = 200;
        //     anim.speed = ss.rate;
        //     anim.loop = true;
        //     trace("调用1111:" +anim.loop );
            
        // }else{
        //     //trace("aaaa");
            
        // }


    }
    
    // 一套图按下触发
    public function bindArr1(arr:Array<Int>,name:String){
        // var key:Keyboard = new Keyboard();
        // key.name = name;
        // key.direction = direction;
        // key.data = arr;

        // arrbind.push(key);

       // mapbind.set(key,name+direction);
        //sss.sort().join("+");

       // keyboard.setKeyBind(arr, combo1Action("左上"));
       //trace("bindArr1");
        keyboard.setKeyBind(arr, function(): Void {
            combo1Action1(name);
        });
        //keyboard.setKeyBind([Key.S, Key.D], combo2Action);

        
        //keyboard.setKeyBindClick([Key.J], combo3Action);
        
    

    }
    // 一组图按下触发
    private function combo1Action1(param: String):Void {
        // 执行按键组合1对应的操作
        //trace("111");
        //trace(param +"param");

        //PlayAction(param);
        var ss = arrTile2.get(param).get(defauldirction+"");
        if(ss == null){
            //trace("ss == null");
            return;
        }
        // anim = null;
        // anim = new h2d.Anim(ss,s2d);
        // //anim.x = 200;

        //trace("调用" );
        //trace("调用" );


        defauldirction = Std.parseInt(ss.direction);

        //trace("action:" + ss);
        //trace("anim.loop3:" + defauldirction);
        anim.play(ss.data, 0);
        anim.degreesList = ss.rotate;
        //anim.x = 200;
        anim.speed = ss.rate;
        anim.loop = true;
        setOverturn();
        //anim.scaleX = scaleX;
        //anim.scaleY = scaleY;
        //trace("调用2222:" +anim.loop);
        setRoleJSTile(ss);

    }

    //一组图松开触发
    public function bindArrClick(arr:Array<Int>,name:String,direction:String){
 
        keyboard.setKeyBindClick(arr, function(): Void {
            PlayActionClick(name+direction);
        });
    

    }

    public function PlayActionClick(name:String){
        var ss = arrTile1.get(name);
        if(ss == null){
            //trace("ss == null");
            return;
        }
        // anim = null;
        // anim = new h2d.Anim(ss,s2d);
        // //anim.x = 200;

        //trace("调用Click" );


        defauldirction = Std.parseInt(ss.direction);

        //trace("actionClick:" + ss);
        //trace("anim.loop3:" + defauldirction);

        anim.play(ss.data, 0);
        anim.degreesList = ss.rotate;
        //anim.x = 200;
        anim.speed = ss.rate;
        anim.loop = false;
        setOverturn();
        //anim.scaleX = scaleX;
        //anim.scaleY = scaleY;
        setRoleJSTile(ss);
        anim.onAnimEnd = function (){
            if(Std.int(anim.currentFrame) == anim.frames.length){
                var defa = defaultAnimationMap.get(ss.direction);
                //trace("defa:"+defa);
                                
                if(defa != null){
                    
                    anim.play(defa.data);
                    anim.degreesList = defa.rotate;
                    anim.speed = defa.rate;
                    anim.loop = true;
                    setOverturn();
                    //anim.scaleX = scaleX;
                   // anim.scaleY = scaleY;
                    setRoleJSTile(defa);
                    //anim.x = 200;
                    //trace("anim.loop:3"+anim.loop);
                    //trace("anim.loop1:"+defa);

                }
            }

        };



}
//一套图松开触发
public function bindArrClick1(arr:Array<Int>,name:String){
 
    keyboard.setKeyBindClick(arr, function(): Void {
        PlayActionClick1(name);
    });


}

var imgType = 0;
//添加图片 测试模式
public function setImg(imgName:String){
    //img.setBitmapData(assets.getBitmapDataTile(imgName));
    imgType = 1;
    
    //assets.loadFile(this.path + imgName);
    assets.loadFile(imgName);
    keyboard.clearKeyBind();

    

    assets.start(function(f) {
        if (f == 1) {
            img = new Image(assets.getBitmapDataTile(getName1(imgName) ), _vbox);
            //img.x = 20;
            img.y = -250;

            //_vbox.addChildAt(grmask, _vbox.getChildIndex(img) + 1);

           // anim.setScale(-0.6);
        }
    });
    
}

public function restores(){
    imgType = 0;
    keyboard.Assignment();
    _vbox.removeChild(img);
}




public function PlayActionClick1(name:String){
    var ss = arrTile2.get(name).get(defauldirction+"");
    if(ss == null){
        //trace("ss == null");
        return;
    }
    // anim = null;
    // anim = new h2d.Anim(ss,s2d);
    // //anim.x = 200;

    //trace("调用Click" );


    defauldirction = Std.parseInt(ss.direction);

    //trace("actionClick:" + ss);
    //trace("anim.loop3:" + defauldirction);
    anim.loop = false;
    anim.play(ss.data, 0);
    anim.degreesList = ss.rotate;
    //anim.x = 200;
    anim.speed = ss.rate;
    setOverturn();
    //anim.scaleX = scaleX;
    //anim.scaleY = scaleY;
    
    setRoleJSTile(ss);
    anim.onAnimEnd = function (){
        if(Std.int(anim.currentFrame) == anim.frames.length){
            var defa = defaultAnimationMap.get(ss.direction);
                        
            if(defa != null){
                
                anim.play(defa.data);
                anim.degreesList = defa.rotate;
                anim.speed = defa.rate;
                anim.loop = true;
                setOverturn();
                //anim.scaleX = scaleX;
                //anim.scaleY = scaleY;
                //anim.x = 200;
                //trace("anim.loop:3"+anim.loop);
                //trace("anim.loop1:"+defa);
                //trace("anim.loop2:"+anim.loop);

                setRoleJSTile(defa);

            }
           // trace("anim.loop2:"+anim.loop);
        }
        
        // var defa = defaultAnimationMap.get(ss.direction);
                        
        // if(defa != null){
            
        //     anim.play(defa.data);
        //     anim.speed = defa.rate;
        //     anim.loop = false;
        //     //anim.x = 200;
        //     //trace("anim.loop:3"+anim.loop);
        //     trace("anim.loop1:"+defa);
        //     //trace("anim.loop2:"+anim.loop);

        // }

    };



}
    
    

    var keyboard:KeyboardControl;





    // private function combo1Action():Void {
    //     // 执行按键组合1对应的操作
    //     trace("左上");
    // }

    private function combo2Action():Void {
        // 执行按键组合2对应的操作
        trace("右下");
    }

    private function combo3Action():Void {
        // 执行按键组合2对应的操作
        trace("攻击");
    }

    public var windowWidth: Int ;
    public var windowHeight: Int ;



    var img:Image;
    

    var minX:Float = 0; // 菱形的最小x坐标
    var maxX:Float = 0; // 菱形的最大x坐标
    var minY:Float = 0; // 菱形的最小y坐标
    var maxY:Float = 0; // 菱形的最大y坐标

    public function setinit(url:String,?param:String = "default",?param1:String = "default"){

        if(s3d == null) {
            return;
        }

        this.callback = 0;
        this.param = param;
        this.param1 = param1;

        this.PlayName = "";
        this.PlayDirction = "";

        


        arrTile1.clear();
        arrTile2.clear();
        arrSegmentation.clear();
        mapImage.clear();
        assets.unloadAll();
        defaultAnimationMap.clear();

        if(postionLine != null){
            s2d.removeChild(postionLine);
        }
        if(_vbox !=null){
            s2d.removeChild(_vbox);
        }

        
          

        
            //trace("1");
        if(anim!=null){
            anim.remove();
            
            anim = null;
        }
        //anim = null;
            
        
        
        
        
        //hxd.Window.getInstance().addEventTarget(onEvent);



        keyboard = new KeyboardControl();


        this.url = url;
        this.path = url;
        // trace("url" + getName());
        // trace(url+".image\\image0.png");

        // var ssss = "I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa4.rule.image\\image0.png";

        // var index:Int = ssss.lastIndexOf(".");
        // trace("ssss" + ssss.substr(index + 1));

        // trace("url" + getName1("I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa4.rule.image\\image0.png"));


        assets.loadFile(StringTools.replace(this.url, "\\", "/"));
        //assets.loadFile("res/role/test.png");

        // assets.loadFile("res/role/image0.png");
		//  assets.loadFile("res/role/image1.png");
		//  assets.loadFile("res/role/image2.png");
		//  assets.loadFile("res/role/image3.png");
		//  assets.loadFile("res/role/image4.png");
		//  assets.loadFile("res/role/image5.png");
        //  assets.loadFile("res/role/dandan.png");
       // assets.loadFile("res/role/dandan.png");
        assets.start(function(f) {
            if (f == 1) {
                trace('loading over1');
                //trace(assets.getRule(getName()));
                //trace("aa:"+assets.getJson(getName()));
                if( assets.getJson(getName())=="undefined" ||  assets.getJson(getName()) == null){
                    return;
                }
                var aa= haxe.Json.stringify(assets.getJson(getName()));

                //trace("aa1:"+aa);

                #if js
                Browser.window.addEventListener('resize', onResize);


              
                
               
                
                var canvas = Browser.document.getElementById("rolejs");


                //trace("Canvas Width: " + canvas.clientWidth);
                //trace("Canvas Width: " + canvas.clientHeight);

                //windowWidth = Browser.window.innerWidth;
                //windowHeight = Browser.window.innerHeight;

                

                //trace("Window width: " + windowWidth);
                //trace("Window height: " + windowHeight);

                postionLine = new h2d.Graphics(s2d);
                postionLine.beginFill(0xFF0000, 0.5);

                postionLine.drawRect(0, canvas.clientHeight/2,canvas.clientWidth,1);
                postionLine.drawRect(canvas.clientWidth/2, 0, 1, canvas.clientHeight);

                postionLine.endFill();


                _vbox = new h2d.Object(s2d);

                _vbox.x = canvas.clientWidth/2;
                _vbox.y = canvas.clientHeight/2;
                #end




                #if hl
                postionLine = new h2d.Graphics(s2d);
                postionLine.beginFill(0xFF0000, 0.5);

                postionLine.drawRect(0, Window.getInstance().height/2,Window.getInstance().width,1);
                postionLine.drawRect(Window.getInstance().width/2, 0, 1, Window.getInstance().height);

                postionLine.endFill();


                _vbox = new h2d.Object(s2d);

                _vbox.x = Window.getInstance().width/2;
                _vbox.y = Window.getInstance().height/2;
                #end
                
                
                

                var jsonObject = Json.parse(aa);

                //trace("jsonObject:"+jsonObject+"");
               // return;

                arrTile.clear();

                
                //trace("aa"+haxe.Json.stringify(jsonObject));

                //img = new Image(assets.getBitmapDataTile("test"), _vbox);
                //img.x = 100;
                //img.y = 100;
               

                var animation:Array<Dynamic> = jsonObject.animation;
                scaleX = jsonObject.scaleX;
                scaleY = jsonObject.scaleY;
                this.path = this.path + ".image\\";
                this.path = StringTools.replace(this.path, "\\", "/");
                for (anim in animation) {
                    //trace(anim.type); // 输出 "images"
                    var data:Array<Dynamic> = anim.data;

                   // var arrImage:Array<String> = new Array<String>();
                    //var mapImagename:Map<String,Array<String>> = new Map<String,Array<String>>();

                    var mapImagesArr:Array<MapImage> = new Array<MapImage>();
                    var segmentationArr:Array<Segmentation> = new Array<Segmentation>();
                    if(anim.defaulaction){
                        defauldirction = anim.defauldirection;
                    }

                    for (da in data) {
                        
                        if(da.type == "images"){
                            var mapImages = new MapImage();
                            var imagedata:Array<Dynamic> = da.data;
                            var arrImageName:Array<DataImage> = new Array<DataImage>();
                            var rotate:Array<Float> = new Array<Float>(); // 旋转角度
                            for (image in imagedata) {
                                var dataimage:DataImage = new DataImage();
                                dataimage.positionX = image.positionX;
                                dataimage.positionY = image.positionY;
                                dataimage.overturn = image.overturn;
                                //dataimage.rotate = image.rotate;
                                rotate.push(image.rotate);
                                dataimage.url = getName1(image.url);
                                //trace(image.positionX);
                                //trace(image); // 输出 "images"
                                assets.loadFile(image.url);
                               // assets.loadFile(this.path + image.url);
                                // trace(getName1(image));
                                arrImageName.push(dataimage);
                                
                            }
                            mapImages.rotate = rotate;
                            mapImages.carousel = da.carousel;
                            mapImages.direction = da.direction ;
                            mapImages.data = arrImageName;
                            mapImages.rate = da.rate;
                            //mapImages.overturn = da.overturn;
                            //mapImages.collision = da.collision;
                           // var pro:Property = new Property();


                            // if(da.collision == 1 ){

                            // }else if(da.collision == 2){
                            //     pro.x = da.collisionproperty.x;
                            //     pro.y = da.collisionproperty.y;
                            //     pro.width = da.collisionproperty.width;
                            //     pro.height = da.collisionproperty.height;

                            // }else if (da.collision == 3){
                            //     pro.x = da.collisionproperty.x;

                            // }else if(da.collision == 4){
                            //     pro.polygon = da.collisionproperty.polygon;
                                
                            // }
                            
                            //trace("da.collision:"+pro);

                           // mapImages.collisionproperty = pro;

                            mapImages.collisiondata = da.collisiondata;
                            mapImages.maskdata = da.maskdata;
                            //trace("da.collisiondata:"+mapImages.collisiondata);

                            // mapImages.mask = da.mask;
                            // var pro1:Property = new Property();
                            // if(da.mask == 1 ){
                            //     pro1.x = da.maskproperty.x;
                            //     pro1.y = da.maskproperty.y;
                            //     pro1.width = da.maskproperty.width;
                            //     pro1.height = da.maskproperty.height;
                            // }else if(da.mask == 2){
                            //     pro1.x = da.maskproperty.x;

                            // }

                            // mapImages.maskproperty = pro1;


                            mapImages.defaulaction = anim.defaulaction;

                            if(anim.keys!=null  && anim.keys.length>0){
                                mapImages.keys = anim.keys;
                                mapImages.down = anim.down;
                                mapImages.judge = 1;
                            }else{
                                mapImages.keys = da.keys;
                                mapImages.down = da.down;
                                mapImages.judge = 2;
                            }

                            
                            // if(da.keys!=null && da.keys.length>0){
                            //     trace("keys: 不为空" + da.keys);
                            //     mapImages.keys = da.keys;
                            //     mapImages.down = da.down;
                            // }else{
                            //     trace("keys: null" + da.keys);
                            // }

                            //trace("keys:"+da.keys);


                            //mapImagename.set(da.direction, arrImageName);

                            mapImagesArr.push(mapImages);

                            mapImage.set(anim.name, mapImagesArr);


                        }else{
                            //trace(da);
                            var segmen:Segmentation = new Segmentation();


                            var imagedata:Array<Dynamic> = da.data;
                            var arrImageName:Array<DataImage> = new Array<DataImage>();
                            var rotate:Array<Float> = new Array<Float>(); // 旋转角度
                            for (image in imagedata) {
                                var dataimage:DataImage = new DataImage();
                                dataimage.positionX = image.positionX;
                                dataimage.positionY = image.positionY;
                                dataimage.x = image.x;
                                dataimage.y = image.y;
                                dataimage.width = image.width;
                                dataimage.height = image.height;
                                dataimage.overturn = image.overturn;
                                rotate.push(image.rotate);
                                //dataimage.rotate = image.rotate;
                                //assets.loadFile(this.path + image);
                                // trace(getName1(image));
                                arrImageName.push(dataimage);
                                
                            }

                            segmen.src = getName1(da.src);
                            segmen.rotate = rotate;
                            segmen.direction = da.direction;
                            segmen.data = arrImageName;
                            segmen.carousel = da.carousel;
                            segmen.rate = da.rate;
                            //segmen.overturn = da.overturn;
                            segmen.defaulaction = anim.defaulaction;




                           // segmen.collision = da.collision;
                            // var pro:Property = new Property();
                            // if(da.collision == 1 ){

                            // }else if(da.collision == 2){
                            //     pro.x = da.collisionproperty.x;
                            //     pro.y = da.collisionproperty.y;
                            //     pro.width = da.collisionproperty.width;
                            //     pro.height = da.collisionproperty.height;

                            // }else if (da.collision ==3){
                            //     pro.x = da.collisionproperty.x;

                            // }else if(da.collision == 4){
                            //     pro.polygon = da.collisionproperty.polygon;
                                
                            // }
                            

                            // segmen.collisionproperty = pro;

                            segmen.collisiondata = da.collisiondata;
                            segmen.maskdata = da.maskdata;



                            // segmen.mask = da.mask;
                            // var pro1:Property = new Property();
                            // if(da.mask == 1 ){
                            //     pro1.x = da.maskproperty.x;
                            //     pro1.y = da.maskproperty.y;
                            //     pro1.width = da.maskproperty.width;
                            //     pro1.height = da.maskproperty.height;
                            // }else if(da.mask == 2){
                            //     pro1.x = da.maskproperty.x;

                            // }

                            // segmen.maskproperty = pro1;

                            if(anim.keys!=null  && anim.keys.length>0){
                                segmen.keys = anim.keys;
                                segmen.down = anim.down;
                                segmen.judge = 1;
                            }else{
                                segmen.keys = da.keys;
                                segmen.down = da.down;
                                segmen.judge = 2;
                            }
                            // if(da.keys!=null  && da.keys.length>0){
                            //     segmen.keys = da.keys;
                            //     segmen.down = da.down;
                            // }

                            assets.loadFile(da.src);
                            //assets.loadFile(this.path + da.src );
                            
                            
                            // var arrImageName:Array<String> = new Array<String>();
                            // var imagedata:Array<Dynamic> = da.data;
                            segmentationArr.push(segmen);
                            

                            arrSegmentation.set(anim.name, segmentationArr);


                        }
                        
                        
                        // trace(image); // 输出 "images"
                        // assets.loadFile(image);
                        // trace(getName1(image));
                        // arrImage.push(getName1(image));


                    }
                    //trace(anim.name);
                    // mapImage.set(anim.name, mapImagename);
                    //arrTile.set(anim.name, arrImage);
                }
                //trace(mapImage);
                //trace(arrSegmentation);
                assets.start(function(f) {
                    if (f == 1) {
                        //trace("f:"+ f);
                        //trace("mapImage"+ mapImage);
                        for (arr in arrSegmentation.keys()){
                            //trace(arr);
                            var segmens = arrSegmentation.get(arr);
                            var judgeMap:Map<String,RolejsTile> = new Map<String,RolejsTile>();
                            for (segmen in segmens){
                                //trace(segmen);
                                
                                var role:RolejsTile = new RolejsTile();
                                var t0:Tile = assets.getBitmapDataTile(segmen.src);
                                var hh: Array<Tile>= new Array<Tile>();
                                var map:Map<String,Array<Tile>> = new Map<String,Array<Tile>>();
                                for (da in segmen.data) {
                                    //trace(da);
                                    //var aa= haxe.Json.stringify(da);
                                   // var object = Json.parse(aa);
                                    var t1:Tile = t0.sub(da.x,da.y,da.width,da.height,0,0);
                                    t1.dx = da.positionX;
                                    t1.dy = da.positionY;
                                    

                                    if(da.overturn == 1){
                                        t1.dx = -t1.dx -t1.width;
                                        t1.xFlip = true;
                                    }else if(da.overturn == 2){
                                        t1.dy = -t1.dy -t1.height;
                                        t1.yFlip = true;
                                    }else if(da.overturn == 3){
                                        t1.dx = -t1.dx -t1.width;
                                        t1.dy = -t1.dy -t1.height;
                                        t1.xFlip = true;
                                        t1.yFlip = true;
                                    }

                                    
                                    //t1.setPosition(100,100);
                                    //t1.x = 100;
                                    hh.push(t1);
                                    
                                }
                                role.carousel = segmen.carousel;
                                role.rate = segmen.rate;
                                role.direction = segmen.direction;
                                role.data = hh;
                                role.rotate = segmen.rotate;

                                //role.overturn = segmen.overturn;
                                role.collisiondata = segmen.collisiondata;
                                role.maskdata = segmen.maskdata;
                                // role.collision = segmen.collision;
                                // role.collisionproperty = segmen.collisionproperty;
                               // role.mask = segmen.mask;
                                //role.maskproperty = segmen.maskproperty;
                                if(segmen.data.length == 0){
                                    role.positionX = 0;
                                    role.positionY = 0;
                                }else{
                                    role.positionX = segmen.data[segmen.data.length-1].positionX;
                                    role.positionY = segmen.data[segmen.data.length-1].positionY;
                                }
                                
                                
                                if(segmen.keys!=null  && segmen.keys.length>0){
                                    role.keys = segmen.keys;
                                    role.down = segmen.down;
                                    //trace("keys: 不为空" + segmen.keys);
                                    if(segmen.judge == 1){
                                        if(segmen.down == 2){
                                            bindArr1(role.keys,arr);
                                        }else{
                                            bindArrClick1(role.keys,arr );
                                        }

                                    }else{
                                        if(segmen.down == 2){
                                            bindArr(role.keys,arr ,segmen.direction);
                                        }else{
                                            bindArrClick(role.keys,arr ,segmen.direction);
                                        }

                                    }

                                     
                                    
                                    //bindArr(role.keys,arr ,segmen.direction);
                                    
                                    
                                }else{
                                    //trace("keys: null" + segmen.keys);
                                }
                                if(segmen.defaulaction){
                                    role.carousel = true;
                                    defaultAnimation = role;
                                    defaultAnimationMap.set(segmen.direction, role);

                                }
                                map.set(segmen.direction, hh);
                                arrTile1.set(arr + segmen.direction, role);
                                judgeMap.set(segmen.direction, role);
                            }
                            arrTile2.set(arr,judgeMap);
                            
                            
                        }
                        for (arr in mapImage.keys()){
                            //trace(arr);
                            var images = mapImage.get(arr);
                            var judgeMap:Map<String,RolejsTile> = new Map<String,RolejsTile>();
                            
                            for (image in images){
                                var role:RolejsTile = new RolejsTile();
                                var arrTile: Array<Tile>= new Array<Tile>();
                                for (age in image.data){
                                   //trace(image);
                                    var t0:Tile = assets.getBitmapDataTile(age.url);
                                    //t0.setPosition(-50,-50);
                                    //t0.xFlip = true;
                                    t0.dx = age.positionX;
                                    t0.dy = age.positionY;

                                    if(age.overturn == 1){
                                        t0.dx = -t0.dx -t0.width;
                                        t0.xFlip = true;
                                    }else if(age.overturn == 2){
                                        t0.dy = -t0.dy -t0.height;
                                        t0.yFlip = true;
                                    }else if(age.overturn == 3){
                                        t0.dx = -t0.dx -t0.width;
                                        t0.dy = -t0.dy -t0.height;
                                        t0.xFlip = true;
                                        t0.yFlip = true;
                                    }
                                    
                                    

                                    // var matrix: Matrix = new Matrix();
                                    // matrix.rotate(180);
                                    // transform(matrix);

                                    
                                    
                                    //t0.setCenterRatio(0.5,0.5);

                                   // t0.setPosition(100,100);

                                    arrTile.push(t0);
                                }

                                //trace(image);
                                // var arrImage = image;
                                // var arrTile: Array<Tile>= new Array<Tile>();
                                // for (image in arrImage){
                                //    //trace(image);
                                //     var t0:Tile = assets.getBitmapDataTile(image);
                                //     arrTile.push(t0);
                                // }
                                // var map:Map<String,Array<Tile>> = new Map<String,Array<Tile>>();
                                // map.set(image, arrTile);
                                // arrTile1.set(arr + image, arrTile);
                                role.carousel = image.carousel;
                                role.rate = image.rate;
                                role.rotate = image.rotate;
                                role.direction = image.direction;
                                role.data = arrTile;
                                //role.overturn = image.overturn;
                                role.collisiondata = image.collisiondata;
                                role.maskdata = image.maskdata;
                                // role.collision = image.collision;
                                // role.collisionproperty = image.collisionproperty;
                               // role.mask = image.mask;
                               // role.maskproperty = image.maskproperty;
                                if(image.data.length == 0){
                                    role.positionX = 0;
                                    role.positionY = 0;
                                }else{
                                    role.positionX = image.data[image.data.length-1].positionX;
                                    role.positionY = image.data[image.data.length-1].positionY;
                                }
                                
                                //trace("role:"+role);
                                
                                if(image.keys!=null  && image.keys.length>0){
                                    //trace("keys: 不为空" + image.keys);
                                    role.keys = image.keys;
                                    role.down = image.down;
                                    if(image.judge == 1){
                                        if(image.down == 2){
                                            bindArr1(role.keys,arr);
                                            //trace("123123123123");
                                        }else{
                                            bindArrClick1(role.keys,arr);
                                        }

                                    }else{
                                        if(image.down == 2){
                                            bindArr(role.keys,arr ,image.direction);
                                        }else{
                                            bindArrClick(role.keys,arr ,image.direction);
                                        }

                                    }

                                    
                                      
                                    
                                    
                                }else{
                                    //trace("keys: null" + image.keys);
                                }
                                if(image.defaulaction){
                                    role.carousel = true;
                                    defaultAnimation = role;
                                    defaultAnimationMap.set(image.direction, role);
                                    PlayName = arr;
                                }

                                judgeMap.set(image.direction, role);
                                arrTile1.set(arr + image.direction, role);
                            }

                            arrTile2.set(arr,judgeMap);
                            
                            


                            
                        }

                        this.callback = 1;

                        //trace("arrTile1:"+arrTile1);
                        //trace("param,param1:"+param);

                        
                        vertices = [
                            { x: 200, y: 100 }, // 第一个顶点
                            { x: 300, y: 50 },  // 第二个顶点
                            { x: 400, y: 100 }, // 第三个顶点
                            { x: 450, y: 200 }, // 第四个顶点
                            { x: 350, y: 250 }, // 第五个顶点
                            { x: 250, y: 200 },  // 第六个顶点
                            { x: 330, y: 220 },  // 第六个顶点
                        ];

                        var polygons: Array<Array<{ x: Float, y: Float }>> = [
                            [
                                { x: 200.0, y: 100.0 },
                                { x: 300.0, y: 50.0 },
                                { x: 400.0, y: 100.0 },
                                { x: 450.0, y: 200.0 },
                                { x: 350.0, y: 250.0 },
                                { x: 250.0, y: 200.0 },
                                { x: 330.0, y: 220.0 }
                            ],
                            [
                                { x: 500.0, y: 300.0 },
                                { x: 600.0, y: 250.0 },
                                { x: 700.0, y: 300.0 },
                                { x: 750.0, y: 400.0 },
                                { x: 650.0, y: 450.0 },
                                { x: 550.0, y: 400.0 },
                                { x: 630.0, y: 420.0 }
                            ]
                        ];

                        var polygons = [
                            [
                                { x: 200, y: 100 },
                                { x: 300, y: 50 },
                                { x: 400, y: 100 },
                                { x: 450, y: 200 },
                                { x: 350, y: 250 },
                                { x: 250, y: 200 },
                                { x: 330, y: 220 }
                            ],
                            [
                                { x: 500, y: 300 },
                                { x: 600, y: 250 },
                                { x: 700, y: 300 },
                                { x: 750, y: 400 },
                                { x: 650, y: 450 },
                                { x: 550, y: 400 },
                                { x: 630, y: 420 }
                            ]
                        ];

                        // var graphics = new h2d.Graphics();
                        // var i = 1;
                        // for (polygon in polygons) {
                        //     if(i == 1){
                        //         graphics.beginFill(0xFF0000, 1.0);
                        //         graphics.moveTo(polygon[0].x, polygon[0].y);
                    
                        //         for (i in 1...polygon.length) {
                        //             graphics.lineTo(polygon[i].x, polygon[i].y);
                        //         }
                    
                        //         graphics.endFill();
                        //         i++;
                        //     }else{

                        //         graphics.beginFill(0xFF0000, 1.0);
                        //         //trace("width");
                        //         //trace(defaultAnimation.data[0].width);
                        //         //trace(defaultAnimation.data[0].height);
                        //         graphics.drawRect(0, 50, 100, 100);
                        //         graphics.endFill();

                        //     }
                            
                        // }

                        
                        // _vbox.addChild(graphics);

                        // graphics.scaleX = 0.5;
                        // graphics.scaleY = 0.5;

                        //_vbox.removeChild(graphics);
                        // var graphics:h2d.Graphics = new h2d.Graphics();
                        // graphics.beginFill(0xFF0000, 1.0);
                        

                        // graphics.moveTo(vertices[0].x, vertices[0].y); // 将画笔移动到多边形的起始点
        
                        // for (i in 1...vertices.length) {
                        //     graphics.lineTo(vertices[i].x, vertices[i].y); // 画一条线连接到下一个顶点
                        // }
                        
                        // // graphics.lineTo(point5X, point5Y);
                        // // graphics.lineTo(point6X, point6Y);
                        
                        // graphics.endFill();

                        // _vbox.addChild(graphics);

                        




                        




                        
                        if(param == "default" && param1 == "default"){
                            //trace("param:1111111111");
                            //trace("defauldirction:"+defaultAnimationMap.toString());
                            if(defaultAnimationMap == null || defaultAnimationMap.toString() == "[]"){
                                return;
                            }else{
                               
                            }
                            defaultAnimation = defaultAnimationMap.get(defauldirction + "");
                    
                            //trace("defauldirction:"+defaultAnimationMap);
                            //trace("defaultAnimationMap:"+defaultAnimationMap);
                            if(defauldirction != 0 ){
                                defaultAnimation = defaultAnimationMap.get(defauldirction + "");

                                //trace("defaultAnimation:"+defaultAnimation);
                                if(anim == null){
                                    //trace("1");
                                    


                                    



                                     anim = new AnimBase(null,_vbox);
                                     anim.play(defaultAnimation.data);
                                     anim.speed = defaultAnimation.rate;
                                     anim.degreesList = defaultAnimation.rotate;
                                     anim.loop = defaultAnimation.carousel;

                                     //anim.scaleX = scaleX;
                                    //anim.scaleY = scaleY;

                                    // var degreesList = new Array<Float>();
                                    // degreesList.push(0);
                                    // degreesList.push(0);
                                    // degreesList.push(0);
                                    // degreesList.push(0);
                                    //var an:hxPEngine.object.base.AnimBase = new hxPEngine.object.base.AnimBase(degreesList, t,1,s2d);

                                    // var anims:AnimBase = new AnimBase(null,_vbox);
                                    // //anims.speed = 1;
                                    // anims.play(defaultAnimation.data);
                                    // //anims.degreesList = degreesList;
                                    // anims.speed = defaultAnimation.rate;
                                    // anims.loop = defaultAnimation.carousel;



                                    


                                    //trace("anims:"+defaultAnimation.data.length);

                                    
                                    
                                    setOverturn();
                                   
                                    setRoleJSTile(defaultAnimation);

                                   
                                    
                                }else{
                                    //trace("2");
                                    anim.play(defaultAnimation.data);
                                    anim.degreesList = defaultAnimation.rotate;
                                    anim.speed = defaultAnimation.rate;
                                    anim.loop = defaultAnimation.carousel;
                                    setOverturn();
                                    //anim.scaleX = scaleX;
                                    //anim.scaleY = scaleY;
                                    //anim.x = 200;

                                    setRoleJSTile(defaultAnimation);
                                }
                            }else{
                                var next = defaultAnimationMap.keys().next();
                                //trace("next:"+next);
                                defaultAnimation = defaultAnimationMap.get(next);
                                if(anim == null){
                                    //trace("3");
                                    anim = new AnimBase(null,_vbox);
                                    anim.play(defaultAnimation.data);
                                    anim.degreesList = defaultAnimation.rotate;
                                    anim.speed = defaultAnimation.rate;
                                    anim.loop = defaultAnimation.carousel;
                                    setOverturn();
                                    //anim.scaleX = scaleX;
                                   // anim.scaleY = scaleY;
                                    //anim.x = 200;

                                    
                                    
                                }else{
                                    //trace("4");
                                    anim.play(defaultAnimation.data);
                                    anim.degreesList = defaultAnimation.rotate;
                                    anim.speed = defaultAnimation.rate;
                                    anim.loop = defaultAnimation.carousel;
                                    setOverturn();
                                    //anim.scaleX = scaleX;
                                    //anim.scaleY = scaleY;
                                    //anim.x = 200;
                                }
                                setRoleJSTile(defaultAnimation);
                            }

                            PlayDirction = defaultAnimation.direction;
                        }else{
                            //trace("param:22222222");
                            if(param != "default" && param1 != "default"){
                                //trace("22222");
                                PlayAnimation(param,param1);
                                PlayDirction = param1;
                                PlayName = param;
                            }
                            if(param != "default" && param1 == "default"){

                                //trace("11111");
                                PlayName = param;

                            }
                            
                        }


                        
                        
                    }
                });
                
                
                
                
            }
        });

     
    }


    var vertices: Array<{ x: Float, y: Float }>;
    public  function setOverturn(){

        anim.scaleX = this.scaleX;
        anim.scaleY = this.scaleY;

        // if(overturn == 0){

        //     anim.scaleX = this.scaleX;
        //     anim.scaleY = this.scaleY;

        // }else if(overturn == 1){
        //     anim.scaleX = -this.scaleX;
        //     anim.scaleY = this.scaleY;

            

        // }else if(overturn == 2){
        //     anim.scaleX = this.scaleX;
        //     anim.scaleY = -this.scaleY;

        // }else if(overturn == 3){
        //     anim.scaleX = -this.scaleX;
        //     anim.scaleY = -this.scaleY;

        // }
        
    }


    public function setRoleJSTile(role:RolejsTile,?x:Float = 0,?y:Float = 0){
        //trace("setRoleJSTile:"+role.maskdata);

        


        // if(role.collision == 0 || role.collisiondata.length == 0){
        //     if(grcollision != null){
        //         _vbox.removeChild(grcollision);
        //     }
        //     jsoncollision = {};
        // }else if(role.collision == 1){
        //     GraphicsCanvas(1, role.positionX,role.positionY,role.data[0].width,
        //         role.data[0].height);
        // }else if(role.collision == 2){
        //     GraphicsCanvas(2, role.collisionproperty.x,role.collisionproperty.y,role.collisionproperty.width,
        //         role.collisionproperty.height);
        // }else if(role.collision == 3){
        //     GraphicsCanvas(3, role.collisionproperty.x,role.collisionproperty.x,role.collisionproperty.x,
        //         role.collisionproperty.x);
        // }else if(role.collision == 4){
        //     GraphicsCanvas(4, role.collisionproperty.x,role.collisionproperty.x,role.collisionproperty.x,
        //         role.collisionproperty.x,role.collisionproperty.polygon);
        // }
        

        // if(role.mask == 0){
        //     if(grcollision != null){
        //         _vbox.removeChild(grmask);
        //     }
            
        // }else if(role.mask == 1){
        //     GraphicsMask(1,role.maskproperty.x,role.maskproperty.y,role.maskproperty.width,
        //         role.maskproperty.height);
        // }else if(role.mask == 2){
        //     GraphicsMask(2,role.maskproperty.x,role.maskproperty.x,role.maskproperty.x,
        //         role.maskproperty.x);
        // }



        if(role.collisiondata.length == 0){
            if(grcollision != null){
                _vbox.removeChild(grcollision);
            }
            //jsoncollision = {};
        }else{
            GraphicsCanvasData(role);
        }

        if(role.maskdata.length == 0){
            if(grmask != null){
                _vbox.removeChild(grmask);
            }
            //jsoncollision = {};
        }else{
            GraphicsMaskdata(role);
        }


       

        



        // var mask = new Mask(100,100,_vbox);
        // grmask.
       // mask.setMask(mask);
       //var mask = new AbstractMask(s2d);

    }

    public  var jsonMask: Dynamic = {
    };

    public  var jsonMask2: Dynamic = {
    };

    public  var jsonMaskdata: Array<Dynamic> = [];

    public  var jsonMaskdata2: Array<Dynamic> = [];

    public function GraphicsMask(type:Int,x:Float,y:Float,width:Float,height:Float){
        if(_vbox != null && grmask != null){
            _vbox.removeChild(grmask);
        }


        jsonMask = {};
        jsonMask2 = {};

        if(type == 0){
            if(grmask != null){
                grmask.clear();
            }

        }else if(type == 1){
            grmask = new h2d.Graphics(_vbox);
            grmask.beginFill(0xFFFF00, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            grmask.drawRect(x, y, width, height);
            grmask.endFill();

            Reflect.setField(jsonMask, "x", x * scaleX);
            Reflect.setField(jsonMask, "y", y * scaleY);
            Reflect.setField(jsonMask, "width", width * scaleX);
            Reflect.setField(jsonMask, "height", height * scaleY);


            // 添加字符串值
            Reflect.setField(jsonMask2, "x", x);
            Reflect.setField(jsonMask2, "y", y);
            Reflect.setField(jsonMask2, "width", width);
            Reflect.setField(jsonMask2, "height", height);

            grmask.scaleX = scaleX;
            grmask.scaleY = scaleY;
        }else if(type == 2){
            grmask = new h2d.Graphics(_vbox);
            grmask.beginFill(0xFFFF00, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            var xx = 0 -(x/2);
            var yy = 0 -(x/2);
            //trace("x:"+x + "y:"+y + "width:"+width + "height:"+height);
            //trace("xx:"+xx );

            grmask.drawRect(xx, yy, x, x);
            grmask.endFill();


            Reflect.setField(jsonMask, "x", xx  * scaleX);
            Reflect.setField(jsonMask, "y", yy  * scaleY);
            Reflect.setField(jsonMask, "width", x  * scaleX);
            Reflect.setField(jsonMask, "height", x  * scaleY);

            Reflect.setField(jsonMask2, "x", xx);
            Reflect.setField(jsonMask2, "y", yy);
            Reflect.setField(jsonMask2, "width", x);
            Reflect.setField(jsonMask2, "height", x);

            grmask.scaleX = scaleX;
            grmask.scaleY = scaleY;
        }

       // trace("grmask:"+_vbox.getChildIndex(img));
        //trace("grmask1:"+_vbox.getChildIndex(grmask));

       // _vbox.addChildAt(img, _vbox.getChildIndex(grmask) + 1);
        //trace("img:"+_vbox.getChildIndex(img));
        
    }

    public function GraphicsMaskdata(role:RolejsTile){
        if(_vbox != null && grmask != null){
            _vbox.removeChild(grmask);
        }

        if(role.maskdata.length == 0){
            if(grmask != null){
                grmask.clear();
            }
        }


        jsonMaskdata = [];
        jsonMaskdata2 = [];



        grmask = new h2d.Graphics(_vbox);
        var newObj = {};
        var newObj1 = {};
        for (data in role.maskdata){
            if(data.mask == 1 ){
                
                grmask.beginFill(0xFFFF00, 0.5);
                //trace("width");
                //trace(defaultAnimation.data[0].width);
                //trace(defaultAnimation.data[0].height);
                grmask.drawRect(data.x,data.y,data.width,
                    data.height);
                grmask.endFill();

                var newObj = {
                    "mask": data.mask,
                    "x": data.x * scaleX,
                    "y": data.y * scaleY,
                    "width": data.width * scaleX,
                    "height": data.height * scaleY,
                    "polygon": data.polygon
                };
                var newObj1 = {
                    "mask": data.mask,
                    "x": data.x,
                    "y": data.y,
                    "width": data.width,
                    "height": data.height,
                    "polygon": data.polygon
                };
                jsonMaskdata.push(newObj);
                jsonMaskdata2.push(newObj1);


                grmask.scaleX = scaleX;
                grmask.scaleY = scaleY;
            }else if(data.mask == 2){


                

                grmask.beginFill(0xFFFF00, 0.5);

                var xx = 0 -(data.x/2);
                var yy = 0 -(data.x/2);
                grmask.drawRect(xx,yy,data.x,
                    data.x);
                grmask.endFill();

                newObj = {
                    "mask": data.mask,
                    "x": xx  * scaleX,
                    "y": yy  * scaleY,
                    "width": data.x  * scaleX,
                    "height": data.x  * scaleY,
                    "polygon": data.polygon
                };

                newObj1 = {
                    "mask": data.mask,
                    "x": xx ,
                    "y": yy ,
                    "width": data.x ,
                    "height": data.x ,
                    "polygon": data.polygon
                };
                jsonMaskdata.push(newObj);
                jsonMaskdata2.push(newObj1);

                grmask.scaleX = scaleX;
                grmask.scaleY = scaleY;
            }else if(data.mask == 3){

                grmask.beginFill(0xFFFF00, 0.5);
    
                // var graphics:h2d.Graphics = new h2d.Graphics();
                // graphics.beginFill(0xFF0000, 1.0);
                
    
                grmask.moveTo(data.polygon[0].x, data.polygon[0].y); // 将画笔移动到多边形的起始点
    
                for (i in 1...data.polygon.length) {
                    grmask.lineTo(data.polygon[i].x, data.polygon[i].y); // 画一条线连接到下一个顶点
                }
                
                // graphics.lineTo(point5X, point5Y);
                // graphics.lineTo(point6X, point6Y);
                
                grmask.endFill();

                
                
                
                

                var polygon = [];
                for (i in 0...data.polygon.length) {

                    // data.polygon[i].x *= scaleX; // 应用乘数值
                    // data.polygon[i].y *= scaleX; // 应用乘数值
                    // var polygon = data.polygon[i];

                    var po = {"x": data.polygon[i].x * scaleX ,"y": data.polygon[i].y * scaleY};
                    polygon.push(po);
                    
                }

                newObj = {
                    "mask": data.mask,
                    "x": data.x  * scaleX,
                    "y": data.y  * scaleY,
                    "width": data.width  * scaleX,
                    "height": data.height * scaleY,
                    "polygon": polygon
                };
                newObj1 = {
                    "mask": data.mask,
                    "x": data.x ,
                    "y": data.y,
                    "width": data.width,
                    "height": data.height,
                    "polygon": polygon
                };



                jsonMaskdata.push(newObj);
                jsonMaskdata2.push(newObj1);

                grmask.scaleX = scaleX;
                grmask.scaleY = scaleY;

            }





        }


        //trace("jsonMaskdata:"+jsonMaskdata);




        
    }
    

    //var jsoncollision;
    public  var jsoncollision: Dynamic = {
    };

    public  var jsoncollision2: Dynamic = {
    };


    public  var jsoncollisiondata: Array<Dynamic> = [];
    public  var jsoncollisiondata1: Array<Dynamic> = [];

    public function GraphicsCanvasData(role:RolejsTile){
        jsoncollisiondata = [];
        jsoncollisiondata1 = [];

        //jsoncollisiondata.push(newObj);
        //jsoncollisiondata.push(newObj1);
        //jsoncollision.name = "John Doe";
       // trace("GraphicsCanvas:"+type);
        //jsoncollision = {};
        //jsoncollision2 = {};
        //trace("role.collisiondata.length:"+jsoncollisiondata);
        
        if(_vbox != null && grcollision != null){
            _vbox.removeChild(grcollision);
        }
        if(role.collisiondata.length == 0){
            if(grcollision != null){
                grcollision.clear();
            }
        }


      
    

        grcollision = new h2d.Graphics(_vbox);
        var newObj = {};
        var newObj1 = {};
        for (data in role.collisiondata){
            if(data.collision == 1 ){
                
                grcollision.beginFill(0xFF0000, 0.5);
                //trace("width");
                //trace(defaultAnimation.data[0].width);
                //trace(defaultAnimation.data[0].height);
                grcollision.drawRect(role.positionX,role.positionY,role.data[0].width,
                    role.data[0].height);
                grcollision.endFill();
               


                newObj = {
                    "collision": data.collision,
                    "x": role.positionX * scaleX,
                    "y": role.positionY * scaleY,
                    "width": role.data[0].width * scaleX,
                    "height": role.data[0].height * scaleY,
                    "polygon": data.polygon
                };
                newObj1 = {
                    "collision": data.collision,
                    "x": role.positionX,
                    "y": role.positionY,
                    "width": role.data[0].width,
                    "height": role.data[0].height,
                    "polygon": data.polygon
                };

    
    
                jsoncollisiondata.push(newObj);
                jsoncollisiondata1.push(newObj1);
                grcollision.scaleX = scaleX;
                grcollision.scaleY = scaleY;
    
               // trace("jsoncollision:"+jsoncollision);
            }else if ( data.collision == 2){
                grcollision.beginFill(0xFF0000, 0.5);
                //trace("width");
                //trace(defaultAnimation.data[0].width);
                //trace(defaultAnimation.data[0].height);
                grcollision.drawRect(data.x,data.y,data.width,
                    data.height);
                grcollision.endFill();
               
    

                newObj = {
                    "collision": data.collision,
                    "x": data.x * scaleX,
                    "y": data.y * scaleY,
                    "width": data.width * scaleX,
                    "height": data.height * scaleY,
                    "polygon": data.polygon
                };
                newObj1 = {
                    "collision": data.collision,
                    "x": data.x ,
                    "y": data.y ,
                    "width": data.width ,
                    "height": data.height ,
                    "polygon": data.polygon
                };
    
                jsoncollisiondata.push(newObj);
                jsoncollisiondata1.push(newObj1);
                grcollision.scaleX = scaleX;
                grcollision.scaleY = scaleY;


            }else if(data.collision == 3){
                //grcollision = new h2d.Graphics(_vbox);
                grcollision.beginFill(0xFF0000, 0.5);
                //trace("width");
                //trace(defaultAnimation.data[0].width);
                //trace(defaultAnimation.data[0].height);
                var xx = 0 -(data.x/2);
                var yy = 0 -(data.x/2);
                grcollision.drawRect(xx, yy, data.x, data.x);
                grcollision.endFill();
               

                newObj = {
                    "collision": data.collision,
                    "x": xx  * scaleX,
                    "y": yy  * scaleY,
                    "width": data.x  * scaleX,
                    "height": data.x  * scaleY,
                    "polygon": data.polygon
                };
                newObj1 = {
                    "collision": data.collision,
                    "x": xx  ,
                    "y": yy  * scaleY,
                    "width": data.x ,
                    "height": data.x,
                    "polygon": data.polygon
                };
    
                jsoncollisiondata.push(newObj);
                jsoncollisiondata1.push(newObj1);
                grcollision.scaleX = scaleX;
                grcollision.scaleY = scaleY;
    
            }else if(data.collision == 4){
    
    
    
                //grcollision = new h2d.Graphics(_vbox);
                grcollision.beginFill(0xFF0000, 0.5);
    
                // var graphics:h2d.Graphics = new h2d.Graphics();
                // graphics.beginFill(0xFF0000, 1.0);
                
    
                grcollision.moveTo(data.polygon[0].x, data.polygon[0].y); // 将画笔移动到多边形的起始点
    
                for (i in 1...data.polygon.length) {
                    grcollision.lineTo(data.polygon[i].x, data.polygon[i].y); // 画一条线连接到下一个顶点
                }
                
                // graphics.lineTo(point5X, point5Y);
                // graphics.lineTo(point6X, point6Y);
                
                grcollision.endFill();

                
    
                var polygon = [];
                for (i in 0...data.polygon.length) {

                    // data.polygon[i].x *= scaleX; // 应用乘数值
                    // data.polygon[i].y *= scaleX; // 应用乘数值
                    // var polygon = data.polygon[i];

                    var po = {"x": data.polygon[i].x * scaleX ,"y": data.polygon[i].y * scaleY};
                    polygon.push(po);
                    
                }

                newObj = {
                    "collision": data.collision,
                    "x": data.x  * scaleX,
                    "y": data.y  * scaleY,
                    "width": data.width  * scaleX,
                    "height": data.height * scaleY,
                    "polygon": polygon
                };
                newObj1 = {
                    "collision": data.collision,
                    "x": data.x ,
                    "y": data.y,
                    "width": data.width,
                    "height": data.height,
                    "polygon": polygon
                };

                
                 jsoncollisiondata.push(newObj);
                 jsoncollisiondata1.push(newObj1);
    
                grcollision.scaleX = scaleX;
                grcollision.scaleY = scaleY;
            }

            

            //jsoncollisiondata.push(data);

        }
        //trace("jsoncollisiondata:"+jsoncollisiondata1);
        //trace("jsoncollision:"+jsoncollisiondata);

        

        

        
    }



    public function GraphicsCanvas(type:Int,x:Float,y:Float,width:Float,height:Float,?vertices: Array<{ x: Float, y: Float }>){

        //jsoncollision.name = "John Doe";
        //trace("GraphicsCanvas:"+type);
        jsoncollision = {};
        jsoncollision2 = {};
        
        
        if(_vbox != null && grcollision != null){
            _vbox.removeChild(grcollision);
        }

        if(type == 0){
            if(grcollision != null){
                grcollision.clear();
            }
        }else if(type == 1 || type == 2){
            grcollision = new h2d.Graphics(_vbox);
            grcollision.beginFill(0xFF0000, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            grcollision.drawRect(x, y, width, height);
            grcollision.endFill();
            // 添加字符串值
            Reflect.setField(jsoncollision, "type", type);
            Reflect.setField(jsoncollision, "x", x * scaleX);
            Reflect.setField(jsoncollision, "y", y * scaleY);
            Reflect.setField(jsoncollision, "width", width * scaleX);
            Reflect.setField(jsoncollision, "height", height * scaleY);


            // 添加字符串值
            Reflect.setField(jsoncollision2, "type", type);
            Reflect.setField(jsoncollision2, "x", x);
            Reflect.setField(jsoncollision2, "y", y);
            Reflect.setField(jsoncollision2, "width", width);
            Reflect.setField(jsoncollision2, "height", height);


            grcollision.scaleX = scaleX;
            grcollision.scaleY = scaleY;

           // trace("jsoncollision:"+jsoncollision);
        }else if(type == 3){
            grcollision = new h2d.Graphics(_vbox);
            grcollision.beginFill(0xFF0000, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            var xx = 0 -(x/2);
            var yy = 0 -(x/2);
            grcollision.drawRect(xx, yy, x, x);
            grcollision.endFill();
            Reflect.setField(jsoncollision, "type", type);
            Reflect.setField(jsoncollision, "x", xx  * scaleX);
            Reflect.setField(jsoncollision, "y", yy  * scaleY);
            Reflect.setField(jsoncollision, "width", x  * scaleX);
            Reflect.setField(jsoncollision, "height", x  * scaleY);

            Reflect.setField(jsoncollision2, "type", type);
            Reflect.setField(jsoncollision2, "x", xx);
            Reflect.setField(jsoncollision2, "y", yy);
            Reflect.setField(jsoncollision2, "width", x);
            Reflect.setField(jsoncollision2, "height", x);

            grcollision.scaleX = scaleX;
            grcollision.scaleY = scaleY;

        }else if(type == 4){



            grcollision = new h2d.Graphics(_vbox);
            grcollision.beginFill(0xFF0000, 0.5);

            // var graphics:h2d.Graphics = new h2d.Graphics();
            // graphics.beginFill(0xFF0000, 1.0);
            

            grcollision.moveTo(vertices[0].x, vertices[0].y); // 将画笔移动到多边形的起始点

            for (i in 1...vertices.length) {
                grcollision.lineTo(vertices[i].x, vertices[i].y); // 画一条线连接到下一个顶点
            }
            
            // graphics.lineTo(point5X, point5Y);
            // graphics.lineTo(point6X, point6Y);
            
            grcollision.endFill();

             // 添加字符串值
             Reflect.setField(jsoncollision, "type", type);
             Reflect.setField(jsoncollision, "x", x * scaleX);
             Reflect.setField(jsoncollision, "y", y * scaleY);
             Reflect.setField(jsoncollision, "width", width * scaleX);
             Reflect.setField(jsoncollision, "height", height * scaleY);
             Reflect.setField(jsoncollision, "polygon", vertices);
 
 
             // 添加字符串值
             Reflect.setField(jsoncollision2, "type", type);
             Reflect.setField(jsoncollision2, "x", x);
             Reflect.setField(jsoncollision2, "y", y);
             Reflect.setField(jsoncollision2, "width", width);
             Reflect.setField(jsoncollision2, "height", height);
             Reflect.setField(jsoncollision2, "polygon", vertices);

             //trace(jsoncollision2);

            grcollision.scaleX = scaleX;
            grcollision.scaleY = scaleY;
        }

        //setChildIndex(object2, getChildIndex(object1) + 1);

        

        //jsoncollision2 = jsoncollision;

       // trace("jsoncollision:"+jsoncollision);
        
    }

    public   function Loop() {
        if(anim != null){
            anim.loop = false;
            var defa = defaultAnimationMap.get(defauldirction + "");
            //trace("调用Loop:" + defa);
                            
            if(defa != null){
                
                anim.play(defa.data);
                anim.degreesList = defa.rotate;
                anim.speed = defa.rate;
                anim.loop = defa.carousel;
                setOverturn();
                //anim.scaleX = scaleX;
                //anim.scaleY = scaleY;

                setRoleJSTile(defa);
                //anim.x = 200;
                //trace("anim.loop:3"+anim.loop);
                //trace("anim.loop1:"+defa);

            }
            //nameAction = "";
            //anim.pause = true;
            //trace("anim.loop1:"+defauldirction);
            //trace("anim.loop1:");
        }else{
            //trace("anim.loop2:"+anim.loop);
        }
           
        
        
    }
    public function PlayAnimationName(name:String):String{
        PlayName = name;
        var ss = arrTile1.get(name+PlayDirction);
        if(ss == null){
            //trace("ss == null");
        }else{
            if(anim == null){
                anim = new AnimBase(null,_vbox);
                anim.play(ss.data);
                anim.degreesList = ss.rotate;
                anim.speed = ss.rate;
                anim.loop = ss.carousel;
                setOverturn();
                //anim.scaleX = scaleX;
                //anim.scaleY = scaleY;
                setRoleJSTile(ss);
                //anim.x = 200;
                anim.onAnimEnd = function (){
                    if(!ss.carousel){
                        if(Std.int(anim.currentFrame) == anim.frames.length){
                        var defa = defaultAnimationMap.get(ss.direction);
                        
                        if(defa != null){
                            
                            anim.play(defa.data);
                            anim.degreesList = defa.rotate;
                            anim.speed = defa.rate;
                            anim.loop = defa.carousel;
                            setOverturn();
                            //anim.scaleX = scaleX;
                            //anim.scaleY = scaleY;
                            //anim.x = 200;
                            setRoleJSTile(defa);

                        }
                        }
                        
                    }

                };
               
                
            }else{
                anim.play(ss.data, 0);
                anim.degreesList = ss.rotate;
                anim.speed = ss.rate;
                anim.loop = ss.carousel;
                setOverturn();
                //anim.scaleX = scaleX;
               // anim.scaleY = scaleY;
                setRoleJSTile(ss);
                //anim.x = 200;
                anim.onAnimEnd = function (){
                    if(!ss.carousel){
                        if(Std.int(anim.currentFrame) == anim.frames.length){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setOverturn();
                               // anim.scaleX = scaleX;
                                //anim.scaleY = scaleY;
                                //anim.x = 200;
                                setRoleJSTile(defa);

                            }
                        }
                    }

                };
               
            }

        }
                

        return PlayDirction;
    }
    public function PlayAnimationDirection(direction:String):String{
        PlayDirction = direction;
        var ss = arrTile1.get(PlayName+direction);
        if(ss == null){
            //trace("ss == null");
        }else{
            if(anim == null){
                anim = new AnimBase(null,_vbox);
                anim.play(ss.data);
                anim.degreesList = ss.rotate;
                anim.speed = ss.rate;
                anim.loop = ss.carousel;
                setOverturn();
                //anim.scaleX = scaleX;
                //anim.scaleY = scaleY;
                setRoleJSTile(ss);
                //anim.x = 200;
                anim.onAnimEnd = function (){
                    if(!ss.carousel){
                        if(Std.int(anim.currentFrame) == anim.frames.length){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setOverturn();
                               // anim.scaleX = scaleX;
                               // anim.scaleY = scaleY;
                                //anim.x = 200;
                                setRoleJSTile(defa);

                            }
                        }
                    }

                };
               
                
            }else{
                anim.play(ss.data, 0);
                anim.degreesList = ss.rotate;
                anim.speed = ss.rate;
                anim.loop = ss.carousel;
                setOverturn();
                //anim.scaleX = scaleX;
                //anim.scaleY = scaleY;
                setRoleJSTile(ss);
                //anim.x = 200;
                anim.onAnimEnd = function (){
                    if(!ss.carousel){
                        if(Std.int(anim.currentFrame) == anim.frames.length){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setOverturn();
                                //anim.scaleX = scaleX;
                               // anim.scaleY = scaleY;
                                //anim.x = 200;
                                setRoleJSTile(defa);
                            }
                        }
                    }

                };
               
            }

        }

        return PlayName;
    }

    public function PlayAnimation(name:String,direction:String,atFrame:Float = 1){



        assets.start(function(f) {
            if (f == 1) {
                // for (k in arrTile.keys()) {
                //     trace(k);
                    
                // }

                
                var ss = arrTile1.get(name+direction);
                //trace("name:"+name + " " + direction);
                if(ss == null){
                    //trace("ss == null");
                    return;
                }
                //trace("ss"+ss);
                // anim = null;
                // anim = new h2d.Anim(ss,s2d);
                // //anim.x = 200;
                if(anim == null){
                    anim = new AnimBase(null,_vbox);
                    anim.play(ss.data);
                    anim.degreesList = ss.rotate;
                    anim.speed = ss.rate;
                    anim.loop = ss.carousel;
                    setOverturn();
                    //anim.scaleX = scaleX;
                    //anim.scaleY = scaleY;
                    setRoleJSTile(ss);
                    //anim.x = 200;
                    anim.onAnimEnd = function (){
                        if(!ss.carousel){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setOverturn();
                                //anim.scaleX = scaleX;
                                //anim.scaleY = scaleY;
                                //anim.x = 200;
    
                                setRoleJSTile(defa);
                            }
                        }

                    };
                   
                    
                }else{
                    anim.play(ss.data, atFrame);
                    anim.degreesList = ss.rotate;
                    anim.speed = ss.rate;
                    anim.loop = ss.carousel;
                    setOverturn();
                    //anim.scaleX = scaleX;
                    //anim.scaleY = scaleY;
                    setRoleJSTile(ss);
                    //anim.x = 200;
                    anim.onAnimEnd = function (){
                        if(!ss.carousel){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setOverturn();
                                //anim.scaleX = scaleX;
                                //anim.scaleY = scaleY;
                                //anim.x = 200;
                                setRoleJSTile(defa);
                            }
                        }

                    };
                   
                }
                
                
              
                
            }
        });

        
    

    }

    public function PlayAnimation1(name:String,atFrame:Float = 1){
        assets.start(function(f) {
            if (f == 1) {
                // for (k in arrTile.keys()) {
                //     trace(k);
                    
                // }
                var ss = arrTile1.get(name);
                if(ss == null){
                    //trace("ss == null");
                    return;
                }
                // anim = null;
                // anim = new h2d.Anim(ss,s2d);
                // //anim.x = 200;

                

                // anim.onAnimEnd = function (){
                //     trace(anim.onAnimEnd + "onAnimEnd");

                // };

                if(anim == null){
                    anim = new AnimBase(null,_vbox);
                    anim.play(ss.data, atFrame);
                    anim.degreesList = ss.rotate;
                    //anim.x = 200;
                    anim.speed = ss.rate;
                    anim.loop = ss.carousel;
                    setOverturn();
                    //anim.scaleX = scaleX;
                    //anim.scaleY = scaleY;
                    setRoleJSTile(ss);
                    anim.onAnimEnd = function (){
                        if(!ss.carousel){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setOverturn();
                                //anim.scaleX = scaleX;
                               // anim.scaleY = scaleY;
                                //anim.x = 200;
                                setRoleJSTile(defa);
                            }
                        }

                    };
                    //anim.loop = false ;
                    
                }else{
                    //trace("aaaa");
                    anim.play(ss.data, atFrame);
                    anim.degreesList = ss.rotate;
                    //anim.x = 200;
                    anim.speed = ss.rate;
                    anim.loop = ss.carousel;
                    setOverturn();
                    //anim.scaleX = scaleX;
                   // anim.scaleY = scaleY;
                    setRoleJSTile(ss);
                    anim.onAnimEnd = function (){
                        if(!ss.carousel){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setOverturn();
                                //anim.scaleX = scaleX;
                                //anim.scaleY = scaleY;
                                //anim.x = 200;
                                setRoleJSTile(defa);
    
                            }
                        }

                    };
                    //anim.loop = false;
                }
                
                
                
            }
        });

        
    

    }

    public function setUrl(url:String,?param:String = "default",?param1:String = "default"){
        this.url = url;
        this.path = url;
        this.param = param;
        this.param1 = param1;
    }

    public function unloadAll(){
        assets.unloadAll();
        s2d.removeChild(anim);
        anim = null;
    }
   
    public function Callback():Int{
        return this.callback;
    }
        
   
    public function scale(x:Float,y:Float){
        anim.scaleX = x;
        anim.scaleY = y;
        this.scaleX = x;
        this.scaleY = y;


        if(grmask != null ){
            grmask.scaleX = x;
            grmask.scaleY = y;
        }

        if(grcollision != null ){
            grcollision.scaleX = x;
            grcollision.scaleY = y;
        }
        


      


        // 判断是否为空对象
        //var isEmptyObject = Reflect.compareMethods(jsoncollision, {});
       // trace("jsoncollision:"+isEmptyObject);

       //var isEmptyObject = Reflect.fields(jsoncollision).length == 0;


       var isEmptyObjectdata = Reflect.fields(jsoncollisiondata).length == 0;

       var isEmptyObjectMaskdata = Reflect.fields(jsonMaskdata).length == 0;
      // var isEmptyObject = jsoncollision.keys().length == 0;

        //trace("length:"+isEmptyObject);

        if(!isEmptyObjectdata){
            
            jsoncollisiondata = [];
            for(data in jsoncollisiondata1){
                var polygon: Array<{ x: Float, y: Float }> = [];
                for (i in 0...data.polygon.length) {
                    var newPoint = {
                        x: data.polygon[i].x * scaleX,
                        y: data.polygon[i].y * scaleX
                    };
                    polygon.push(newPoint);
                }

                var newObj = {
                    "collision": data.collision,
                    "x": data.x * scaleX,
                    "y": data.y * scaleY,
                    "width": data.width * scaleX,
                    "height": data.height * scaleY,
                    "polygon": polygon
                };

                jsoncollisiondata.push(newObj);
                //Reflect.setField(data, "polygon", polygon);
            }


            
            //trace("jsoncollisiondata:"+jsoncollisiondata);
        }

        if(!isEmptyObjectMaskdata){
            
            jsonMaskdata = [];
            for(data in jsonMaskdata2){
                var polygon: Array<{ x: Float, y: Float }> = [];
                for (i in 0...data.polygon.length) {
                    var newPoint = {
                        x: data.polygon[i].x * scaleX,
                        y: data.polygon[i].y * scaleX
                    };
                    polygon.push(newPoint);
                }

                var newObj = {
                    "mask": data.mask,
                    "x": data.x * scaleX,
                    "y": data.y * scaleY,
                    "width": data.width * scaleX,
                    "height": data.height * scaleY,
                    "polygon": polygon
                };

                jsonMaskdata.push(newObj);
                //Reflect.setField(data, "polygon", polygon);
            }


            
            //trace("jsoncollisiondata:"+jsoncollisiondata);
        }

        
    }


    var roleEntityType = 0;

    public function setRoleEntity(url:String,?param:String = "default",?param1:String = "default"){

        roleEntityType = 1;
        player = new object.RoleEntity(url, param, param1, _vbox);
        player.x = 200;
        player.y = 300;
        //player.alpha = 0.1;
        keyboard.clearKeyBind();

    

        

    }

    var spineEntityType = 0;

    public function setSpineEntity(url:String,?param:String = "default",?param1:String = "default"){

        spineEntityType = 1;
       // trace("url111:"+url);
        spinePlayer = new object.SpineEntity(url, param, param1, _vbox);
        //spinePlayer.x = 100;
        //spinePlayer.y = 500;

      

        //  var grcollisions:Graphics = new h2d.Graphics(_vbox);
            
        // grcollisions.beginFill(0xFF0000, 0.5);
        // grcollisions.drawRect(-15.27,-67.25,35,67.58);
        // grcollisions.endFill();


        keyboard.clearKeyBind();

    }

    
   
    
    public function restoresRole(){
        roleEntityType = 0;
        keyboard.Assignment();
        _vbox.removeChild(player);
    }

    public function restoresSpine(){
        spineEntityType = 0;
        keyboard.Assignment();
        _vbox.removeChild(spinePlayer);
    }

    //判断是否碰撞
    public function isRoleEntity1():Bool{


       

        for (data in jsoncollisiondata) {
            //trace("data.collision:"+data);
            if (data.collision == 1 || data.collision == 2 || data.collision == 3) {
                if (
                    (player.x + player.getpositionX()) + player.getWidth() >= data.x &&
                    player.x + player.getpositionX() <= data.x + data.width &&
                    player.y + player.getpositionY() + player.getHeight() >= data.y &&
                    player.y + player.getpositionY() <= data.y + data.height
                ){

                    return true;
                }
                
            } else {
                //trace("2");
                if (checkRoleEntity(data.polygon)) {
                    return true;
                }

                
            }
        }
    
        return false;

        
    }
    //判断是否隐藏
    public function isRoleEntity2():Bool{


       

        for (data in jsonMaskdata) {
            //trace("data.collision:"+data);
            if (data.mask == 1 || data.mask == 2) {
                if (
                    (player.x + player.getpositionX()) + player.getWidth() >= data.x &&
                    player.x + player.getpositionX() <= data.x + data.width &&
                    player.y + player.getpositionY() + player.getHeight() >= data.y &&
                    player.y + player.getpositionY() <= data.y + data.height
                ){

                    return true;
                }
                
            } else {
                //trace("2");
                if (checkRoleEntity(data.polygon)) {
                    return true;
                }

                
            }
        }
    
        return false;

        
    }

    public function isRoleEntity():Bool{

        //player.getHeight()
        if(jsoncollision.type == 1 || jsoncollision.type == 2 || jsoncollision.type == 3){ 
            return ((player.x + player.getpositionX()) + player.getWidth() >= jsoncollision.x &&
            player.x  + player.getpositionX() <= jsoncollision.x + jsoncollision.width &&
            player.y + player.getpositionY() + player.getHeight() >= jsoncollision.y &&
            player.y + player.getpositionY() <= jsoncollision.y + jsoncollision.height);
        }else{
            return checkRoleEntity(jsoncollision.polygon);
        }

        // return ((player.x + player.getpositionX()) + player.getWidth() >= jsoncollision.x &&
        //     player.x  + player.getpositionX() <= jsoncollision.x + jsoncollision.width &&
        //     player.y + player.getpositionY() + player.getHeight() >= jsoncollision.y &&
        //     player.y + player.getpositionY() <= jsoncollision.y + jsoncollision.height);
        // return false;
    }

    function checkRoleEntity(data : Array<{ x: Float, y: Float }>): Bool {
        var rectangleLeft = player.x + player.getpositionX();
        var rectangleRight = (player.x + player.getpositionX()) + player.getWidth();
        var rectangleTop = player.y + player.getpositionY();
        var rectangleBottom =  (player.y + player.getpositionY()) + player.getHeight();

        var num:Int = data.length;
    
        for (i in 0...data.length) {
            var currentVertex = data[i];
            var nextVertex = data[(i + 1) % num];
    
            var edgeLeft = Math.min(currentVertex.x, nextVertex.x);
            var edgeRight = Math.max(currentVertex.x, nextVertex.x);
            var edgeTop = Math.min(currentVertex.y, nextVertex.y);
            var edgeBottom = Math.max(currentVertex.y, nextVertex.y);
    
            if (rectangleRight >= edgeLeft && rectangleLeft <= edgeRight &&
                rectangleBottom >= edgeTop && rectangleTop <= edgeBottom) {
                // 矩形与边界相交，进行进一步检测
                var collision = checkLineRectangleCollision1(currentVertex, nextVertex, rectangleLeft, rectangleTop, rectangleRight, rectangleBottom);
                if (collision) {
                    // 碰撞发生
                    return true;
                }
            }
        }
    
        // 未发生碰撞
        return false;
    }
    
    function checkLineRectangleCollision1(lineStart: { x: Float, y: Float }, lineEnd: { x: Float, y: Float }, rectLeft: Float, rectTop: Float, rectRight: Float, rectBottom: Float): Bool {
        // 检查线段与矩形相交
        var lineLeft = Math.min(lineStart.x, lineEnd.x);
        var lineRight = Math.max(lineStart.x, lineEnd.x);
        var lineTop = Math.min(lineStart.y, lineEnd.y);
        var lineBottom = Math.max(lineStart.y, lineEnd.y);
    
        if (lineRight < rectLeft || lineLeft > rectRight || lineBottom < rectTop || lineTop > rectBottom) {
            // 线段与矩形不相交
            return false;
        }
    
        // 计算线段的斜率
        var lineSlope = (lineEnd.y - lineStart.y) / (lineEnd.x - lineStart.x);
    
        if (Math.abs(lineSlope) < 1) {
            // 如果斜率的绝对值小于1，使用水平边与线段的相交检测
            var lineYatLeft = lineStart.y + (rectLeft - lineStart.x) * lineSlope;
            var lineYatRight = lineStart.y + (rectRight - lineStart.x) * lineSlope;
    
            if ((lineYatLeft >= rectTop && lineYatLeft <= rectBottom) || (lineYatRight >= rectTop && lineYatRight <= rectBottom)) {
                // 线段与矩形相交
                return true;
            }
        } else {
            // 如果斜率的绝对值大于等于1，使用垂直边与线段的相交检测
            var lineXatTop = lineStart.x + (rectTop - lineStart.y) / lineSlope;
            var lineXatBottom = lineStart.x + (rectBottom - lineStart.y) / lineSlope;
    
            if ((lineXatTop >= rectLeft && lineXatTop <= rectRight) || (lineXatBottom >= rectLeft && lineXatBottom <= rectRight)) {
                // 线段与矩形相交
                return true;
            }
        }
    
        // 线段与矩形不相交
        return false;
    }

   
    //移动Role
    public function updateplayer(dt : Float) {
        // 检查键盘输入并更新相机位置
        var playname:String = "";
        var playdir:String = "";
        var iskeyDown:Int = 0;

        
       // trace("playerx:"+(player.x ) +"  playery:"+(player.y )+" getpositionX: "+player.getpositionX() +" getpositionY: "+player.getpositionY());
        
        if (hxd.Key.isDown(hxd.Key.W)) {
            if(roleEntityType == 0) return;

          


           // trace("jsoncollisionx:"+jsoncollision.x +"  jsoncollisiony:"+jsoncollision.y +" jsoncollisionWidth: "+jsoncollision.width +" jsoncollisionHeight: "+jsoncollision.height);

        

            player.y -= moveSpeed;
           
            //trace("playerx:"+(player.x ) +"  playery:"+(player.y )+" getpositionX: "+player.getpositionX() +" getpositionY: "+player.getpositionY());
            //trace("is:"+isRoleEntity1());
            if (isRoleEntity1()) {
               // trace("++++++++");
                player.y += moveSpeed;
                
            }
            if (isRoleEntity2()) {
                // trace("++++++++");
                 player.alpha = 0.2;
                 
            }else{
                player.alpha = 1;
            
            }
        }
        if (hxd.Key.isDown(hxd.Key.S)) {
            if(roleEntityType == 0) return;
            
           
           // player.y = player.y + 5;

           player.y += moveSpeed;
           //trace("playerx:"+(player.x ) +"  playery:"+(player.y )+" getpositionX: "+player.getpositionX() +" getpositionY: "+player.getpositionY());
            if (isRoleEntity1()) {
                player.y -= moveSpeed;
               
            }
            if (isRoleEntity2()) {
                // trace("++++++++");
                 player.alpha = 0.2;
                 
            }else{
                player.alpha = 1;
            
            }
        }
        if (hxd.Key.isDown(hxd.Key.A)) {
            if(roleEntityType == 0) return;
          
           
            //player.PlayAnimation("pao", "7");
            //player.getWidth();
            //player.x = player.x - 5;
            player.x -= moveSpeed;
           // trace("playerx:"+(player.x ) +"  playery:"+(player.y )+" getpositionX: "+player.getpositionX() +" getpositionY: "+player.getpositionY());
            if (isRoleEntity1()) {
                player.x += moveSpeed;
                
            }
            if (isRoleEntity2()) {
                // trace("++++++++");
                 player.alpha = 0.2;
                 
            }else{
                player.alpha = 1;
            
            }
        }
        if (hxd.Key.isDown(hxd.Key.D)) {
            if(roleEntityType == 0) return;
            
           
            //player.x = player.x + 5;
            player.x += moveSpeed;
            //trace("playerx:"+(player.x ) +"  playery:"+(player.y )+" getpositionX: "+player.getpositionX() +" getpositionY: "+player.getpositionY());
            if (isRoleEntity1()) {
                player.x -= moveSpeed;
               
            }
            if (isRoleEntity2()) {
                // trace("++++++++");
                 player.alpha = 0.2;
                 
            }else{
                player.alpha = 1;
            
            }
        }

       



     }


     //移动Spine
    public function updateSpine(dt : Float) {
        // 检查键盘输入并更新相机位置
        var playname:String = "";
        var playdir:String = "";
        var iskeyDown:Int = 0;

        // if(player!= null){
            

        // }
        
        if (hxd.Key.isDown(hxd.Key.W)) {
            if(spineEntityType == 0) return;

            trace("spinePlayer:"+spinePlayer.getSize());


            trace("width:"+spinePlayer.getSize().width+",height:"+spinePlayer.getSize().height+",x:"+spinePlayer.x+",y:"+spinePlayer.y);

            
        

           spinePlayer.y -= moveSpeed;
            // if (isRoleEntity()) {
            //     spinePlayer.y += moveSpeed;
                
            // }
        }
        if (hxd.Key.isDown(hxd.Key.S)) {
            if(spineEntityType == 0) return;
            
           

           spinePlayer.y += moveSpeed;
            // if (isRoleEntity()) {
            //     spinePlayer.y -= moveSpeed;
               
            // }
        }
        if (hxd.Key.isDown(hxd.Key.A)) {
            if(spineEntityType == 0) return;
          
           
            spinePlayer.x -= moveSpeed;
            // if (isRoleEntity()) {
            //     spinePlayer.x += moveSpeed;
                
            // }
        }
        if (hxd.Key.isDown(hxd.Key.D)) {
            if(spineEntityType == 0) return;
            
           
            spinePlayer.x += moveSpeed;
            // if (isRoleEntity()) {
            //     spinePlayer.x -= moveSpeed;
               
            // }
        }

       



     }




    
    



    public function isCollision():Bool{
        return (img.x + img.width >= jsoncollision.x &&
            img.x <= jsoncollision.x + jsoncollision.width &&
            img.y + img.height >= jsoncollision.y &&
            img.y <= jsoncollision.y + jsoncollision.height);
    }

    

    var rectLeft:Float = 0; // 长方形的左边界
    var rectRight:Float = 0; // 长方形的右边界
    var rectTop:Float = 0; // 长方形的上边界
    var rectBottom:Float = 0; // 长方形的下边界
    
    var moveSpeed:Float = 1; // 移动速度



    public function updates(dt : Float) {
        //if(imgType == 0) return;

        if(roleEntityType == 0) return;


       // var newX = player.x + player.getpositionX();
        //var newY = player.y  + player.getpositionX();

        

        if (hxd.Key.isDown(hxd.Key.W)) {
            //if(imgType == 0) return;

            
            player.y -= moveSpeed;
           // if (isCollision()) {
           

            //newY -= moveSpeed;
        }
        if (hxd.Key.isDown(hxd.Key.S)) {
            //if(imgType == 0) return;
            player.y += moveSpeed;
           
            //newY += moveSpeed;
        }
        if (hxd.Key.isDown(hxd.Key.A)) {
            //if(imgType == 0) return;
            player.x -= moveSpeed;
           
            //newX -= moveSpeed;
        }
        if (hxd.Key.isDown(hxd.Key.D)) {
            //if(imgType == 0) return;
            player.x += moveSpeed;
            
            //newX += moveSpeed;
        }

        
    }

   





    override function init() {
        super.init();





       
        hxd.res.Loader.currentInstance = new Loader(new FileSystem());
        AssetsBuilder.bindAssets(assets);
       // this.url = "I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\5.rule";

        setinit(this.url,this.param,this.param1);
        


        
        

        // scene1 = createScene(TestUI);
        // s2d.addChild(scene1);
        
      

    }
    static function main() {
        #if mac_run
        new MainJS('res/img/model.fbx');
        #else
       //var a = new RoleApp();
    //a.setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\5.rule');
       //a.setUrl('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\5.rule');
        #end
    }
}
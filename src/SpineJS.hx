import spine.Skeleton;
import format.abc.Data.ABCData;
import haxe.Json;
import hxPEngine.ui.util.StringUtils;
import hxd.res.Loader;
import hxPEngine.ui.display.Spine;
import hxPEngine.ui.util.AssetsBuilder;
import hxPEngine.ui.util.Assets;
import hxd.fmt.pak.FileSystem;
@:expose
class SpineJS {
    static var mainApp:SpineApp = null;
    public static function load(url:String) {
        trace("url:"+url);
        if(mainApp == null) {
            mainApp = new SpineApp();
            mainApp.setUrl(url);
            //trace("加载");


        }else{
            //mainApp = new RoleApp();
            mainApp.setinit(url);
            //trace("重载");
        }
        
    }
    public static function getAnimations():Array<String>{
        return mainApp.getAnimations();
    }
    public static function getSkins():Array<String>{
        return mainApp.getSkins();
    }
    public static function setSkinByName(name:String){
        mainApp.setSkinByName(name);
    }
    public static function scale(x:Float,y:Float){
        mainApp.scale(x,y);
    }
    public static function setXY(x:Float,y:Float){
        mainApp.setXY(x,y);
    }

    public static function Callback():Int{
        return mainApp.Callback();
    }

    

    public static function play(name:String){
        mainApp.play(name);
    }
    public static function Loop(loop:Bool){
        mainApp.Loop(loop);
    }


    
    


    static function main() {
       // SpineJS.load('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\spine.spines');

    }
}


class SpineApp extends hxd.App {
    override function update(dt : Float) {
        // trace("update");
        #if hl
       // hxPEngine.ui.util.hl.Thread.loop( );
        #end
        //scene1.setFps(hxd.Timer.fps(),getCarmerInfo(),getfbxListPos());
     }
    var url:String;
    var path:String;
    var assets:Assets = new Assets();
    var spine:Spine;
    var loop:Bool = true;

    var name:String;

    var callback:Int = 0;


    var _vbox:h2d.Object;
    var postionLine:h2d.Graphics;

    public function setUrl(url:String){
        this.url = url;
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


        this.callback = 0;
        this.url = url;
        assets.loadFile(StringTools.replace(this.url, "\\", "/"));
        this.path = this.url;

        // postionLine = new h2d.Graphics(s2d);
        // postionLine.beginFill(0xFF0000, 0.5);

        // postionLine.drawRect(0, 1080/2,1920,1);
        // postionLine.drawRect(1920/2, 0, 1, 1080);

        // postionLine.endFill();


        // _vbox = new h2d.Object(s2d);

        // _vbox.x = 1920/2;
        // _vbox.y = 1080/2;


        // trace("url:"+url);
        // assets.loadFile("res/role/image0.png");
        // assets.loadFile("res/role/image1.png");
        // assets.loadFile("res/role/image2.png");
        // assets.loadFile("res/role/image3.png");
        // assets.loadFile("res/role/image4.png");
        // assets.loadFile("res/role/image5.png");
        // assets.loadSpineAtlas(["res/role/guaiA11a_2/guaiA11a.png"], "res/role/guaiA11a_2/guaiA11a.atlas");
        // assets.loadFile("res/role/guaiA11a_2/guaiA11a.json");
        assets.start(function(f) {
           //     var sss = assets.hasTypeAssets(BITMAP_TILE,"btn_LvSe");


   
        
           trace("f:"+f);
           if(f==1) {
                if(spine!=null){
                    s2d.removeChild(spine);
                }

                var aa= haxe.Json.stringify(assets.getJson(getName()));
                
                

                var jsonObject = Json.parse(aa);

                //trace("url:"+this.url);

                trace("jsonObject:"+aa);

                var pngs:Array<String> = jsonObject.pngs;
                // var pngs1:Array<String> = new Array<String>();
                // this.path = this.path + ".material\\";
                // this.path = StringTools.replace(this.path, "\\", "/");
                // for (i in pngs) {
                //     i = this.path + i;
                //     //i = StringTools.replace(i, "\\", "/");
                //     pngs1.push(i);
                // }
                //trace("jsonObject:"+pngs1);

                trace("jsonObject:"+pngs);
                //s2d.addChild(spine);
                
                
                
                

                // assets.loadSpineAtlas(pngs1, this.path+jsonObject.atlas);
                // assets.loadFile(this.path+jsonObject.json);

                assets.loadSpineAtlas(pngs, jsonObject.atlas);
                assets.loadFile(jsonObject.json);
                assets.start(function(f) {
                    if(f==1) {
                        spine = assets.createSpine(getName1(jsonObject.atlas), getName1(jsonObject.json));
                        loop = jsonObject.loop;
                        //spine.width = 300;
                        //spine.height = 300;
                        
                        spine.scaleX = -0.05;
                        spine.scaleY = 0.05;

                        

                       // spine.skeleton.setScaleX(1);

                        //trace("skeleton:"+spine.skeleton.data);
                       
                        s2d.addChild(spine);
                        //spine.skeleton.setSkinByName("1");
                        //trace("defaultSkin:"+spine.skeleton.getData().bones);
                        
                       
                        //spine.play("std2");

                        this.callback = 1;
                        // spine.x = 50;
                        // spine.y = 0;
                        spine.x = jsonObject.positionX;
                        spine.y = jsonObject.positionY;
                        //trace("spine:"+spine.animationState.getData().getSkeletonData().getAnimations());
                    }
                });
               



               // var t1 = assets.getBitmapDataTile("image0");
               // var t2 = assets.getBitmapDataTile("image1");
               // var t3 = assets.getBitmapDataTile("image2");
               // var t4 = assets.getBitmapDataTile("image3");
               // var t5 = assets.getBitmapDataTile("image4");
               // var t6 = assets.getBitmapDataTile("image5");
              // var anim = new h2d.Anim([t1,t2,t3,t4,t5,t6],s2d); 
            //   var spine:Spine = assets.createSpine("guaiA11a", "guaiA11a");
            //    //this.addChild(spine);
            //    s2d.addChild(spine);
            //    spine.play("walk");
            //    spine.x = 200;
            //    spine.y = 200;
               
           }
        });

    }

    public function getAnimations():Array<String>{
        var animations:Array<String> = new Array<String>();
        

        
        for (i in spine.animationState.getData().getSkeletonData().getAnimations()) {
            //trace(i.toString());
            animations.push(i.toString());
        }
        return animations;
    }
    public function getSkins():Array<String>{
        var skins:Array<String> = new Array<String>();
        

        
        for (i in spine.skeleton.getData().getSkins()) {
            //trace(i.toString());
            skins.push(i.toString());
        }
        return skins;
    }
    //播放动画
    public function play(name:String){
        this.name = name;
        spine.play(name,loop);
        //spine.animationState.loop = loop;
    }

    public function Loop(loop:Bool){
        //trace("loop:"+loop);
        //trace("this.name:"+this.name);
        this.loop = loop;
        //spine.play(this.name,this.loop);
        spine.animationState.setAnimationByName(0, this.name, this.loop);
        //trace("loop1:"+loop);
        //trace("this.name1:"+this.name);
    }

    //设置皮肤
    public function setSkinByName(name:String){
        //s2d.removeChild(spine);

        //setSkin
        //spine.skeleton.setSkin(spine.skeleton.getData().defaultSkin);
        
        //spine.skeleton.setSkinByName(spine.skeleton.getData().defaultSkin.name);
        //spine.skeleton.updateWorldTransform();
        spine.skeleton.setSkinByName(name);
        spine.skeleton.setSlotsToSetupPose();
        
        //spine.skeleton.updateCache();

        //trace("skin:"+spine.skeleton.skin);
        //updateCache (	)
        //s2d.addChild(spine);
    }
    public function scale(x:Float,y:Float){
        spine.scaleX = x;
        spine.scaleY = y;
    }
    public function setXY(x:Float,y:Float){
        spine.x = x;
        spine.y = y;
    }
    public function Callback():Int{
        return this.callback;
    }

    

    override function init() {
        super.init();
        //var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
       // tf.text = "Hello Hashlink !";
        // var assets = new Assets();
		
		// AssetsBuilder.bindAssets(assets);

        hxd.res.Loader.currentInstance = new Loader(new FileSystem());
        AssetsBuilder.bindAssets(assets);
       // this.url = "I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\5.rule";

        setinit(this.url);

      
    }
    static function main() {

       // new SpineJS();
    }
}
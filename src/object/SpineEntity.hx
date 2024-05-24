package object;

import h2d.Graphics;
import hxPEngine.ui.display.Spine;
import hxPEngine.ui.util.Assets;
//import hxPEngine.ui.util.StringUtils;
import haxe.Json;

class SpineEntity extends h2d.Object {
    var url:String;
    var path:String;
    var assets:Assets;
    var spine:Spine;
    var loop:Bool = true;


    var grcollision:Graphics; 

    public function new(url:String, ?skinsName:String = "default", ?namePlay:String = "default", ?parent : h2d.Object) {
        super(parent);

        //trace("url:"+url);
        this.url = url;
        this.assets = new Assets();
        this.name = this.getName(url);
        assets.loadFile(StringTools.replace(this.url, "\\", "/"));
        assets.start(function(f) {
            trace("f:"+f);
            if(f==1) {
                 if(spine!=null){
                    parent.removeChild(spine);
                 }

                 //trace("assets:"+assets.getJson(this.name));
 
                 var aa= haxe.Json.stringify(assets.getJson(this.name));
                 
                 
 
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
                         spine.scaleX = jsonObject.scaleX;
                         spine.scaleY = jsonObject.scaleY;
                         //trace("skeleton:"+spine.skeleton.data);
                        
                         this.addChild(spine);

                        //trace("spine:"+spine.getSize().width);
                         trace("spine:"+spine.getBounds());

                         var width = spine.getBounds().xMax * spine.scaleX;
                         var height = spine.getBounds().yMax * spine.scaleY;
                         trace("spine:width :"+width+ ",hieth:"+height);
                         //spine.skeleton.setSkinByName("1");
                         //trace("defaultSkin:"+spine.skeleton.getData().bones);

                         grcollision = new h2d.Graphics(this);
            
                         grcollision.beginFill(0xFF0000, 0.5);
                        // grcollision.drawRect(-15.27,-67.25,35,67.58);
                         grcollision.drawRect(-30.54,-134.5,70,135.2);
                         grcollision.endFill();
                         
                        
                         //spine.play("std2");
 
                         //this.callback = 1;
                         
                         //spine.x = jsonObject.positionX;
                         //spine.y = jsonObject.positionY;
                         //trace("spine:"+spine.animationState.getData().getSkeletonData().getAnimations());
                     }
                 });
                
 
 
 
                
            }
         });

    }

    /**
	 * 获取字符串的名字，不带路径、扩展名
	 * @param data 
	 * @return String
	 */
	public  function getName(source:String):String {
		var data = source;
		if (data == null)
			return data;
		data = data.substr(data.lastIndexOf("/") + 1);
		if (data.indexOf(".") != -1)
			data = data.substr(0, data.lastIndexOf("."));
		else if (source.indexOf("http") == 0)
			return source;
		return data;
	}
    /**
	 * 获取字符串的名字，不带路径、扩展名
	 * @param data 
	 * @return String
	 */
	public  function getName1(source:String):String {
		var data = source;
		if (data == null)
			return data;
		data = data.substr(data.lastIndexOf("/") + 1);
		if (data.indexOf(".") != -1)
			data = data.substr(0, data.lastIndexOf("."));
		else if (source.indexOf("http") == 0)
			return source;
		return data;
	}
    // public function getName(): String{
    //     var path = StringTools.replace(this.url, "\\", "/");
    //     var fileName = StringUtils.getName(path);
    //     return fileName;
    // }
    // public function getName1(string:String): String{
    //     var path = StringTools.replace(string, "\\", "/");
    //     var fileName = StringUtils.getName(path);
    //     return fileName;
    // }


}
package object;

import h2d.filter.AbstractMask;
//import js.html.CanvasRenderingContext2D;
import h2d.Mask;
import h2d.Graphics;
import hxPEngine.ui.util.entity.*;
import h2d.Anim;
import h2d.Tile;
import haxe.Json;

import hxPEngine.ui.util.Assets;
import hxPEngine.ui.util.StringUtils;


class RoleEntity extends h2d.Object {
    var assets:Assets;
    var defauldirction:Int;

    var anim:AnimBase;
    //名称，方向，动画 图片
    var arrSegmentation:Map<String,Array<Segmentation>>;
    var mapImage:Map<String,Array<MapImage>>;
    // 当前贴图
    var arrTile1:Map<String,RolejsTile>;
    // 集合贴图
    var arrTile2:Map<String,Map<String,RolejsTile>>;

    // 当前动画
    var defaultAnimation:RolejsTile;
    // 集合动画
    var defaultAnimationMap:Map<String,RolejsTile>;

    var PlayName:String;
    var PlayDirction:String;

    public function getName1(string:String): String{
        var path = StringTools.replace(string, "\\", "/");
        var fileName = StringUtils.getName(path);
        return fileName;
    }

    public function getWidth():Float{

        return jsoncollision.width;
        //trace(defaultAnimation.data[0].width);
        //return defaultAnimation.data[0].width;
    }
    public function getHeight():Float{
        return jsoncollision.height;
    }

    public function getpositionX():Float{
        return Std.parseFloat(jsoncollision.x);
    }
    public function getpositionY():Float{
        return Std.parseFloat(jsoncollision.y);
    }

    var scalesX:Float = 1;
    var scalesY:Float = 1;

    var path:String;

   

    public function new(url:String, ?animationName:String = "default", ?direction:String = "default", ?parent : h2d.Object) {
        super(parent);

        this.assets = new Assets();
        arrSegmentation = new Map<String,Array<Segmentation>>();
        mapImage = new Map<String,Array<MapImage>>();
        
        defaultAnimation = new RolejsTile();        
        defaultAnimationMap = new Map<String,RolejsTile>();

            
        arrTile1 = new Map<String,RolejsTile>();
        arrTile2 = new Map<String,Map<String,RolejsTile>>();

        PlayName = "";
        PlayDirction = "";
        anim = null;

        this.name = StringUtils.getName(url);
        assets.loadFile(url);
        assets.start(function(f) {
            if (f == 1) {
                if( assets.getJson(this.name)=="undefined" ||  assets.getJson(this.name) == null){
                    return;
                }

                var objJsonStr = Json.stringify(assets.getJson(this.name));
                var jsonObject = Json.parse(objJsonStr);

                this.scalesX = jsonObject.scaleX;
                this.scalesY = jsonObject.scaleY;
                
                var animation:Array<Dynamic> = jsonObject.animation;
                path = url + ".image/";

                for (anim in animation) {
                    var data:Array<Dynamic> = anim.data;
                    var mapImageName:Map<String,Array<String>> = new Map<String,Array<String>>();
                    var mapImagesArr:Array<MapImage> = new Array<MapImage>();
                    var segmentationArr:Array<Segmentation> = new Array<Segmentation>();

                    // 读取默认方向
                    if(anim.defaulaction){
                        defauldirction = anim.defauldirection;
                    }

                    for (da in data) {
                        
                        if(da.type == "images"){
                            var mapImages = new MapImage();
                            var imagedata:Array<Dynamic> = da.data;
                            // var arrImageName:Array<String> = new Array<String>();
                            // for (image in imagedata) {
                            //     //assets.loadFile(image);
                            //     assets.loadFile(path + image);
                            //     arrImageName.push(StringUtils.getName(image));
                                
                            // }

                            var arrImageName:Array<DataImage> = new Array<DataImage>();
                            var rotate:Array<Float> = new Array<Float>(); // 旋转角度
                            for (image in imagedata) {
                                var dataimage:DataImage = new DataImage();
                                dataimage.positionX = image.positionX;
                                dataimage.positionY = image.positionY;
                                dataimage.overturn = image.overturn;
                                rotate.push(image.rotate);
                                dataimage.url = getName1(image.url);
                                //trace(image.positionX);
                                //trace(image); // 输出 "images"
                                assets.loadFile(image.url);
                                //assets.loadFile(this.path + image.url);
                                // trace(getName1(image));
                                arrImageName.push(dataimage);
                                
                            }
                            //trace("rotate:"+rotate);
                            mapImages.rotate = rotate;
                            mapImages.carousel = da.carousel;
                            mapImages.direction = Std.string(da.direction);
                            mapImages.data = arrImageName;
                            mapImages.rate = da.rate;

                            mapImages.collisiondata = da.collisiondata;
                            mapImages.maskdata = da.maskdata;


                            // mapImages.collision = da.collision;
                            // var pro:Property = new Property();
                            // if(da.collision == 1 ){

                            // }else if(da.collision == 2){
                            //     pro.x = da.collisionproperty.x;
                            //     pro.y = da.collisionproperty.y;
                            //     pro.width = da.collisionproperty.width;
                            //     pro.height = da.collisionproperty.height;

                            // }else if (da.collision ==3){
                            //     pro.x = da.collisionproperty.x;

                            // }
                            

                            // mapImages.collisionproperty = pro;


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
                            //mapImageName.set(Std.string(da.direction), arrImageName);
                            mapImagesArr.push(mapImages);
                            mapImage.set(anim.name, mapImagesArr);


                        }else{
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
                                //assets.loadFile(this.path + image);
                                // trace(getName1(image));
                                arrImageName.push(dataimage);
                                
                            }

                            segmen.rotate = rotate;


                            segmen.collisiondata = da.collisiondata;
                            segmen.maskdata = da.maskdata;


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

                            // }
                            

                            // segmen.collisionproperty = pro;



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


                            segmen.src = StringUtils.getName(da.src);
                            segmen.direction = Std.string(da.direction);
                            segmen.data = arrImageName;
                            segmen.carousel = da.carousel;
                            segmen.rate = da.rate;
                            segmen.defaulaction = anim.defaulaction;
                            //assets.loadFile(this.path + da.src );
                            assets.loadFile(da.src);
                            segmentationArr.push(segmen);                            

                            arrSegmentation.set(anim.name, segmentationArr);
                        }
                    }
                }

                assets.start(function(f) {
                    if (f == 1) {
                        for (arr in arrSegmentation.keys()){
                            var segmens = arrSegmentation.get(arr);
                            var judgeMap:Map<String,RolejsTile> = new Map<String,RolejsTile>();
                            for (segmen in segmens){
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
                                role.rotate = segmen.rotate;
                                role.carousel = segmen.carousel;
                                role.rate = segmen.rate;
                                role.direction = segmen.direction;
                                role.data = hh;                


                                role.collisiondata = segmen.collisiondata;
                                role.maskdata = segmen.maskdata;
                                
                                //role.collision = segmen.collision;
                                //role.collisionproperty = segmen.collisionproperty;
                                //role.mask = segmen.mask;
                               // role.maskproperty = segmen.maskproperty;
                                if(segmen.data.length == 0){
                                    role.positionX = 0;
                                    role.positionY = 0;
                                }else{
                                    role.positionX = segmen.data[segmen.data.length-1].positionX;
                                    role.positionY = segmen.data[segmen.data.length-1].positionY;
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
                            var images = mapImage.get(arr);
                            var judgeMap:Map<String,RolejsTile> = new Map<String,RolejsTile>();
                            
                            for (image in images){
                                var role:RolejsTile = new RolejsTile();
                                var arrTile: Array<Tile>= new Array<Tile>();
                                for (age in image.data){
                                    //trace(image);
                                     var t0:Tile = assets.getBitmapDataTile(age.url);
                                     //t0.setPosition(-50,-50);
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
                                     arrTile.push(t0);
                                 }

                                role.rotate = image.rotate;
                                role.carousel = image.carousel;
                                role.rate = image.rate;
                                role.direction = image.direction;
                                role.data = arrTile;


                                role.collisiondata = image.collisiondata;
                                role.maskdata = image.maskdata;

                                //role.collision = image.collision;
                                //role.collisionproperty = image.collisionproperty;
                               // role.mask = image.mask;
                               // role.maskproperty = image.maskproperty;
                                if(image.data.length == 0){
                                    role.positionX = 0;
                                    role.positionY = 0;
                                }else{
                                    role.positionX = image.data[image.data.length-1].positionX;
                                    role.positionY = image.data[image.data.length-1].positionY;
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

                      

                        if(animationName == "default" && direction == "default") {
                            if(defaultAnimationMap == null || defaultAnimationMap.toString() == "[]"){
                                return;
                            }

                            defaultAnimation = defaultAnimationMap.get(defauldirction + "");

                            

                            if(defauldirction != 0 ){
                                defaultAnimation = defaultAnimationMap.get(defauldirction + "");

                                if(anim == null) {
                                    anim = new AnimBase(null,this);
                                    anim.play(defaultAnimation.data);
                                    anim.degreesList = defaultAnimation.rotate;
                                    anim.speed = defaultAnimation.rate;
                                    anim.loop = defaultAnimation.carousel;
                                    
                                    anim.scaleX = this.scalesX;
                                    anim.scaleY = this.scalesY;
                                   // anim.x = 200;
                                    
                                }else{
                                    anim.play(defaultAnimation.data);
                                    anim.degreesList = defaultAnimation.rotate;
                                    anim.speed = defaultAnimation.rate;
                                    anim.loop = defaultAnimation.carousel;
                                    anim.scaleX = this.scalesX;
                                    anim.scaleY = this.scalesY;
                                   // anim.x = 200;
                                }
                                //trace("defaultAnimation:"+defaultAnimation);
                                setRoleJSTile(defaultAnimation);
                            }else{
                                var next = defaultAnimationMap.keys().next();
                                defaultAnimation = defaultAnimationMap.get(next);
                                if(anim == null) {
                                    anim = new AnimBase(null,this);
                                    anim.play(defaultAnimation.data);
                                    anim.degreesList = defaultAnimation.rotate;
                                    anim.speed = defaultAnimation.rate;
                                    anim.loop = defaultAnimation.carousel;
                                    anim.scaleX = this.scalesX;
                                    anim.scaleY = this.scalesY;
                                    //anim.x = 200;
                                    
                                }else{
                                    anim.play(defaultAnimation.data);
                                    anim.degreesList = defaultAnimation.rotate;
                                    anim.speed = defaultAnimation.rate;
                                    anim.loop = defaultAnimation.carousel;
                                    anim.scaleX = this.scalesX;
                                    anim.scaleY = this.scalesY;
                                    //anim.x = 200;
                                }

                                setRoleJSTile(defaultAnimation);
                            }

                            PlayDirction = defaultAnimation.direction;

                        }else{

                            if(animationName != "default" && direction != "default"){
                                PlayAnimation(animationName,direction);
                                PlayDirction = direction;
                                PlayName = animationName;
                            }
                            if(animationName != "default" && direction == "default"){
                                PlayName = animationName;
                            }                            
                        }    
                    }
                });

            }
        });
    }

    var grcollision:Graphics; //碰撞


    var grmask:Graphics; //遮罩

    public function setRoleJSTile(role:RolejsTile,?x:Float = 0,?y:Float = 0){



        if(role.collisiondata.length == 0){
            if(grcollision != null){
                this.removeChild(grcollision);
            }
            //jsoncollision = {};
        }else{

            if( grcollision != null){
                this.removeChild(grcollision);
            }
            
            jsoncollision = {};

            grcollision = new h2d.Graphics(this);
            
            grcollision.beginFill(0xFF0000, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            grcollision.drawRect(role.positionX * this.scalesX,role.positionY * this.scalesY,role.data[0].width * this.scalesX,
                         role.data[0].height * this.scalesY);
            grcollision.endFill();
            // 添加字符串值
            Reflect.setField(jsoncollision, "x", role.positionX * this.scalesX);
            Reflect.setField(jsoncollision, "y", role.positionY * this.scalesY);
            Reflect.setField(jsoncollision, "width", role.data[0].width * this.scalesX);
            Reflect.setField(jsoncollision, "height", role.data[0].height * this.scalesY);
            
        }


            


        // if(role.collisiondata.length == 0){
        //     if(grcollision != null){
        //         this.removeChild(grcollision);
        //     }
        //     //jsoncollision = {};
        // }else{
        //     GraphicsCanvasData(role);
        // }


        // if(role.maskdata.length == 0){
        //     if(grmask != null){
        //         this.removeChild(grmask);
        //     }
        //     //jsoncollision = {};
        // }else{
        //     GraphicsMaskdata(role);
        // }

        // if(role.collision == 0){
        //     if(grcollision != null){
        //         this.removeChild(grcollision);
        //     }
        //     //jsoncollision = {};
        // }else if(role.collision == 1){
        //     GraphicsCanvas(1, role.positionX,role.positionY,role.data[0].width,
        //         role.data[0].height);
        // }else if(role.collision == 2){
        //     GraphicsCanvas(2, role.collisionproperty.x,role.collisionproperty.y,role.collisionproperty.width,
        //         role.collisionproperty.height);
        // }else if(role.collision == 3){
        //     GraphicsCanvas(3, role.collisionproperty.x,role.collisionproperty.x,role.collisionproperty.x,
        //         role.collisionproperty.x);
        // }
        

        // if(role.mask == 0){
        //     if(grcollision != null){
        //         this.removeChild(grmask);
        //     }
            
        // }else if(role.mask == 1){
        //     GraphicsMask(1,role.maskproperty.x,role.maskproperty.y,role.maskproperty.width,
        //         role.maskproperty.height);
        // }else if(role.mask == 2){
        //     GraphicsMask(2,role.maskproperty.x,role.maskproperty.x,role.maskproperty.x,
        //         role.maskproperty.x);
        // }
    }
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
        
        if( grcollision != null){
            this.removeChild(grcollision);
        }
        if(role.collisiondata.length == 0){
            if(grcollision != null){
                grcollision.clear();
            }
        }


      
    

        grcollision = new h2d.Graphics(this);
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




    public  var jsoncollision: Dynamic = {
    };

    public  var jsoncollision2: Dynamic = {
    };


    public function GraphicsCanvas(type:Int,x:Float,y:Float,width:Float,height:Float,?param:Float = 1){

        //jsoncollision.name = "John Doe";
        jsoncollision = {};
        jsoncollision2 = {};
        
        
        if( grcollision != null){
            this.removeChild(grcollision);
        }

        if(type == 0){
            if(grcollision != null){
                grcollision.clear();
            }
        }else if(type == 1 || type == 2){
            grcollision = new h2d.Graphics(this);
            grcollision.beginFill(0xFF0000, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            grcollision.drawRect(x, y, width, height);
            grcollision.endFill();
            // 添加字符串值
            Reflect.setField(jsoncollision, "x", x * this.scalesX);
            Reflect.setField(jsoncollision, "y", y * this.scalesY);
            Reflect.setField(jsoncollision, "width", width * this.scalesY);
            Reflect.setField(jsoncollision, "height", height * this.scalesX);


            // 添加字符串值
            Reflect.setField(jsoncollision2, "x", x);
            Reflect.setField(jsoncollision2, "y", y);
            Reflect.setField(jsoncollision2, "width", width);
            Reflect.setField(jsoncollision2, "height", height);


            grcollision.scaleX = this.scalesX;
            grcollision.scaleY = this.scalesY;

           // trace("jsoncollision:"+jsoncollision);
        }else if(type == 3){
            grcollision = new h2d.Graphics(this);
            grcollision.beginFill(0xFF0000, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            var xx = 0 -(x/2);
            var yy = 0 -(x/2);
            grcollision.drawRect(xx, yy, x, x);
            grcollision.endFill();
            Reflect.setField(jsoncollision, "x", xx  * this.scalesX);
            Reflect.setField(jsoncollision, "y", yy  * this.scalesY);
            Reflect.setField(jsoncollision, "width", x  * this.scalesX);
            Reflect.setField(jsoncollision, "height", x  * this.scalesY);

            Reflect.setField(jsoncollision2, "x", xx);
            Reflect.setField(jsoncollision2, "y", yy);
            Reflect.setField(jsoncollision2, "width", x);
            Reflect.setField(jsoncollision2, "height", x);

            grcollision.scaleX = this.scalesX;
            grcollision.scaleY = this.scalesY;

        }

        //setChildIndex(object2, getChildIndex(object1) + 1);

        

        //jsoncollision2 = jsoncollision;

       // trace("jsoncollision:"+jsoncollision);
        
    }

    public  var jsonMaskdata: Dynamic = [];

    public  var jsonMaskdata2: Dynamic = [];

    public function GraphicsMaskdata(role:RolejsTile){
        if(grmask != null){
            this.removeChild(grmask);
        }

        if(role.maskdata.length == 0){
            if(grmask != null){
                grmask.clear();
            }
        }


        jsonMaskdata = [];
        jsonMaskdata2 = [];



        grmask = new h2d.Graphics(this);
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
                    "height": data.height * scaleY
                };
                var newObj1 = {
                    "mask": data.mask,
                    "x": data.x,
                    "y": data.y,
                    "width": data.width,
                    "height": data.height
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
                    "height": data.x  * scaleY
                };

                newObj1 = {
                    "mask": data.mask,
                    "x": xx ,
                    "y": yy ,
                    "width": data.x ,
                    "height": data.x 
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
    }


    public  var jsonMask: Dynamic = {
    };

    public  var jsonMask2: Dynamic = {
    };

    public function GraphicsMask(type:Int,x:Float,y:Float,width:Float,height:Float){
        if( grmask != null){
            this.removeChild(grmask);
        }


        jsonMask = {};
        jsonMask2 = {};

        if(type == 0){
            if(grmask != null){
                grmask.clear();
            }

        }else if(type == 1){
            grmask = new h2d.Graphics(this);
            grmask.beginFill(0xFFFF00, 0.5);
            //trace("width");
            //trace(defaultAnimation.data[0].width);
            //trace(defaultAnimation.data[0].height);
            grmask.drawRect(x, y, width, height);
            grmask.endFill();

            Reflect.setField(jsonMask, "x", x * this.scalesX);
            Reflect.setField(jsonMask, "y", y * this.scalesY);
            Reflect.setField(jsonMask, "width", width * this.scalesX);
            Reflect.setField(jsonMask, "height", height * this.scalesY);


            // 添加字符串值
            Reflect.setField(jsonMask2, "x", x);
            Reflect.setField(jsonMask2, "y", y);
            Reflect.setField(jsonMask2, "width", width);
            Reflect.setField(jsonMask2, "height", height);

            grmask.scaleX = this.scalesX;
            grmask.scaleY = this.scalesY;
        }else if(type == 2){
            grmask = new h2d.Graphics(this);
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


            Reflect.setField(jsonMask, "x", xx  * this.scalesX);
            Reflect.setField(jsonMask, "y", yy  * this.scalesY);
            Reflect.setField(jsonMask, "width", x  * this.scalesX);
            Reflect.setField(jsonMask, "height", x  * this.scalesY);

            Reflect.setField(jsonMask2, "x", xx);
            Reflect.setField(jsonMask2, "y", yy);
            Reflect.setField(jsonMask2, "width", x);
            Reflect.setField(jsonMask2, "height", x);

            grmask.scaleX = this.scalesX;
            grmask.scaleY = this.scalesY;
        }

       // trace("grmask:"+_vbox.getChildIndex(img));
        //trace("grmask1:"+_vbox.getChildIndex(grmask));

       // _vbox.addChildAt(img, _vbox.getChildIndex(grmask) + 1);
        //trace("img:"+_vbox.getChildIndex(img));
        
    }


    public function PlayAnimation(name:String,direction:String,atFrame:Float = 1){

        if(this.PlayName == name && this.PlayDirction == direction){
            return;
        }

        this.PlayName = name;
        this.PlayDirction = direction;


        // assets.start(function(f) {
        //     if (f == 1) {                
                var ss = arrTile1.get(name+direction);

                //trace("arrtile:"+arrTile1);
                if(ss == null){
                    return;
                }

                defaultAnimation = ss;

                //trace(defaultAnimation);
               
                if(anim == null){
                    anim = new AnimBase(null,this);
                    anim.play(ss.data);
                    anim.degreesList = ss.rotate;
                    anim.speed = ss.rate;
                    anim.loop = ss.carousel;
                    setRoleJSTile(ss);
                    anim.scaleX = this.scalesX;
                    anim.scaleY = this.scalesY;
                    anim.onAnimEnd = function (){
                        if(!ss.carousel){
                            var defa = defaultAnimationMap.get(ss.direction);

                            trace(defa);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                setRoleJSTile(defa);
                                anim.scaleX = this.scalesX;
                                anim.scaleY = this.scalesY;

                                defaultAnimation = defa;
                            }
                        }

                    };
                   
                    
                }else{
                    anim.play(ss.data, atFrame);
                    anim.degreesList = ss.rotate;
                    anim.speed = ss.rate;
                    anim.loop = ss.carousel;
                    anim.scaleX = this.scalesX;
                    anim.scaleY = this.scalesY;
                    anim.onAnimEnd = function (){
                        if(!ss.carousel){
                            var defa = defaultAnimationMap.get(ss.direction);
                            
                            if(defa != null){
                                
                                anim.play(defa.data);
                                anim.degreesList = defa.rotate;
                                anim.speed = defa.rate;
                                anim.loop = defa.carousel;
                                anim.scaleX = this.scalesX;
                                anim.scaleY = this.scalesY;
    
                                setRoleJSTile(defa);
                            }
                        }

                    };  
                    setRoleJSTile(ss);                 
                }                
        //    }
        // });

    }





}
import hxd.fmt.hmd.Data.Material;
import haxe.Json;
import MainJS.MainApp;
import h2d.TextInput;
import h2d.CheckBox;
import hxPEngine.ui.util.TimeRuntime.Call;
import h2d.Text;
import h2d.HtmlText;
import hxPEngine.ui.display.Label;
import hxPEngine.ui.UIWindow;
import hxPEngine.ui.display.Button;
import hxPEngine.ui.UIEntity;
import hxPEngine.ui.util.Assets;
import hxPEngine.ui.util.AssetsBuilder;
import hxPEngine.ui.display.Image;
import hxPEngine.ui.display.ListView;
import hxPEngine.ui.layout.VerticalListLayout;
import hxPEngine.ui.layout.HorizontalListLayout;
import hxPEngine.ui.layout.VirualFlowListLayout;
import hxPEngine.ui.layout.FlowListLayout;


import hxPEngine.ui.data.ArrayCollection;
import hxPEngine.ui.data.ObjectRecycler;
import hxPEngine.ui.events.Event;
import hxPEngine.ui.display.ItemRenderer;
import h2d.Font;
import hxPEngine.ui.util.FontBuilder;
import hxPEngine.ui.display.Progress;
import hxPEngine.ui.display.Quad;
import hxPEngine.ui.display.ScrollView;
import hxPEngine.ui.display.DownListView;
import hxPEngine.ui.data.ButtonSkin;

import motion.Actuate;
import h2d.col.Point;
import hxPEngine.ui.display.TextInput;

class TestUI extends UIWindow {
    var lal:Label = null;
    public function setFps(fps:Float,carmer:String,saveInfo:String) {
        lal.text = "fps:"+Std.int(fps);
        lal.text += "\r\n";

        // 转换一下carmer，carmer是json
        var carmerJson = Json.parse(carmer);

        for (field in Reflect.fields(carmerJson.pos)) {
            var value = Std.string(Reflect.field(carmerJson.pos, field));
            lal.text += field + ":" + value + "\r\n";
        }
        for (field in Reflect.fields(carmerJson.target)) {
            var value = Std.string(Reflect.field(carmerJson.target, field));
            lal.text += field + ":" + value + "\r\n";
        }

        lal.text += "saveinfo" + ":" + saveInfo + "\r\n";
      //  lal.text += "pos" + ":" + carmerJson.pos + "\r\n";
       // lal.text += "target" + ":" + carmerJson.target + "\r\n";
    }

    public static function fromJson(data:Dynamic):Material {
        var material = new Material();
        material.props = data.props;
        material.name = data.name;
        material.diffuseTexture = data.diffuseTexture;
        material.blendMode = h2d.BlendMode.None;
        material.normalMap = data.normalMap;
        material.specularTexture = data.specularTexture;
        return material;
    }



    override function onInit() {
        super.onInit();
        var vbox = new UIEntity(this);        
        // var button1:Button = Button.create("btn_LvSe", null, vbox);
        // button1.setY(100);
        // button1.setX(100);
        // button1.width = 200;
        // button1.height = 150;

        // var interactive = new h2d.Interactive(0, 0,this);
        // interactive.onClick = function(event : hxd.Event) {
        //     trace("click!");
        // }
        //event : hxd.Even

        // button1.onClick = function() {
        //     //var button3:Button = Button.create("btn_LvSe", null, vbox);
        //      //button3.setY(300);
        //      //trace(event);
        //      trace("click!22222");
        // }
        
        //button1.text = "哎哎哎";

        


      
        // var button2:Button = Button.create("btn_LvSe", null, vbox);
        // button2.setY(300);

        // button2.onClick = function() {
        //     //var button3:Button = Button.create("btn_LvSe", null, vbox);
        //      //button3.setY(300);
        //      //trace(event);
        //      trace("click!111111");
        // }

        lal = new Label(vbox);
        lal.text = "fps:60";
        lal.setSize(20);
        lal.filter = new h2d.filter.Glow(0xff0000, 100, 1);
        lal.x = 600;
        lal.y=10;




        var assets = new Assets();
		
		AssetsBuilder.bindAssets(assets);

        
		 assets.loadFile("res/role/image0.png");
		 assets.loadFile("res/role/image1.png");
		 assets.loadFile("res/role/image2.png");
		 assets.loadFile("res/role/image3.png");
		 assets.loadFile("res/role/image4.png");
		 assets.loadFile("res/role/image5.png");
         assets.loadFile("res/role/dandan.png");
         assets.loadFile("res/role/data.json");
         
         
		
		 assets.loadFile("res/img/btn_LvSe.png");
		 assets.loadFile("res/img/images.png");
         assets.loadFile("res/img/test.png");
         assets.loadFile("res/img/inventory_button.png");
         assets.loadFile("res/img/inventory_button.png");
         
         assets.loadFile("res/img/sword01.png");

       // assets.loadFile("res/img/yuan.png");
        assets.start(function(f) {
        //     var sss = assets.hasTypeAssets(BITMAP_TILE,"btn_LvSe");

            // trace(f);
            trace("==============loading=============");
            trace(f);
            trace("==============loading=============");

            
            if(f==1) {



                var t1 = assets.getBitmapDataTile("image0");
                var t2 = assets.getBitmapDataTile("image1");
                var t3 = assets.getBitmapDataTile("image2");
                var t4 = assets.getBitmapDataTile("image3");
                var t5 = assets.getBitmapDataTile("image4");
                var t6 = assets.getBitmapDataTile("image5");
                //var ss = assets.getAtlas("dandan");
               // var aa = assets.getJson("data");
                //var anim = new h2d.Anim([t1,t2,t3,t4,t5,t6],vbox); 


                // var anim1 = new pengine.loadbyanim("老鼠");
                // s2d.add(anim1);


                // var img = new Image(assets.getBitmapDataTile("images"), vbox);
                // img.x = 200;
                // var img1 = new Image(assets.getBitmapDataTile("test"), vbox);
                // img1.y = 100;


                var button1:Button = Button.create("images", null, vbox);
                button1.text = "哈哈哈";
                button1.width = 250;
                button1.x = 300;
                //button1.label.setSize(101);
                button1.label.setSize(20);
				button1.label.setColor(0x0);
                button1.onClick = function(btn, e) {
                    trace("click!111111");
                    //MainJS.load('');
                    //assets.getSound("mc1043").play(true);
                   // MainJS.load('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx');
                    var json = '[{"props": null, "name": "Sword01", "diffuseTexture": "res/img/sss.jpg", "blendMode": "None", "normalMap": null, "specularTexture": null},{"props": null, "name": "Skeleton01", "diffuseTexture": "res/img/sss.jpg", "blendMode": "Alpha", "normalMap": null, "specularTexture": null}]';
                     var materials = Json.parse(json).map(function(data) return fromJson(data));

                    MainJS.setHMDMaterialList(materials);
                    //setinit('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx');
                    
                }

                var button2:Button = Button.create("images", null, vbox);
                button2.text = "嘻嘻嘻";
                button2.width = 250;
                button2.x = 0;
                //button1.label.setSize(101);
                button2.label.setSize(20);
				button2.label.setColor(0x0);
                button2.onClick = function(btn, e) {
                    trace("click!111111");
                    //MainJS.load('');
                    //assets.getSound("mc1043").play(true);
                   // MainJS.load('I:\\Myproject\\HeapsPlus\\PEngine\\res\\img\\Model.fbx');
                   RoleJS.load('I:\\Myproject\\HeapsPlus\\PEngine\\res\\role\\aa4.rule');
                    
                }



                var button3:Button = Button.create("images", null, vbox);
                button3.text = "更换装备";
                button3.width = 250;
                button3.x = 400;
                //button1.label.setSize(101);
                button3.label.setSize(20);
				button3.label.setColor(0x0);
                button3.onClick = function(btn, e) {
                    //MainJS.changeE();
                    RoleJS.PlayAnimation("pao","4");
                    trace("click!333");
                    
                }



                
                // var p:Progress = new Progress("btn_LvSe", new Quad(100, 100, 0xff0000, null, 6), this);
				// p.right = 20;
				// p.top = 230;
				// p.style = HORIZONTAL;
				// p.progress = 0.7;
                // p.x = 100;
                // p.y= 100;
                //var localPos = this.globalToLocal(new Point(1, 2));

                

                var targetX = button1.x;
                button1.x = button1.stageWidth;
                Actuate.tween(button1, 1, {
                    x: targetX
                }).onUpdate(function() {
                    @:privateAccess button1.posChanged = true;
                });

                var s  = new CheckBox(vbox);
                s.text = "哈哈";
                s.enable = true;


                // var a = new TextInput(FontBuilder.getFont("res\\simhei.ttf", 20, {
                //     chars: "哈哈"
                // }),this);

                // a.y = 200;
                // a.text  = "哈哈哈哈";

                //var input:TextInput = new TextInput();
                var input:TextInput = new TextInput();
		// input.setSize(80);
		// input.backgroundColor = 0xffff0000;
                this.addChild(input);
                 input.width = 300;
                 input.height = 100;
                input.left = 20;
                input.right = 20;
                input.centerY = 50;

                input.y = 300;


                //  var down = new DownListView(new ButtonSkin("ui1","ui2"),this);
                //  down.dataProvider = new ArrayCollection(["哈哈","哎哎哎","嘻嘻嘻"]);
                 
                //  down.width = 100;
                //  down.height = 70;
                //  down.y = 300;
                //  down.x = 400;
                 //down.selectedIndex = 0;


                 
                

                // var listview = new ListView(this);
                // listview.x = 500;
                // listview.width = 800;
                // listview.height = 700;
                // listview.top = 20;
                // listview.bottom = 20;
                // listview.left = 30;

                // //listview.layout = new VerticalListLayout();
                // var ss = new VirualFlowListLayout();
                // ss.gapX = 20;
                // ss.gapY = 20;
                // listview.layout =ss;
                
                // // 数据
                // listview.dataProvider = new ArrayCollection([
                //     for (i in 0...50) {
                //         i;
                //     }
                // ]);

                // // 自定义渲染器
                // listview.itemRendererRecycler = ObjectRecycler.withClass(CustomItemRenderer);
                // // 禁止溢出滑动
                // listview.enableOutEasing = true;
                // listview.addEventListener(Event.CHANGE, function(e) {
                //     trace("我选中的内容是:", listview.selectedItem, "索引是", listview.selectedIndex);
                // });


                // var view = new ScrollView(this);
                //  var quad = new Quad(600,600,0xff0000,view);
                

            }


        });



        
        //hasTypeAssets

        /*
        var sss = assets.hasTypeAssets(BITMAP_TILE,"btn_LvSe");

        trace(sss);

        var img = new Image(assets.getBitmapDataTile("images.png"), vbox);
    
        var img1 = new Image(assets.getBitmapDataTile("btn_LvSe"), vbox);
*/


        //lal.set_text("哈哈");

        
		//img.right = 0;


        // var html = new HtmlText(hxd.res.DefaultFont.get(),vbox);
        // html.text = "<p>哈哈</p>";

        
        // var font : h2d.Font = hxd.res.DefaultFont.get();
        // var txt = new Text(font,vbox);
        // txt.text = "ssssssss";
        // txt.textAlign = Center;
        // txt.x = 50;
        
    }

   
}

class CustomItemRenderer extends ItemRenderer {
	private static var _font:Font;

	public static function getFont():Font {
		if (_font == null) {
			_font = FontBuilder.getFont(Label.defaultFont, 50, {
				chars: "1234567890"
			});
		}
		return _font;
	}

	public var button:Button;
    public var image:Image;

	override function onInit() {
		super.onInit();
		//button = Button.create("images", null, this);
		//button.label.useFont = getFont();
		//button.width = 260;
		//button.height = 100;
        image = new Image("inventory_button",this);
        image.width = 330;
        image.height = 166;
	}

	override function set_data(value:Dynamic):Dynamic {
		//button.text = Std.string(value);
		return super.set_data(value);
	}

	override function set_selected(value:Bool):Bool {
		//button.label.alpha = value ? 1 : 0.5;
        image.alpha = value ? 1 : 0.5;
		return super.set_selected(value);
	}
}
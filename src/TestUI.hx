import hxPEngine.ui.util.TimeRuntime.Call;
import h2d.Text;
import h2d.HtmlText;
import hxPEngine.ui.base.Label;
import hxPEngine.ui.UIWindow;

import hxPEngine.ui.Button;
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

class TestUI extends UIWindow {
    
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

        var lal = new Label(vbox);
        lal.text = "123哈哈";
        lal.setSize(50);


        var assets = new Assets();
		
		AssetsBuilder.bindAssets(assets);
		
		assets.loadFile("res/img/btn_LvSe.png");
		assets.loadFile("res/img/images.png");
        assets.loadFile("res/img/test.png");
       // assets.loadFile("res/img/yuan.png");
        assets.start(function(f) {
        //     var sss = assets.hasTypeAssets(BITMAP_TILE,"btn_LvSe");

            // trace(f);
            trace("==============loading=============");
            trace(f);
            trace("==============loading=============");

            
            if(f==1) {
                var img = new Image(assets.getBitmapDataTile("images"), vbox);
                img.x = 200;
                var img1 = new Image(assets.getBitmapDataTile("test"), vbox);
                img1.y = 100;


                var button1:Button = Button.create("btn_LvSe", null, vbox);
                button1.text = "哈哈哈";
                button1.width = 250;
                button1.x = 300;
                //button1.label.setSize(101);
                button1.label.setSize(20);
				button1.label.setColor(0x0);
                button1.onClick = function(btn, e) {
                    trace("click!111111");
                }

                var listview = new ListView(this);
                listview.x = 500;
                listview.width = 800;
                listview.top = 0;
                listview.bottom = 0;

                //listview.layout = new VerticalListLayout();
                listview.layout = new FlowListLayout();
                
                // 数据
                listview.dataProvider = new ArrayCollection([
                    for (i in 0...50) {
                        i;
                    }
                ]);

                // 自定义渲染器
                listview.itemRendererRecycler = ObjectRecycler.withClass(CustomItemRenderer);
                // 禁止溢出滑动
                listview.enableOutEasing = true;
                listview.addEventListener(Event.CHANGE, function(e) {
                    trace("我选中的内容是:", listview.selectedItem, "索引是", listview.selectedIndex);
                });


                var view = new ScrollView(this);
                 var quad = new Quad(600,600,0xff0000,view);
                

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

	override function onInit() {
		super.onInit();
		button = Button.create("btn_LvSe", null, this);
		button.label.useFont = getFont();
		button.width = 260;
		button.height = 100;
	}

	override function set_data(value:Dynamic):Dynamic {
		button.text = Std.string(value);
		return super.set_data(value);
	}

	override function set_selected(value:Bool):Bool {
		button.label.alpha = value ? 1 : 0.5;
		return super.set_selected(value);
	}
}
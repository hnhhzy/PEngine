package hxPEngine.ui;
import hxPEngine.ui.base.Label;
import h2d.col.Point;
import h2d.col.Circle;
import h2d.Object;
import hxPEngine.ui.data.ButtonSkin;
import h2d.Tile;
import hxd.Event;
import h2d.Interactive;
import hxPEngine.ui.base.IDisplayObject;
import hxPEngine.ui.display.Image;
import hxd.clipper.Rect;
import h2d.RenderContext;




/**
 * UI按钮
 */
class Button extends UIEntity {
    var mybitmap:h2d.Bitmap;
    var interaction:Interactive;


    /**
	 * 按钮皮肤
	 */
	public var skin:ButtonSkin;

	/**
	 * 按钮的皮肤显示对象
	 */
	private var display:AnyDisplay;

	/**
	 * 按钮的文本显示对象
	 */
	public var label:Label;

	/**
	 * 设置按钮的文本显示内容
	 */
	public var text(get, set):String;

    function get_text():String {
		return label.text;
	}

	function set_text(text:String):String {
		label.text = text;
		return text;
	}

    /**
	 * 设置九宫格图
	 */
	public var scale9Grid(default, set):Rect;

	private function set_scale9Grid(v:Rect):Rect {
		this.scale9Grid = v;
		this.dirt = true;
		return v;
	}

	/**
	 * 设置文本的偏移值
	 */
	public var labelOffest = {
		x: 0.,
		y: 0.
	}

    private function setSkinDisplay(skin:Dynamic):Void {
		// if (display != null) {
		// 	cast(display, Object).remove();
		// }
		// display = convertIDisplayObject(skin);
		// if (display == null)
		// 	return;
		display.setData(skin);
		display.width = this.width;
		display.height = this.height;
		this.addChildAt(cast display, 0);
		this.dirt = true;
	}
    
    /**
	 * 交互器
	 */
	//public var interactive:Interactive;
    /**
	 * 创建一个按钮
	 * @param up 
	 * @param down 
	 * @param parent 
	 * @return Button
	 */
    public static function create(up:Dynamic, ?down:Dynamic, ?parent:Object):Button {
		return new Button(new ButtonSkin(up, down), parent);
	}

    public function new(skin:ButtonSkin, ?parent:Object) {
        super(parent);



        this.dirt = true;
		this.skin = skin;
		this.enableInteractive = true;
		this.interactive.onPush = function(e) {
			e.propagate = this.interactive.propagateEvents;
			if (display == null)
				return;
			cast(display, Object).scale(1);
			dirt = true;
			if (skin.down != null) {
				setSkinDisplay(skin.down);
			} else {
				// 缩放计算
				var rect = display.getSize();
				display.x = rect.width * 0.03;
				display.y = rect.height * 0.03;
				display.scaleX = 0.94;
				display.scaleY = 0.94;
			}
		}
		this.interactive.onRelease = function(e) {
			e.propagate = this.interactive.propagateEvents;
			if (display == null)
				return;
			setSkinDisplay(skin.up);
			display.scaleX = 1;
			display.scaleY = 1;
			display.x = display.y = 0;
			dirt = true;
		}
		this.interactive.onClick = function(e) {
			e.propagate = this.interactive.propagateEvents;
			this.onClick(this, e);
		}
		display = new AnyDisplay(this);
		this.setSkinDisplay(this.skin.up);
		label = new Label(null, this);
		label.textAlign = Center;
		var rect = display.getSize();
		label.maxWidth = rect.width;
		this.width = rect.width;
		this.height = rect.height;
        

        

    }


    private function updateLabelContext():Void {
		if (display == null)
			return;
		var size = label.getSize();
		label.x = labelOffest.x;
		label.y = display.height / 2 - size.height / 2 + labelOffest.y;
		label.maxWidth = display.width / label.scaleX;
		cast(display, Object).addChild(label);
	}

    override function draw(ctx:RenderContext) {
		if (display == null)
			return;
		if (dirt || label.dirt || display.dirt) {
			if (this.scale9Grid != null && display is Image) {
				cast(display, Image).scale9Grid = this.scale9Grid;
			}
			this.updateLabelContext();
		}
		super.draw(ctx);
	}



    public function setY(y) {
        mybitmap.y = y;
        this.setinteractiveY(y);
    }
    public function setX(x) {
        mybitmap.x = x;
        this.setinteractiveX(x);
    }


    // public var width(default, set):Null<Float>;
    // //设置宽度
    // function set_width(width:Null<Float>):Null<Float> {
	// 	this.width = width;
    //     this.setwidth(width);
    //     this.mybitmap.width = width;
	// 	return width;
	// }


    // public var height(default, set):Null<Float>;
    // //设置高度
    // function set_height(height:Null<Float>):Null<Float> {
	// 	this.height = height;
    //     this.setheight(height);
    //     this.mybitmap.height = height;
	// 	return height;
	// }

    
	

    
    /**
	 * 按钮的点击事件，请勿直接访问`interactive.onClick`
	 * @param e 
	 */
	dynamic public function onClick(btn:Button, e:Event):Void {}

    override function set_width(width:Null<Float>):Null<Float> {
		this.display.width = width;
		label.maxWidth = display.width;
		return super.set_width(width);
	}

	override function set_height(height:Null<Float>):Null<Float> {
		this.display.height = height;
		return super.set_height(height);
	}

	override function onRemove() {
		super.onRemove();
		setSkinDisplay(skin.up);
		display.scaleX = 1;
		display.scaleY = 1;
		display.x = display.y = 0;
		dirt = true;
	}




	
}

/**
 * 通用的显示对象
 */
 private class AnyDisplay extends UIEntity {
	public var img:Image;

	public var display:IDisplayObject;

	public function setData(data:Dynamic):Void {
		if (data is Tile || data is String) {
			if (img == null)
				img = new Image(data, this);
			img.setTile(data);
			img.width = this.width;
			img.height = this.height;
			if (display != null) {
				display.parent.removeChild(cast display);
			}
			this.addChild(img);
		}
		if (data is IDisplayObject) {
			if (parent != null)
				this.addChild(cast data);
			display = cast data;
			display.width = this.width;
			display.height = this.height;
			if (img != null) {
				img.parent.removeChild(img);
			}
		}
	}

	override function set_width(width:Null<Float>):Null<Float> {
		if (img != null)
			img.width = width;
		if (display != null)
			display.width = width;
		return super.set_width(width);
	}

	override function set_height(height:Null<Float>):Null<Float> {
		if (img != null)
			img.height = height;
		if (display != null)
			display.height = height;
		return super.set_height(height);
	}
}


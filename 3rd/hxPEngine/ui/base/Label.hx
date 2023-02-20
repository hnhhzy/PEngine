package hxPEngine.ui.base;

import hxPEngine.ui.base.IDisplayObject;
import hxPEngine.ui.util.FontBuilder;
import h2d.Font;
import hxd.res.DefaultFont;
import h2d.Object;
import h2d.Text;
import h2d.RenderContext;
import hxPEngine.ui.layout.ILayout;

class Label extends Text  implements IDisplayObject  {

    /**
	 * 默认字体
	 */
	#if mac
	public static var defaultFont:String = "/System/Library/Fonts/STHeiti Medium.ttc";
	#else
	public static var defaultFont:String = "res\\simhei.ttf";
	#end
	public static var defaultSize:Int = 28;

	/**
	 * 默认字体颜色
	 */
	public static var defaultColor:UInt = 0xffffff;


    
	public var width(default, set):Null<Float>;

	
	public var useLayoutParent:IDisplayObject;

	public var percentageWidth(default, set):Null<Float>;

	public function set_percentageWidth(value:Null<Float>):Null<Float> {
		this.percentageWidth = value;
		return value;
	}

	public var percentageHeight(default, set):Null<Float>;

	public function set_percentageHeight(value:Null<Float>):Null<Float> {
		this.percentageHeight = value;
		return value;
	}


	public var dirt:Bool;

	public var mouseChildren:Bool;
    function set_width(width:Null<Float>):Null<Float> {
		this.width = width;
		return width;
	}

    public var height(default, set):Null<Float>;

	function set_height(height:Null<Float>):Null<Float> {
		this.height = height;
		return height;
	}

	/**
	 * 距离左边
	 */
	public var left:Null<Float>;

	/**
	 * 距离右边
	 */
	public var right:Null<Float>;

	/**
	 * 距离顶部
	 */
	public var top:Null<Float>;

	/**
	 * 距离底部
	 */
	public var bottom:Null<Float>;

	/**
	 * 居中X
	 */
	public var centerX:Null<Float>;

	/**
	 * 居中Y
	 */
	public var centerY:Null<Float>;

	public var layout:ILayout;

    /**
	 * 布局自身
	 */
	 public function updateLayout():Void {
	 	layoutIDisplayObject(this);
	 }

	/**
	 * 构造一个Label文本
	 * @param text 
	 */
	public function new(text:String = null, parent:Object = null) {
		super(DefaultFont.get(), parent);
        _size = defaultSize;
		if (text != null)
			this.text = text;
		onInit();
	}

	public function onInit():Void {}

	override function addChildAt(s:Object, pos:Int) {
		// TODO 这里不能直接更新，否则ListView会引起循环dirt的错误
		// @:privateAccess SceneManager.setDirt();
		super.addChildAt(s, pos);
	}

	/**
	 * 指定使用的字体
	 */
	public var useFont:Font;


    override function set_text(t:String):String {
		if (t == null) {
			t = "null";
		}
		if (font != null && t == this.text)
			return t;
		// 当文本存在时，将旧的文本清理，重新构造
		if (useFont != null) {
			if (font != useFont) {
				this.font.dispose();
			}
			this.font = useFont;
		} else {
			if (this.font != null) {
				if (font != DefaultFont.get())
					this.font.dispose();
			}
            
			this.font = FontBuilder.getFont(defaultFont, _size, {
				chars: t
			});
		}
		return super.set_text(t);
	}
	
	private var _size:Int = 40;

	/**
	 * 设置文本大小
	 * @param size 
	 */
	public  function setSize(size:Int):Void {
		_size = size;
		if (font != null) {
			if (_size != font.size) {
				this.font = FontBuilder.getFont(defaultFont, _size, {
					chars: text
				});
			}
		}
	}

	/**
	 * 设置文本颜色
	 * @param color 
	 */
	public function setColor(color:UInt):Void {
		this.color.setColor(0xff000000 + color);
	}

    public function get_stageWidth():Float {
		return 1080;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		return 1920;
	}

	public var stageHeight(get, never):Float;

	override function draw(ctx:RenderContext) {
		//dirt = false;
		super.draw(ctx);
	}

	public var ids:Map<String, Object>;

	public function get<T:Object>(id:String, c:Class<T>):T {
		if (ids != null)
			return cast ids.get(id);
		return null;
	}

	public var contentWidth(get, null):Float;

	public function get_contentWidth():Float {
		//return 1920;
		return getWidth(this);
	}

	public var contentHeight(get, null):Float;

	public function get_contentHeight():Float {
		//return 1080;
		return getHeight(this);
	}
	
    
}
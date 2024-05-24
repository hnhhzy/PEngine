package haxePEngine.ui.component.hbase;

class Label extends h2d.Text {
    public var dirt:Bool = false;

    /**
     * 默认字体
     */
    #if mac
    public static var defaultFont:String = "/System/Library/Fonts/STHeiti Medium.ttc";
    #else
    public static var defaultFont:String = "res\\simhei.ttf";
    #end
    /**
     * 默认字体大小
     */
    public static var defaultSize:Int = 28;
    /**
     * 默认字体颜色
     */
    public static var defaultColor:UInt = 0xffffff;
    /**
     * 指定使用的字体
     */
    public var useFont(default, set):h2d.Font;

	private function set_useFont(v:h2d.Font):h2d.Font {
		this.useFont = v;
		this.font = useFont;
		return v;
	}

	public var width(default, set):Null<Float>;

	function set_width(width:Null<Float>):Null<Float> {
		this.width = width;
		dirt = true;
		return width;
	}

	public var height(default, set):Null<Float>;

	function set_height(height:Null<Float>):Null<Float> {
		this.height = height;
		dirt = true;
		return height;
	}

	private var _size:Int = 40;

	/**
	 * 设置文本大小
	 * @param size 
	 */
	public function setSize(size:Int):Void {
		_size = size;
		if (font != null) {
			if (_size != font.size) {
				this.font = haxePEngine.ui.component.hbase.utils.FontBuilder.getFont(defaultFont, _size, {
					chars: text
				});
			}
		}
	}

    public function new(?parent:h2d.Object) {
		super(hxd.res.DefaultFont.get(), parent);
		this.onInit();
	}

	override function set_text(t:String):String {
		if (t == null) {
			t = "null";
		}
		if (font != null && t == this.text)
			return t;
		if (t != "") {
			// 当文本存在时，将旧的文本清理，重新构造
			if (useFont != null) {
				if (font != useFont) {
					this.font.dispose();
				}
				this.font = useFont;
			} else {
				if (this.font != null) {
					if (font != hxd.res.DefaultFont.get())
						this.font.dispose();
				}
				this.font = haxePEngine.ui.component.hbase.utils.FontBuilder.getFont(defaultFont, _size, {
					chars: t
				});
			}
		}
		this.dirt = true;
		return super.set_text(t);
	}


    public function onInit():Void {}

	override function draw(ctx:h2d.RenderContext) {
		dirt = false;
		super.draw(ctx);
	}
}
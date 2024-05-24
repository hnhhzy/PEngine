package haxePEngine.ui.component.hbase.base;


import haxePEngine.ui.component.hbase.utils.FontBuilder;
import h2d.col.Bounds;
import h2d.RenderContext;
#if hl
import haxePEngine.ui.component.hbase.base.text.glyphme.TrueTypeFont;
#end
import hxd.Event;
import h2d.Font;
import h2d.Object;
import hxd.res.DefaultFont;

/**
 * 自动兼容中文输入的TextInput
 */
class BaseTextInput extends h2d.TextInput {

	public var mouseChildren:Bool = true;


	public function new(?parent:Object) {
		var font = FontBuilder.getFont(Label.defaultFont, _size, {
			chars: " "
		});
		#if hl
		@:privateAccess cast(font, TrueTypeFont).__forceHasChar = true;
		#end
		super(font, parent);
		// this.addChildAt(_select, 0);
		// _select.alpha = 0.5;
		this.height = 64;
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
				this.font = FontBuilder.getFont(Label.defaultFont, _size, {
					chars: text == "" ? " " : text
				});
				#if hl
				@:privateAccess cast(font, TrueTypeFont).__forceHasChar = true;
				#end
				this.text = this.text;
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
			this.font = FontBuilder.getFont(Label.defaultFont, _size, {
				chars: t
			});
			#if hl
			@:privateAccess cast(this.font, TrueTypeFont).__forceHasChar = true;
			#end
		}
		// this.dirt = true;
		return super.set_text(t);
	}

	public function set_width(value:Null<Float>):Null<Float> {
		this.width = value;
		dirt = true;
		return value;
	}

	public var width(default, set):Null<Float>;

	public var height(default, set):Null<Float>;

	public function set_height(value:Null<Float>):Null<Float> {
		this.height = value;
		dirt = true;
		return value;
	}

	public var left:Null<Float>;

	public var right:Null<Float>;

	public var top:Null<Float>;

	public var bottom:Null<Float>;

	public var centerX:Null<Float>;

	public var centerY:Null<Float>;

	public function onInit() {}

	public var dirt:Bool;

	public var ids:Map<String, Object>;

	public function get<T:Object>(id:String, c:Class<T>):T {
		throw new haxe.exceptions.NotImplementedException();
	}

	override function draw(ctx:RenderContext) {
		if (dirt) {
			if (width != null) {
				this.inputWidth = Std.int(width);
			}

			// if (height != null) {
			// 	this.height = Std.int(height);
			// }
			dirt = false;
		}
		super.draw(ctx);
	}

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
}
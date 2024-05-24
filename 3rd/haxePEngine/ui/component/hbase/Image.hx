package haxePEngine.ui.component.hbase;

import haxePEngine.ui.component.hbase.base.ILayout;
import haxePEngine.ui.component.hbase.base.IDisplayObject;

class Image extends h2d.Bitmap implements IDisplayObject{
	/**
	 * 是否有变更，当存在变更时，draw接口会对该图形进行重绘
	 */
	public var dirt:Bool = false;
	private var __scaleGrid:h2d.ScaleGrid;
	private var __scale9Grid:hxd.clipper.Rect;

	/**
	 * 是否使用父节点的尺寸，如ScrollView通常自身会有一个`Box`，布局尺寸应该按`ScrollView`获取。
	 */
	public var useLayoutParent:IDisplayObject;

	function get_scale9Grid():hxd.clipper.Rect {
		return __scale9Grid;
	}

	function set_scale9Grid(scale9Grid:hxd.clipper.Rect):hxd.clipper.Rect {
		__scale9Grid = scale9Grid;
		dirt = true;
		return scale9Grid;
	}

	/**
	 * 构造一个图片显示对象
	 * @param tile 
	 * @param parent 
	 */
     public function new(?tile:h2d.Tile, ?parent:h2d.Object) {
		super(null, parent);
		this.setTile(tile);
		if (tile is h2d.Tile) {
			this.width = tile.width;
			this.height = tile.height;
		}
		onInit();
	}

	/**
	 * 设置动态的tile，tile可以是`String`或者`Tile`，当使用`String`时，它会从`AssetsBuiler`中查找资源。
	 * @param data 
	 */
     public function setTile(data:h2d.Tile):Void {
		this.tile = data;
		this.dirt = true;
	}

    public function onInit():Void {}

	public function set9Grid(data:Dynamic):Void {
		__scale9Grid = data;
	}

	override function set_width(w:Null<Float>):Null<Float> {
		dirt = true;
		return super.set_width(w);
	}

	override function set_height(h:Null<Float>):Null<Float> {
		dirt = true;
		return super.set_height(h);
	}

	override function draw(ctx:h2d.RenderContext) {
		if (dirt) {
			if (tile != null) {
				// 九宫格兼容
				if (__scale9Grid != null) {
					if (this.__scaleGrid == null) {
						this.__scaleGrid = new h2d.ScaleGrid(tile, __scale9Grid.left, __scale9Grid.top, __scale9Grid.right, __scale9Grid.bottom);
						__scaleGrid.smooth = this.smooth;
						this.addChildAt(__scaleGrid, 0);
					} 

					__scaleGrid.tile = tile;
					__scaleGrid.width = this.width;
					__scaleGrid.height = this.height;

				}else {
					if (this.__scaleGrid != null) {
						this.__scaleGrid.tile = null;
						this.__scaleGrid.remove();
					}
				}
			}
		}
		super.draw(ctx);
		this.dirt = false;
	}

	/**
	 * 当处于存在九宫格数据时，则不会将当前对象tile上传到渲染缓存数据中
	 * @param ctx 
	 * @param tile 
	 */
	 override function emitTile(ctx:h2d.RenderContext, tile:h2d.Tile) {
		if (__scale9Grid == null)
			super.emitTile(ctx, tile);
	}

	public var contentWidth(get, null):Float;

	public function get_contentWidth():Float {
		return getWidth(this);
	}

	public var contentHeight(get, null):Float;

	public function get_contentHeight():Float {
		return getHeight(this);
	}

	public var mouseChildren:Bool = false;

	public var ids:Map<String, h2d.Object>;

	public function get<T:h2d.Object>(id:String, c:Class<T>):T {
		if (ids != null)
			return cast ids.get(id);
		return null;
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
 

	public function get_stageWidth():Float {
		// 待补
		return 100;
		//return Start.current.stageWidth;
	}

	public var stageWidth(get, never):Float;

	public function get_stageHeight():Float {
		// 待补
		return 100;
		//return Start.current.stageHeight;
	}

	public var stageHeight(get, never):Float;

	/**
	 * 布局自身
	 */
	 public function updateLayout():Void {
		layoutIDisplayObject(this);
	}
}
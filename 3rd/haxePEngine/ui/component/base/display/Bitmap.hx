package haxePEngine.ui.component.base.display;

//class Bitmap extends DisplayObject {
class Bitmap extends DisplayObject {
	public var bitmapData:BitmapData;
    private var _bitmapData:h2d.Tile;
	public var bitmapDataFix(get,set):h2d.Tile;
	public var smoothing:Bool;
    public var graphics:haxePEngine.ui.component.hbase.Image;
	/**
	 * 是否有变更，当存在变更时，draw接口会对该图形进行重绘
	 */
    public var dirt:Bool = false;


	function get_bitmapDataFix():h2d.Tile {
		return _bitmapData;
	}

	function set_bitmapDataFix(tile:h2d.Tile):h2d.Tile {
		_bitmapData = tile;
        graphics.tile = bitmapDataFix;
		return tile;
	}

    public function new(?tile:h2d.Tile, ?parent:h2d.Object) {
        _bitmapData = tile;
        graphics = new haxePEngine.ui.component.hbase.Image(_bitmapData,parent);
        graphics.tile = tile;
        super();
    }

    // public function updateTile() {
    //     graphics.tile = bitmapDataFix;
    // }
    
}
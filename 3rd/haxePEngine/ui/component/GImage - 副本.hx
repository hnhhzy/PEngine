package haxePEngine.ui.component;
import haxePEngine.ui.base.FlipType;
import haxePEngine.utils.xml.*;
import haxePEngine.ui.display.UIImage;
import haxePEngine.ui.component.GObject;
import haxePEngine.ui.base.IColorGear;
import haxePEngine.ui.base.PackageItem;
import haxePEngine.ui.utils.ToolSet;
import haxePEngine.ui.component.base.display.Bitmap;
import haxePEngine.ui.component.base.display.BitmapData;
import haxePEngine.ui.component.base.geom.ColorTransform;
import haxePEngine.ui.component.base.geom.Matrix;

class GImage extends GObject implements IColorGear
{
    public var color(get, set):UInt;
    public var flip(get, set):Int;
    public var texture(get, set):BitmapData;

    private var _bmdSource:BitmapData;
    private var _bmdSourceFix:h2d.Tile;


    private var _content:Bitmap;
    private var _color:UInt = 0;
    private var _flip:Int = 0;
    public var _heapsparent:h2d.Object;

    public function new(?parent:h2d.Object)
    {
        _heapsparent = parent;
        _color = 0xFFFFFF;
        super();
    }

    private function get_color():UInt
    {
        return _color;
    }

    private function set_color(value:UInt):UInt
    {
        if (_color != value)
        {
            _color = value;
            updateGear(4);
            applyColor();
        }
        return value;
    }

    private function applyColor():Void
    {
        var ct:ColorTransform = _content.transform.colorTransform;
        ct.redMultiplier = ((_color >> 16) & 0xFF) / 255;
        ct.greenMultiplier = ((_color >> 8) & 0xFF) / 255;
        ct.blueMultiplier = (_color & 0xFF) / 255;
        _content.transform.colorTransform = ct;
    }

    private function get_flip():Int
    {
        return _flip;
    }

    private function set_flip(value:Int):Int
    {
        if (_flip != value)
        {
            _flip = value;
            updateBitmap();
        }
        return value;
    }

    public function get_texture():BitmapData
    {
        return _bmdSource;
    }

    public function set_texture(value:BitmapData):BitmapData
    {
        _bmdSource = value;
        handleSizeChanged();
        return value;
    }

    override private function createDisplayObject():Void
    {
        _content = new UIImage(this, _heapsparent);
        setDisplayObject(_content);
    }

    override public function dispose():Void
    {
        if (!packageItem.loaded)
            packageItem.owner.removeItemCallback(packageItem, __imageLoaded);

        if (_content.bitmapData != null && _content.bitmapData != _bmdSource)
        {
            _content.bitmapData.dispose();
            _content.bitmapData = null;
        }

        super.dispose();
    }

    override public function constructFromResource():Void
    {
        sourceWidth = packageItem.width;
        sourceHeight = packageItem.height;
        initWidth = sourceWidth;
        initHeight = sourceHeight;

        setSize(sourceWidth, sourceHeight);

        if (packageItem.loaded)
            __imageLoaded(packageItem);
        else
            packageItem.owner.addItemCallback(packageItem, __imageLoaded);
    }

    private function __imageLoaded(pi:PackageItem):Void
    {
        // 待补，不确定类型是否一样，已修复
        if (_bmdSourceFix != null)
            return;
        _bmdSourceFix = pi.imageSource;
        _content.bitmapDataFix = _bmdSourceFix;
        _content.smoothing = packageItem.smoothing;
        updateBitmap();
        // if (_bmdSource != null)
        //     return;

        // //_bmdSource = pi.image;
        // _content.bitmapData = _bmdSource;
        // _content.smoothing = packageItem.smoothing;
        //updateBitmap();
    }

    override private function handleSizeChanged():Void
    {
        if (packageItem.scale9Grid == null && !packageItem.scaleByTile || _bmdSource != packageItem.image)
            _sizeImplType = 1;
        else
            _sizeImplType = 0;
        handleScaleChanged();
        updateBitmap();
    }

    private function updateBitmap():Void
    {
        if (_bmdSource == null)
            return;

        var newBmd:BitmapData = _bmdSource;
        var w:Int = Std.int(this.width);
        var h:Int = Std.int(this.height);

        if (w <= 0 || h <= 0)
            newBmd = null;
        else if (_bmdSource == packageItem.image && (_bmdSource.width != w || _bmdSource.height != h))
        {
            if (packageItem.scale9Grid != null)
                newBmd = ToolSet.scaleBitmapWith9Grid(_bmdSource,
                packageItem.scale9Grid, w, h, packageItem.smoothing, packageItem.tileGridIndice);
            else if (packageItem.scaleByTile)
                newBmd = ToolSet.tileBitmap(_bmdSource, _bmdSource.rect, w, h);
        }

        if (newBmd != null && _flip != FlipType.None)
        {
            var mat:Matrix = new Matrix();
            var a:Int = 1;
            var b:Int = 1;
            if (_flip == FlipType.Both)
            {
                mat.scale(-1, -1);
                mat.translate(newBmd.width, newBmd.height);
            }
            else if (_flip == FlipType.Horizontal)
            {
                mat.scale(-1, 1);
                mat.translate(newBmd.width, 0);
            }
            else
            {
                mat.scale(1, -1);
                mat.translate(0, newBmd.height);
            }

            var bmdAfterFlip:BitmapData = new BitmapData(newBmd.width, newBmd.height, newBmd.transparent, 0);
            bmdAfterFlip.draw(newBmd, mat, null, null, null, packageItem.smoothing);

            if (newBmd != _bmdSource)
                newBmd.dispose();

            newBmd = bmdAfterFlip;
        }
        var oldBmd:BitmapData = _content.bitmapData;
        if (oldBmd != newBmd)
        {
            if (oldBmd != null && oldBmd != _bmdSource)
                oldBmd.dispose();
            _content.bitmapData = newBmd;
            _content.smoothing = packageItem.smoothing;
        }
    }

    override public function setup_beforeAdd(xml:FastXML):Void
    {
        super.setup_beforeAdd(xml);

        var str:String;
        str = xml.att.color;
        if (str != null)
            this.color = ToolSet.convertFromHtmlColor(str);

        str = xml.att.flip;
        if (str != null)
            this.flip = FlipType.parse(str);
    }
}

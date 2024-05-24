package haxePEngine.ui.display;


import haxePEngine.ui.component.base.display.Bitmap;

import haxePEngine.ui.component.GObject;

class UIImage extends Bitmap implements UIDisplayObject
{
    public var owner(get, never) : GObject;

    private var _owner : GObject;
    
    public function new(owner : GObject,?tile:h2d.Tile, ?parent:h2d.Object)
    {
        super(tile,parent);
        _owner = owner;
    }
    
    private function get_owner() : GObject
    {
        return _owner;
    }
}



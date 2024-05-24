package haxePEngine.ui.display;


import haxePEngine.ui.component.GObject;
import haxePEngine.ui.component.base.display.Sprite;

class UISprite extends Sprite implements UIDisplayObject
{
    public var owner(get, never) : GObject;

    private var _owner : GObject;
    
    public function new(owner : GObject,?parent:h2d.Object)
    {
        super(parent);
        _owner = owner;
    }
    
    private function get_owner() : GObject
    {
        return _owner;
    }
}


package haxePEngine.ui.display;


import haxePEngine.ui.component.base.text.TextField;

import haxePEngine.ui.component.GObject;

class UITextField extends TextField implements UIDisplayObject
{
    public var owner(get, never) : GObject;

    private var _owner : GObject;
    
    public function new(owner : GObject)
    {
        super();
        _owner = owner;
    }
    
    private function get_owner() : GObject
    {
        return _owner;
    }
}



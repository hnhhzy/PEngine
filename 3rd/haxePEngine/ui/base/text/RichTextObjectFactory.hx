package haxePEngine.ui.base.text;


import haxePEngine.ui.component.base.display.DisplayObject;

import haxePEngine.ui.base.LoaderFillType;
import haxePEngine.ui.component.GLoader;
import haxePEngine.ui.base.PackageItem;
import haxePEngine.ui.base.UIPackage;
import haxePEngine.ui.display.UIDisplayObject;

class RichTextObjectFactory implements IRichTextObjectFactory
{
    public var pool : Array<Dynamic>;
    
    public function new()
    {
        pool = [];
    }
    
    public function createObject(src : String, width : Int, height : Int) : DisplayObject
    {
        var loader : GLoader;
        
        if (pool.length > 0) 
            loader = pool.pop();
        else 
        {
            loader = new GLoader();
            loader.fill = LoaderFillType.ScaleFree;
        }
        loader.url = src;
        
        var pi : PackageItem = UIPackage.getItemByURL(src);
        if (width != 0) 
            loader.width = width;
        else 
        {
            if (pi != null) 
                width = pi.width;
            else 
                width = 20;
            loader.width = width;
        }
        
        if (height != 0) 
            loader.height = height;
        else 
        {
            if (pi != null) 
                height = pi.height;
            else 
                height = 20;
            loader.height = height;
        }
        
        return loader.displayObject;
    }
    
    public function freeObject(obj : DisplayObject) : Void
    {
        var loader : GLoader = cast(cast(obj, UIDisplayObject).owner, GLoader);
        loader.url = null;
        pool.push(loader);
    }
}

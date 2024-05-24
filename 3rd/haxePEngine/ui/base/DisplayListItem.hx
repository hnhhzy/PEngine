package haxePEngine.ui.base;

import haxePEngine.ui.base.PackageItem;
import haxePEngine.utils.xml.*;
class DisplayListItem
{
    public var packageItem : PackageItem;
    public var type : String;
    public var desc : FastXML;
    public var listItemCount : Int = 0;
    
    public function new(packageItem : PackageItem, type : String)
    {
        this.packageItem = packageItem;
        this.type = type;
    }
}

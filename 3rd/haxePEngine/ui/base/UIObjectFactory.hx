package haxePEngine.ui.base;
import haxePEngine.ui.component.GObject;
import haxePEngine.ui.component.GImage;
import haxePEngine.ui.component.GMovieClip;
import haxePEngine.ui.component.GSwfObject;
import haxePEngine.ui.component.GButton;
import haxePEngine.ui.component.GLabel;
import haxePEngine.ui.component.GProgressBar;
import haxePEngine.ui.component.GSlider;
import haxePEngine.ui.component.GScrollBar;
import haxePEngine.ui.component.GComboBox;
import haxePEngine.ui.component.GComponent;
import haxePEngine.ui.component.GTextField;
import haxePEngine.ui.component.GRichTextField;
import haxePEngine.ui.component.GTextInput;
import haxePEngine.ui.component.GGroup;
import haxePEngine.ui.component.GList;
import haxePEngine.ui.component.GGraph;
import haxePEngine.ui.component.GLoader;
import haxePEngine.utils.xml.*;
import haxePEngine.ui.component.base.error.Error;

class UIObjectFactory
{
    @:allow(haxePEngine)
    private static var packageItemExtensions : Map<String, Class<Dynamic>> = new Map<String, Class<Dynamic>>();
    private static var loaderType : Class<Dynamic>;
    
    public function new()
    {
    }
    
    public static function setPackageItemExtension(url : String, type : Class<Dynamic>) : Void
    {
        if (url == null)
            throw new Error("Invaild url: " + url);

        var pi:PackageItem = UIPackage.getItemByURL(url);
        if (pi != null)
            pi.extensionType = type;

        packageItemExtensions[url] = type;
    }
    
    public static function setLoaderExtension(type : Class<Dynamic>) : Void
    {
        loaderType = type;
    }

    @:allow(haxePEngine)
    private static function resolvePackageItemExtension(pi:PackageItem):Void
    {
        pi.extensionType = packageItemExtensions["ui://" + pi.owner.id + pi.id];
        if(pi.extensionType == null)
            pi.extensionType = packageItemExtensions["ui://" + pi.owner.name + "/" + pi.name];
    }
    
    public static function newObject(pi : PackageItem,?parent:h2d.Object) : GObject
    {
        switch (pi.type)
        {
            case PackageItemType.Image:
                return new GImage(parent);
            
            case PackageItemType.MovieClip:
                return new GMovieClip();
            
            case PackageItemType.Swf:
                return new GSwfObject();
            
            case PackageItemType.Component:
            {
                var cls : Class<Dynamic> = pi.extensionType;
                if (cls != null) 
                    return Type.createInstance(cls, [parent]);
                
                var xml : FastXML = pi.owner.getComponentData(pi);
                var extention : String = xml.att.extention;
                if (extention != null) 
                {
                    switch (extention)
                    {
                        case "Button":
                            return new GButton(parent);
                        
                        case "Label":
                            return new GLabel();
                        
                        case "ProgressBar":
                            return new GProgressBar();
                        
                        case "Slider":
                            return new GSlider();
                        
                        case "ScrollBar":
                            return new GScrollBar();
                        
                        case "ComboBox":
                            return new GComboBox();
                        
                        default:
                            return new GComponent(parent);
                    }
                }
                else 
                    return new GComponent(parent);
            }
        }
        return null;
    }
    
    public static function newObject2(type : String,?parent:h2d.Object) : GObject
    {
        switch (type)
        {
            case "image":
                return new GImage(parent);
            
            case "movieclip":
                return new GMovieClip();
            
            case "swf":
                return new GSwfObject();
            
            case "component":
                return new GComponent(parent);
            
            case "text":
                return new GTextField(parent);
            
            case "richtext":
                return new GRichTextField();
            
            case "inputtext":
                return new GTextInput(parent);
            
            case "group":
                return new GGroup();
            
            case "list":
                return new GList();
            
            case "graph":
                return new GGraph();
            
            case "loader":
                if (loaderType != null)
                    return Type.createInstance(loaderType, []);
                else 
                    return new GLoader();
        }
        return null;
    }
}

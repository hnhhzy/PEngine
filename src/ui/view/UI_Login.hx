/** This is an automatically generated class by FairyGUI. Please do not modify it. **/

package ui.view;
import haxePEngine.utils.xml.FastXML;
import haxePEngine.ui.base.UIPackage;
import haxePEngine.ui.component.*;

class UI_Login extends GComponent {
    public var m_txtAccount:GTextInput;
    public var m_txtPassword:GTextInput;
    public var m_btnLogin:GButton;
    public static inline var URL:String = "ui://fp95u1e6p70y0";

    public static function createInstance(?parent:h2d.Object):UI_Login {
        return cast(UIPackage.createObject("View", "Login", null, parent), UI_Login);
    }

    private override function constructFromXML(xml:FastXML):Void {
        super.constructFromXML(xml);

        m_txtAccount = cast(this.getChild("txtAccount"), GTextInput);
        m_txtPassword = cast(this.getChild("txtPassword"), GTextInput);
        m_btnLogin = cast(this.getChild("btnLogin"), GButton);
    }
}
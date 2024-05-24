package haxePEngine.ui.component;
import haxePEngine.utils.xml.*;
import haxePEngine.ui.component.base.events.Event;
import haxePEngine.ui.component.base.events.FocusEvent;
import haxePEngine.ui.component.base.events.KeyboardEvent;
import haxePEngine.ui.component.base.text.TextFieldType;

import haxePEngine.ui.utils.ToolSet;

//class GTextInput extends GTextField
class GTextInput extends GTextField
{
    public var maxLength(get, set) : Int;
    public var editable(get, set) : Bool;
    public var promptText(get, set) : String;
    public var restrict(get, set) : String;
    public var password(get, set) : Bool;

    private var _changed : Bool = false;
    private var _promptText : String = "";
    private var _password : Bool = false;

    public var disableIME:Bool = false;
    
    public function new(?parent:h2d.Object)
    {
        super(parent);
        this.focusable = true;

        // 待补
        //_textField.wordWrap = true;
        
        _textField.addEventListener(KeyboardEvent.KEY_DOWN, __textChanged);
        _textField.addEventListener(Event.CHANGE, __textChanged);
        _textField.addEventListener(FocusEvent.FOCUS_IN, __focusIn);
        _textField.addEventListener(FocusEvent.FOCUS_OUT, __focusOut);
    }
    
    private function set_maxLength(val : Int) : Int
    {
        // 待补
        //_textField.maxChars = val;
        return val;
    }
    
    private function get_maxLength() : Int
    {
        // 待补
        return 10;
        //return _textField.maxChars;
    }
    
    private function set_editable(val : Bool) : Bool
    {
        // 待补
        // if (val) 
        // {
        //     _textField.type = TextFieldType.INPUT;
        //     _textField.selectable = true;
        // }
        // else 
        // {
        //     _textField.type = TextFieldType.DYNAMIC;
        //     _textField.selectable = false;
        // }
        return val;
    }
    
    private function get_editable() : Bool
    {
        // 待补
        return true;
        //return _textField.type == TextFieldType.INPUT;
    }
    
    private function get_promptText() : String
    {
        return _promptText;
    }
    
    private function set_promptText(value : String) : String
    {
        _promptText = value;
        renderNow();
        return value;
    }
    
    private function get_restrict() : String
    {
        // 待补
        return "";
        //return _textField.restrict;
    }
    
    private function set_restrict(value : String) : String
    {
        // 待补
        //_textField.restrict = value;
        return value;
    }
    
    private function get_password() : Bool
    {
        return _password;
    }
    
    private function set_password(val : Bool) : Bool
    {
        if (_password != val) 
        {
            _password = val;
            render();
        }
        return val;
    }
    
    override private function createDisplayObject() : Void
    {
        this.type = TextFieldType.INPUT;
        super.createDisplayObject();

        // 待补
        // _textField.selectable = true;
        _textField.mouseEnabled = true;
    }
    
    override private function get_text() : String
    {
        if (_changed) 
        {
            _changed = false;

            _text = StringTools.replace(_textField.text, "\r\n", "\n");
            _text = StringTools.replace(_text, "\r", "\n");
        }
        return _text;
    }

    override private function updateAutoSize():Void
    {
        //输入文本不支持自动大小
    }
    
    override private function render() : Void
    {
        renderNow(true);
    }

    override private function renderNow(updateBounds : Bool = true) : Void
    {
        var w:Float;
        var h:Float;
        w = this.width;

        if(w!=_textInput.width)
            _textInput.width = w;
        // 待补 不确定是否正确，去除字体调整
        h = this.height;
        //h = this.height+_fontAdjustment+1;

        if(h!=_textInput.height)
            _textInput.height = h;

        // 待补，下一行不需要调整
        //_yOffset = -_fontAdjustment;
        _textInput.y = this.y + _yOffset;

        // if(w!=_textField.width)
        //     _textField.width = w;
        // h = this.height+_fontAdjustment+1;

        // if(h!=_textField.height)
        //     _textField.height = h;

        // _yOffset = -_fontAdjustment;
        // _textField.y = this.y + _yOffset;
        
        // 待补
        // if (_text == "" && _promptText != "")
        // {
        //     _textField.displayAsPassword = false;
        //     _textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(_promptText));
        // }
        // else 
        // {
        //     _textField.displayAsPassword = _password;
        //     _textField.text = _text;
        // }
        _changed = false;
    }
    
    override private function handleSizeChanged() : Void
    {
        _textInput.width = this.width;
      // _textInput.height = this.height + _fontAdjustment;
      // 待补 不确定是否正确，去除字体调整
      _textInput.height = this.height;
    }
    
    override public function setup_beforeAdd(xml : FastXML) : Void
    {
        super.setup_beforeAdd(xml);

        var str : String;
        str = xml.att.prompt;
        if (str != null)
            _promptText = str;

        // 待补
        // str = xml.att.maxLength;
        // if (str != null)
        //     _textField.maxChars = Std.parseInt(str);

        // str = xml.att.restrict;
        // if (str != null) 
        //     _textField.restrict = str;
        _password = xml.att.password == "true";
    }
    
    override public function setup_afterAdd(xml : FastXML) : Void
    {
        super.setup_afterAdd(xml);
        
        // 待补
        // if (_text == "")
        // {
        //     if (_promptText != "")
        //     {
        //         _textField.displayAsPassword = false;
        //         _textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(_promptText));
        //     }
        // }
    }
    
    private function __textChanged(evt : Event) : Void
    {
        // 待补
        // _changed = true;
        // TextInputHistory.inst.markChanged(_textField);
    }
    
    private function __focusIn(evt : Event) : Void
    {
        // 待补
        // #if flash
        // if(disableIME && haxePEngine.ui.component.base.system.Capabilities.hasIME)
        //     flash.system.IME.enabled = false;
        // #end

        // if (_text == "" && _promptText != "")
        // {
        //     _textField.displayAsPassword = _password;
        //     _textField.text = "";
        // }
        // TextInputHistory.inst.startRecord(_textField);
    }
    
    private function __focusOut(evt : Event) : Void
    {
        // 待补
        // #if flash
        // if(disableIME && haxePEngine.ui.component.base.system.Capabilities.hasIME)
        //     flash.system.IME.enabled = true;
        // #end

        // _text = _textField.text;
        // TextInputHistory.inst.stopRecord(_textField);
        // _changed = false;
        
        // if (_text == "" && _promptText != "")
        // {
        //     _textField.displayAsPassword = false;
        //     _textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(_promptText));
        // }
    }
}

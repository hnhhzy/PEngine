package haxePEngine.ui.base;
import haxePEngine.utils.xml.*;
import haxePEngine.ui.base.action.ControllerAction;
import haxePEngine.ui.base.action.PlayTransitionAction;
import haxePEngine.ui.base.event.StateChangeEvent;
import haxePEngine.ui.component.GComponent;
import haxePEngine.utils.xml.FastXMLList;
import haxePEngine.ui.component.base.error.Error;
import haxePEngine.ui.component.base.events.EventDispatcher;
import haxePEngine.ui.component.base.Vector;

@:meta(Event(name = "stateChanged", type = "haxePEngine.ui.base.event.StateChangeEvent"))

class Controller extends EventDispatcher
{
    public var name(get, set):String;
    public var parent(get, never):GComponent;
    public var selectedIndex(get, set):Int;
    public var previsousIndex(get, never):Int;
    public var selectedPage(get, set):String;
    public var previousPage(get, never):String;
    public var pageCount(get, never):Int;
    public var selectedPageId(get, set):String;
    public var oppositePageId(never, set):String;
    public var previousPageId(get, never):String;

    private var _name:String;
    private var _selectedIndex:Int = 0;
    private var _previousIndex:Int = 0;
    private var _pageIds:Array<Dynamic>;
    private var _pageNames:Array<Dynamic>;
    private var _actions:Vector<ControllerAction>;

    @:allow(haxePEngine)
    private var _parent:GComponent;
    @:allow(haxePEngine)
    private var _autoRadioGroupDepth:Bool = false;

    public var changing:Bool = false;

    private static var _nextPageId:Int = 0;

    public function new()
    {
        super();
        this._pageIds = [];
        this._pageNames = [];
        this._selectedIndex = -1;
        this._previousIndex = -1;
    }

    private function get_name():String
    {
        return _name;
    }

    private function set_name(value:String):String
    {
        _name = value;
        return value;
    }

    private function get_parent():GComponent
    {
        return _parent;
    }

    private function get_selectedIndex():Int
    {
        return this._selectedIndex;
    }

    private function set_selectedIndex(value:Int):Int
    {
        if (this._selectedIndex != value)
        {
            if (value > this._pageIds.length - 1)
                throw new Error("index out of bounds: " + value);

            changing = true;

            this._previousIndex = this._selectedIndex;
            this._selectedIndex = value;
            _parent.applyController(this);

            this.dispatchEvent(new StateChangeEvent(StateChangeEvent.CHANGED));

            changing = false;
        }
        return value;
    }

    //功能和设置selectedIndex一样，但不会触发事件
    public function setSelectedIndex(value:Int):Void
    {
        if (this._selectedIndex != value)
        {
            if (value > this._pageIds.length - 1)
                throw new Error("index out of bounds: " + value);

            changing = true;

            this._previousIndex = this._selectedIndex;
            this._selectedIndex = value;
            _parent.applyController(this);

            changing = false;
        }
    }

    private function get_previsousIndex():Int
    {
        return this._previousIndex;
    }

    private function get_selectedPage():String
    {
        if (this._selectedIndex == -1)
            return null;
        else
            return this._pageNames[this._selectedIndex];
    }

    private function set_selectedPage(val:String):String
    {
        var i:Int = Lambda.indexOf(this._pageNames, val);
        if (i == -1)
            i = 0;
        this.selectedIndex = i;
        return val;
    }

    //功能和设置selectedPage一样，但不会触发事件
    public function setSelectedPage(value:String):Void
    {
        var i:Int = Lambda.indexOf(this._pageNames, value);
        if (i == -1)
            i = 0;
        this.setSelectedIndex(i);
    }

    private function get_previousPage():String
    {
        if (this._previousIndex == -1)
            return null;
        else
            return this._pageNames[this._previousIndex];
    }

    private function get_pageCount():Int
    {
        return this._pageIds.length;
    }

    public function getPageName(index:Int):String
    {
        return this._pageNames[index];
    }

    public function addPage(name:String = ""):Void
    {
        addPageAt(name, this._pageIds.length);
    }

    public function addPageAt(name:String, index:Int):Void
    {
        var nid:String = "_" + (_nextPageId++);
        if (index == this._pageIds.length)
        {
            this._pageIds.push(nid);
            this._pageNames.push(name);
        }
        else
        {
            this._pageIds.insert(index + 1, nid);
            this._pageNames.insert(index + 1, name);
        }
    }

    public function removePage(name:String):Void
    {
        var i:Int = Lambda.indexOf(this._pageNames, name);
        if (i != -1)
        {
            this._pageIds.splice(i, 1);
            this._pageNames.splice(i, 1);
            if (this._selectedIndex >= this._pageIds.length)
                this.selectedIndex = this._selectedIndex - 1;
            else
                _parent.applyController(this);
        }
    }

    public function removePageAt(index:Int):Void
    {
        this._pageIds.splice(index, 1);
        this._pageNames.splice(index, 1);
        if (this._selectedIndex >= this._pageIds.length)
            this.selectedIndex = this._selectedIndex - 1;
        else
            _parent.applyController(this);
    }

    public function clearPages():Void
    {
        this._pageIds.splice(0, this._pageIds.length);
        this._pageNames.splice(0, this._pageNames.length);
        if (this._selectedIndex != -1)
            this.selectedIndex = -1;
        else
            _parent.applyController(this);
    }

    public function hasPage(aName:String):Bool
    {
        return Lambda.indexOf(this._pageNames, aName) != -1;
    }

    public function getPageIndexById(aId:String):Int
    {
        return Lambda.indexOf(this._pageIds, aId);
    }

    public function getPageIdByName(aName:String):String
    {
        var i:Int = Lambda.indexOf(this._pageNames, aName);
        if (i != -1)
            return this._pageIds[i];
        else
            return null;
    }

    public function getPageNameById(aId:String):String
    {
        var i:Int = Lambda.indexOf(this._pageIds, aId);
        if (i != -1)
            return this._pageNames[i];
        else
            return null;
    }

    public function getPageId(index:Int):String
    {
        return this._pageIds[index];
    }

    private function get_selectedPageId():String
    {
        if (this._selectedIndex == -1)
            return null;
        else
            return this._pageIds[this._selectedIndex];
    }

    private function set_selectedPageId(val:String):String
    {
        var i:Int = Lambda.indexOf(this._pageIds, val);
        this.selectedIndex = i;
        return val;
    }

    private function set_oppositePageId(val:String):String
    {
        var i:Int = Lambda.indexOf(this._pageIds, val);
        if (i > 0)
            this.selectedIndex = 0;
        else if (this._pageIds.length > 1)
            this.selectedIndex = 1;
        return val;
    }

    private function get_previousPageId():String
    {
        if (this._previousIndex == -1)
            return null;
        else
            return this._pageIds[this._previousIndex];
    }

    public function runActions():Void
    {
        if (_actions != null)
        {
            var cnt:Int = _actions.length;
            for (i in 0...cnt)
            {
                _actions[i].run(this, previousPageId, selectedPageId);
            }
        }
    }

    public function setup(xml:FastXML):Void
    {
        _name = xml.att.name;
        _autoRadioGroupDepth = xml.att.autoRadioGroupDepth == "true";

        var i:Int;
        var k:Int;
        var cnt:Int;
        var arr:Array<String>;
        var str:String = xml.att.pages;
        if (str != null)
        {
            arr = str.split(",");
            cnt = arr.length;
            i = 0;
            while (i < cnt)
            {
                this._pageIds.push(arr[i]);
                this._pageNames.push(arr[i + 1]);
                i += 2;
            }
        }

        var col:FastXMLList = xml.nodes.action;
        if (col.length() > 0)
        {
            _actions = new Vector<ControllerAction>();

            for (cxml in col.iterator())
            {
                var action:ControllerAction = ControllerAction.createAction(cxml.att.type);
                action.setup(cxml);
                _actions.push(action);
            }
        }

        str = xml.att.transitions;
        if (str != null)
        {
            if (_actions == null)
                _actions = new Vector<ControllerAction>();

            arr = str.split(",");
            cnt = arr.length;

            for (i in 0...cnt)
            {
                str = arr[i];
                if (str == null)
                    continue;

                var taction:PlayTransitionAction = new PlayTransitionAction();
                k = str.indexOf("=");
                taction.transitionName = str.substr(k + 1);
                str = str.substring(0, k);
                k = str.indexOf("-");
                var ii:Int = Std.parseInt(str.substring(k + 1));
                if (ii < _pageIds.length)
                    taction.toPage = [_pageIds[ii]];
                str = str.substring(0, k);
                if (str != "*")
                {
                    ii = Std.parseInt(str);
                    if (ii < _pageIds.length)
                        taction.fromPage = [_pageIds[ii]];
                }
                taction.stopOnExit = true;
                _actions.push(taction);
            }
        }

        if (_parent != null && this._pageIds.length > 0)
            this._selectedIndex = 0;
        else
            this._selectedIndex = -1;
    }
}

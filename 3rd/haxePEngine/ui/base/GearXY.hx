package haxePEngine.ui.base;

import tweenx909.TweenX;
import haxePEngine.ui.component.GObject;

import haxePEngine.ui.component.base.geom.Point;

class GearXY extends GearBase
{
    public var tweener:TweenX;

    private var _storage:Map<String, Point>;
    private var _default:Point;
    private var _tweenValue:Point;

    public function new(owner:GObject)
    {
        super(owner);
    }

    override private function init():Void
    {
        _default = new Point(_owner.x, _owner.y);
        _storage = new Map<String, Point>();
    }

    override private function addStatus(pageId:String, value:String):Void
    {
        if (value == "-" || value.length == 0)
            return;

        var arr:Array<String> = value.split(",");
        var pt:Point;
        if (pageId == null)
            pt = _default;
        else
        {
            pt = new Point();
            _storage[pageId] = pt;
        }
        pt.x = Std.parseInt(arr[0]);
        pt.y = Std.parseInt(arr[1]);
    }

    override public function apply():Void
    {
        var pt:Point = _storage[_controller.selectedPageId];
        if (pt == null)
            pt = _default;

        if (_tween && UIPackage._constructing <= 0 && !GearBase.disableAllTweenEffect)
        {
            if (tweener != null)
            {
                if (tweener.vars.x != pt.x || tweener.vars.y != pt.y)
                {
                    _owner._gearLocked = true;
                    _owner.setXY(tweener.vars.x, tweener.vars.y);
                    _owner._gearLocked = false;
                    tweener.stop();
                    tweener = null;
                    _owner.releaseDisplayLock(_displayLockToken);
                    _displayLockToken = 0;
                }
                else
                    return;
            }

            if (_owner.x != pt.x || _owner.y != pt.y)
            {
                if (_owner.checkGearController(0, _controller))
                    _displayLockToken = _owner.addDisplayLock();
                var vars =
                {
                    x : pt.x,
                    y : pt.y
                };
                if (_tweenValue == null)
                    _tweenValue = new Point();
                _tweenValue.x = _owner.x;
                _tweenValue.y = _owner.y;
                tweener = TweenX.to(_tweenValue, vars, _tweenTime).ease(_easeType).delay(_delay).onUpdate(__tweenUpdate).onFinish(__tweenComplete);
            }
        }
        else
        {
            _owner._gearLocked = true;
            _owner.setXY(pt.x, pt.y);
            _owner._gearLocked = false;
        }
    }

    private function __tweenUpdate():Void
    {
        _owner._gearLocked = true;
        _owner.setXY(_tweenValue.x, _tweenValue.y);
        _owner._gearLocked = false;
    }

    private function __tweenComplete():Void
    {
        if (_displayLockToken != 0)
        {
            _owner.releaseDisplayLock(_displayLockToken);
            _displayLockToken = 0;
        }
        tweener = null;
    }

    override public function updateState():Void
    {
        var pt:Point = _storage[_controller.selectedPageId];
        if (pt == null)
        {
            pt = new Point();
            _storage[_controller.selectedPageId] = pt;
        }

        pt.x = _owner.x;
        pt.y = _owner.y;
    }

    override public function updateFromRelations(dx:Float, dy:Float):Void
    {
        if (_controller == null || _storage == null)
            return;

        for (i in _storage.keys())
        {
            var pt:Point = _storage.get(i);
            pt.x += dx;
            pt.y += dy;
        }
        _default.x += dx;
        _default.y += dy;

        updateState();
    }
}


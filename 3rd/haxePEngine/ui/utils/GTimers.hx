package haxePEngine.ui.utils;

import haxePEngine.ui.component.base.events.TimerEvent;
import haxePEngine.ui.component.base.utils.Timer;
import haxePEngine.ui.component.base.Lib;


class GTimers
{


    private var _items : Array<TimerItem>;
    private var _itemPool : Array<TimerItem>;
    private var _timer : Timer;

    private var _lastTime : Int = 0;

    private var _enumI : Int = 0;
    private var _enumCount : Int = 0;

    public static var deltaTime : Int = 0;
    public static var time : Int = 0;
    public static var workCount : Int = 0;

    private static var FPS24 : Int = Std.int(1000 / 24);

    public static var _inst:GTimers;
    public static var inst(get, never):GTimers;
    private static function get_inst():GTimers
    {
        if (_inst == null)
            new GTimers();
        return _inst;
    }

    public function new()
    {
        if (_inst == null)
            _inst = this;

        _items = new Array<TimerItem>();
        _itemPool = new Array<TimerItem>();

        deltaTime = 1;
        _lastTime = Lib.getTimer();
        time = _lastTime;

        _timer = new Timer(10);
        _timer.addEventListener(TimerEvent.TIMER, __timer);
        _timer.start();
    }

    private function getItem() : TimerItem
    {
        if (_itemPool.length > 0)
            return _itemPool.pop();
        else
            return new TimerItem();
    }

    private function findItem(callback: Dynamic): TimerItem
    {
        var len: Int = this._items.length;
        for (i in 0...len)
        {
            var item: TimerItem = this._items[i];
            if ( Reflect.compareMethods ( item.callback, callback ) )
                return item;
        }
        return null;
    }

    public function add(delayInMiniseconds : Int, repeat : Int, callback : Dynamic, callbackParam : Dynamic = null) : Void{
        var item : TimerItem = findItem(callback);
        if (item == null)
        {
            item = getItem();
            item.callback = callback;
            item.hasParam = callbackParam!=null;
            _items.push(item);
        }
        item.delay = delayInMiniseconds;
        item.counter = 0;
        item.repeat = repeat;
        item.param = callbackParam;
        item.end = false;
    }

    public function callLater(callback : Dynamic, callbackParam : Dynamic = null) : Void
    {
        add(1, 1, callback, callbackParam);
    }

    public function callDelay(delay : Int, callback : Dynamic, callbackParam : Dynamic = null) : Void
    {
        add(delay, 1, callback, callbackParam);
    }

    public function callBy24Fps(callback : Dynamic, callbackParam : Dynamic = null) : Void
    {
        add(FPS24, 0, callback, callbackParam);
    }

    public function exists(callback : Dynamic) : Bool{
        return findItem(callback) != null;
    }

    public function remove(callback : Dynamic) : Void{
        var item : TimerItem = findItem(callback);
        if (item != null)
        {
            var i : Int = _items.indexOf(item);
            _items.splice(i, 1);
            if (i < _enumI)
                _enumI--;
            _enumCount--;

            item.callback = null;
            item.param = null;
            _itemPool.push(item);
        }
    }

    private function __timer(evt : TimerEvent) : Void{
        time = Lib.getTimer();
        workCount++;

        deltaTime = Std.int(time - _lastTime);
        _lastTime = time;

        if (deltaTime > 125)
            deltaTime = 125;

        _enumI = 0;
        _enumCount = _items.length;

        while (_enumI < _enumCount)
        {
            var item : TimerItem = _items[_enumI];
            _enumI++;

            if (item.advance(deltaTime)) {
                if (item.end)
                {
                    _enumI--;
                    _enumCount--;
                    _items.splice(_enumI, 1);
                    _itemPool.push(item);
                }

                if (item.hasParam)
                    item.callback(item.param);
                else
                    item.callback();
            }
        }
    }
}


class TimerItem
{
    public var delay : Int;
    public var counter : Int;
    public var repeat : Int;
    public var callback : Dynamic;
    public var param : Dynamic;

    public var hasParam : Bool;
    public var end : Bool;

    public function new()
    {
    }

    public function advance(elapsed : Int) : Bool
    {
        counter += elapsed;
        if (counter >= delay) {
            counter -= delay;
            if (counter > delay)
                counter = delay;

            if (repeat > 0)
            {
                repeat--;
                if (repeat == 0)
                    end = true;
            }

            return true;
        }
        else
        return false;
    }
}

package haxePEngine.ui.display;


import haxePEngine.ui.utils.GTimers;

class PlayState
{
    public var currentFrame(get, set):Int;

    public var reachEnding:Bool; //是否已播放到结尾
    public var reversed:Bool; //是否已反向播放
    public var repeatedCount:Int; //重复次数

    private var _curFrame:Int; //当前帧
    private var _curFrameDelay:Int; //当前帧延迟
    private var _lastUpdateSeq:Int;

    public function new()
    {
    }

    public function update(mc:MovieClip):Void
    {
        var elapsed:Float;
        var frameId:UInt = GTimers.workCount;
        if (frameId - _lastUpdateSeq != 1)
        {
            //1、如果>1，表示不是连续帧了，说明刚启动（或者停止过），这里不能用流逝的时间了，不然会跳过很多帧
            //2、如果==0，表示在本帧已经处理过了，这通常是因为一个PlayState用于多个MovieClip共享，目的是多个MovieClip同步播放
            elapsed = 0;
        }
        else
            elapsed = GTimers.deltaTime;
        _lastUpdateSeq = frameId;

        reachEnding = false;
        _curFrameDelay += Std.int(elapsed);
        var interval:Int = mc.interval + mc.frames[_curFrame].addDelay + ((_curFrame == 0 && repeatedCount > 0) ? mc.repeatDelay : 0);
        if (_curFrameDelay < interval)
            return;

        _curFrameDelay -= interval;
        if (_curFrameDelay > mc.interval)
            _curFrameDelay = mc.interval;

        if (mc.swing)
        {
            if (reversed)
            {
                _curFrame--;
                if (_curFrame <= 0)
                {
                    _curFrame = 0;
                    repeatedCount++;
                    reversed = !reversed;
                }
            }
            else
            {
                _curFrame++;
                if (_curFrame > mc.frameCount - 1)
                {
                    _curFrame = Std.int(Math.max(0, mc.frameCount - 2));
                    repeatedCount++;
                    reachEnding = true;
                    reversed = !reversed;
                }
            }
        }
        else
        {
            _curFrame++;
            if (_curFrame > mc.frameCount - 1)
            {
                _curFrame = 0;
                repeatedCount++;
                reachEnding = true;
            }
        }
    }

    private function get_currentFrame():Int
    {
        return _curFrame;
    }

    private function set_currentFrame(value:Int):Int
    {
        _curFrame = value;
        _curFrameDelay = 0;
        return value;
    }

    public function rewind():Void
    {
        _curFrame = 0;
        _curFrameDelay = 0;
        reversed = false;
        reachEnding = false;
    }

    public function reset():Void
    {
        _curFrame = 0;
        _curFrameDelay = 0;
        repeatedCount = 0;
        reachEnding = false;
        reversed = false;
    }

    public function copy(src:PlayState):Void
    {
        _curFrame = src._curFrame;
        _curFrameDelay = src._curFrameDelay;
        repeatedCount = src.repeatedCount;
        reachEnding = src.reachEnding;
        reversed = src.reversed;
    }
}

package haxePEngine.ui.component;

import hxd.System;
import haxePEngine.utils.xml.*;
import haxePEngine.ui.base.*;
import haxePEngine.ui.display.UISprite;
import haxePEngine.ui.component.GGroup;
import haxePEngine.ui.component.GObject;
import haxePEngine.ui.base.Margin;
import haxePEngine.ui.base.ScrollPane;
import haxePEngine.ui.base.Transition;
import haxePEngine.ui.utils.CompatUtil;
import haxePEngine.ui.utils.GTimers;
import haxePEngine.ui.utils.PixelHitTest;
import haxePEngine.ui.component.base.display.DisplayObject;
import haxePEngine.ui.component.base.display.DisplayObjectContainer;
import haxePEngine.ui.component.base.display.Graphics;
import haxePEngine.ui.component.base.display.Sprite;
import haxePEngine.ui.component.base.error.ArgumentError;
import haxePEngine.ui.component.base.error.Error;
import haxePEngine.ui.component.base.error.RangeError;
// 待补充 haxePEngine.ui.component.base.events.Event
import haxePEngine.ui.component.base.events.Event;
import haxePEngine.ui.component.base.geom.Point;
import haxePEngine.ui.component.base.geom.Rectangle;

@:meta(Event(name = "dropEvent", type = "haxePEngine.ui.base.event.DropEvent"))

class GComponent extends GObject
{
    public var displayListContainer(get, never):DisplayObjectContainer;
    public var numChildren(get, never):Int;
    public var controllers(get, never):Array<Controller>;
    public var scrollPane(get, never):ScrollPane;
    public var opaque(get, set):Bool;
    public var margin(get, set):Margin;
    public var childrenRenderOrder(get, set):Int;
    public var apexIndex(get, set):Int;
    public var mask(get, set):DisplayObject;
    public var viewWidth(get, set):Int;
    public var viewHeight(get, set):Int;
    public var hitArea(get, set):PixelHitTest;
    private var _applyingController:Controller;

    private var _sortingChildCount:Int = 0;
    private var _opaque:Bool = false;
    private var _hitArea:PixelHitTest;

    private var _margin:Margin;
    private var _trackBounds:Bool = false;
    private var _boundsChanged:Bool = false;
    private var _childrenRenderOrder:Int = 0;
    private var _apexIndex:Int = 0;

    @:allow(haxePEngine)
    private var _buildingDisplayList:Bool = false;
    @:allow(haxePEngine)
    private var _children:Array<GObject>;
    @:allow(haxePEngine)
    private var _controllers:Array<Controller>;
    @:allow(haxePEngine)
    private var _transitions:Array<Transition>;
    @:allow(haxePEngine)
    private var _rootContainer:Sprite;
    @:allow(haxePEngine)
    private var _rootContainer2:haxePEngine.ui.component.hbase.Box;
    @:allow(haxePEngine)
    private var _container:Sprite;
    private var _container2:haxePEngine.ui.component.hbase.Box;
    @:allow(haxePEngine)
    private var _scrollPane:ScrollPane;
    @:allow(haxePEngine)
    private var _alignOffset:Point;
    public var _heapsparent:h2d.Object;

    public function new(?parent:h2d.Object)
    {
        _heapsparent = parent;
        _children = new Array<GObject>();
        _controllers = new Array<Controller>();
        _transitions = new Array<Transition>();
        _margin = new Margin();
        _alignOffset = new Point();
        super();
    }

    // 创建显示对象
    override private function createDisplayObject():Void
    {
        _rootContainer = new UISprite(this, _heapsparent);
        _rootContainer.mouseEnabled = false;

        _rootContainer2 = new haxePEngine.ui.component.hbase.Box(_heapsparent);
        setDisplayObject(_rootContainer);
        setDisplayObject2(_rootContainer2);
        _container = _rootContainer;
        _container2 = _rootContainer2;
    }

    override public function dispose():Void
    {
        var i:Int;

        var transCnt:Int = _transitions.length;
        for (i in 0...transCnt)
        {
            var trans:Transition = _transitions[i];
            trans.dispose();
        }

        var numChildren:Int = _children.length;
        i = numChildren - 1;
        while (i >= 0)
        {
            var obj:GObject = _children[i];
            obj.parent = null; //avoid removeFromParent call
            obj.dispose();
            --i;
        }

        _boundsChanged = false;
        super.dispose();
    }

    // api
    @:final private function get_displayListContainer():DisplayObjectContainer
    {
        return _container;
    }

    public function addChild(child:GObject):GObject
    {
        addChildAt(child, _children.length);
        return child;
    }

    public function addChildAt(child:GObject, index:Int):GObject
    {
        if (child == null)
            throw new Error("child is null");

        var numChildren:Int = _children.length;

        if (index >= 0 && index <= numChildren)
        {
            if (child.parent == this)
            {
                setChildIndex(child, index);
            }
            else
            {
                child.removeFromParent();
                child.parent = this;

                var cnt:Int = _children.length;
                if (child.sortingOrder != 0)
                {
                    _sortingChildCount++;
                    index = getInsertPosForSortingChild(child);
                }
                else if (_sortingChildCount > 0)
                {
                    if (index > (cnt - _sortingChildCount))
                        index = cnt - _sortingChildCount;
                }

                if (index == cnt)
                    _children.push(child);
                else
                    _children.insert(index + 1, child);

                childStateChanged(child);
                setBoundsChangedFlag();
            }

            return child;
        }
        else
        {
            throw new RangeError("Invalid child index");
        }
    }

    private function getInsertPosForSortingChild(target:GObject):Int
    {
        var cnt:Int = _children.length;
        var i:Int = 0;
        for (i in 0...cnt)
        {
            var child:GObject = _children[i];
            if (child == target)
                continue;

            if (target.sortingOrder < child.sortingOrder)
                break;
        }
        return i;
    }

    public function removeChild(child:GObject, dispose:Bool = false):GObject
    {
        var childIndex:Int = Lambda.indexOf(_children, child);
        if (childIndex != -1)
        {
            removeChildAt(childIndex, dispose);
        }
        return child;
    }

    public function removeChildAt(index:Int, dispose:Bool = false):GObject
    {
        if (index >= 0 && index < numChildren)
        {
            var child:GObject = _children[index];
            child.parent = null;

            if (child.sortingOrder != 0)
                _sortingChildCount--;

            _children.splice(index, 1);
            child.group = null;
            if (child.inContainer)
            {
                _container.removeChild(child.displayObject);

                if (_childrenRenderOrder == ChildrenRenderOrder.Arch)
                    GTimers.inst.callLater(buildNativeDisplayList);
            }

            if (dispose)
                child.dispose();

            setBoundsChangedFlag();

            return child;
        }
        else
        {
            throw new RangeError("Invalid child index");
        }
    }

    public function removeChildren(beginIndex:Int = 0, endIndex:Int = -1, dispose:Bool = false):Void
    {
        if (endIndex < 0 || endIndex >= numChildren)
            endIndex = numChildren - 1;

        for (i in beginIndex...endIndex + 1)
        {
            removeChildAt(beginIndex, dispose);
        }
    }

    public function getChildAt(index:Int):GObject
    {
        if (index >= 0 && index < numChildren)
            return _children[index];
        else
            throw new RangeError("Invalid child index");
    }

    public function getChild(name:String):GObject
    {
        var cnt:Int = _children.length;
        for (i in 0...cnt)
        {
            if (_children[i].name == name)
                return _children[i];
        }

        return null;
    }

    public function getVisibleChild(name:String):GObject
    {
        var cnt:Int = _children.length;
        for (i in 0...cnt)
        {
            var child:GObject = _children[i];
            if (child.internalVisible && child.internalVisible2 && child.name==name)
                return child;
        }

        return null;
    }

    public function getChildInGroup(name:String, group:GGroup):GObject
    {
        var cnt:Int = _children.length;
        for (i in 0...cnt)
        {
            var child:GObject = _children[i];
            if (child.group == group && child.name == name)
                return child;
        }

        return null;
    }

    public function getChildById(id:String):GObject
    {
        var cnt:Int = _children.length;
        for (i in 0...cnt)
        {
            if (_children[i]._id == id)
                return _children[i];
        }

        return null;
    }

    public function getChildIndex(child:GObject):Int
    {
        return Lambda.indexOf(_children, child);
    }

    public function setChildIndex(child:GObject, index:Int):Void
    {
        var oldIndex:Int = Lambda.indexOf(_children, child);
        if (oldIndex == -1)
            throw new ArgumentError("Not a child of this container");

        if (child.sortingOrder != 0)
        {
            //no effect
            return;
        }

        var cnt:Int = _children.length;
        if (_sortingChildCount > 0)
        {
            if (index > (cnt - _sortingChildCount - 1))
                index = cnt - _sortingChildCount - 1;
        }

        _setChildIndex(child, oldIndex, index);
    }

    public function setChildIndexBefore(child:GObject, index:Int):Int
    {
        var oldIndex:Int = Lambda.indexOf(_children, child);
        if (oldIndex == -1)
            throw new ArgumentError("Not a child of this container");

        if (child.sortingOrder != 0)
        {
            //no effect
            return oldIndex;
        }

        var cnt:Int = _children.length;
        if (_sortingChildCount > 0)
        {
            if (index > (cnt - _sortingChildCount - 1))
                index = cnt - _sortingChildCount - 1;
        }

        if (oldIndex < index)
            return _setChildIndex(child, oldIndex, index - 1);
        else
            return _setChildIndex(child, oldIndex, index);
    }

    private function _setChildIndex(child:GObject, oldIndex:Int, index:Int):Int
    {
        var cnt:Int = _children.length;
        if (index > cnt)
            index = cnt;

        if (oldIndex == index)
            return index;

        _children.splice(oldIndex, 1);
        _children.insert(index + 1, child);

        if (child.inContainer)
        {
            var displayIndex:Int = 0;
            var g:GObject;
            var i:Int;

            if (_childrenRenderOrder == ChildrenRenderOrder.Ascent)
            {
                for (i in 0...index)
                {
                    g = _children[i];
                    if (g.inContainer)
                        displayIndex++;
                }
                if (displayIndex == _container.numChildren)
                    displayIndex--;
                _container.setChildIndex(child.displayObject, displayIndex);
            }
            else if (_childrenRenderOrder == ChildrenRenderOrder.Descent)
            {
                i = cnt - 1;
                while (i > index)
                {
                    g = _children[i];
                    if (g.inContainer)
                        displayIndex++;
                    i--;
                }
                if (displayIndex == _container.numChildren)
                    displayIndex--;
                _container.setChildIndex(child.displayObject, displayIndex);
            }
            else
            {
                GTimers.inst.callLater(buildNativeDisplayList);
            }

            setBoundsChangedFlag();
        }

        return index;
    }

    public function swapChildren(child1:GObject, child2:GObject):Void
    {
        var index1:Int = Lambda.indexOf(_children, child1);
        var index2:Int = Lambda.indexOf(_children, child2);
        if (index1 == -1 || index2 == -1)
            throw new ArgumentError("Not a child of this container");
        swapChildrenAt(index1, index2);
    }

    public function swapChildrenAt(index1:Int, index2:Int):Void
    {
        var child1:GObject = _children[index1];
        var child2:GObject = _children[index2];

        setChildIndex(child1, index2);
        setChildIndex(child2, index1);
    }

    @:final private function get_numChildren():Int
    {
        return _children.length;
    }

    public function isAncestorOf(child:GObject):Bool
    {
        if (child == null)
            return false;

        var p:GComponent = child.parent;
        while (p != null)
        {
            if (p == this)
                return true;

            p = p.parent;
        }
        return false;
    }

    public function addController(controller:Controller):Void
    {
        _controllers.push(controller);
        controller._parent = this;
        applyController(controller);
    }

    public function getControllerAt(index:Int):Controller
    {
        return _controllers[index];
    }

    public function getController(name:String):Controller
    {
        var cnt:Int = _controllers.length;
        for (i in 0...cnt)
        {
            var c:Controller = _controllers[i];
            if (c.name == name)
                return c;
        }

        return null;
    }

    public function removeController(c:Controller):Void
    {
        var index:Int = Lambda.indexOf(_controllers, c);
        if (index == -1)
            throw new Error("controller not exists");

        c._parent = null;
        _controllers.splice(index, 1);

        for (child in _children)
            child.handleControllerChanged(c);
    }

    @:final private function get_controllers():Array<Controller>
    {
        return _controllers;
    }

    @:allow(haxePEngine)
    private function childStateChanged(child:GObject):Void
    {
        if (_buildingDisplayList)
            return;

        var cnt:Int = _children.length;
        var g:GObject;
        var i:Int;

        if (Std.isOfType(child, GGroup))
        {
            for (i in 0...cnt)
            {
                g = _children[i];
                if (g.group == child)
                    childStateChanged(g);
            }
            return;
        }

        //if (child.displayObject == null)
        //    return;
        // 待补 修改为2
        if (child.displayObject2 == null)
            return;


        // if(child._gears[0] != null) {
        //     trace(cast(child._gears[0], GearDisplay).pages + ":" + child.internalVisible);
        // }

        if (child.internalVisible)
        {
            if (child.displayObject2.parent == null)
            {
                // _container2.getChildAt(0).visible = false;
                // _container2.getChildAt(1).visible = false;
                // _container2.getChildAt(2).visible = false;
                // _container2.getChildAt(3).visible = false;

                var index:Int = 0;
                if (_childrenRenderOrder == ChildrenRenderOrder.Ascent)
                {
                    for (i in 0...cnt)
                    {
                        g = _children[i];
                        if (g == child)
                            break;

                        if (g.displayObject2 != null && g.displayObject2.parent != null)
                            index++;
                    }
                    child.displayObject2.visible = true;
                    _container2.addChildAt(child.displayObject2, index);
                    //_container2.addChild(child.displayObject2);
                }
                else if (_childrenRenderOrder == ChildrenRenderOrder.Descent)
                {
                    i = cnt - 1;
                    while (i >= 0)
                    {
                        g = _children[i];
                        if (g == child)
                            break;

                        if (g.displayObject2 != null && g.displayObject2.parent != null)
                            index++;
                        i--;
                    }
                    child.displayObject2.visible = true;
                    _container2.addChildAt(child.displayObject2, index);
                }
                else
                {
                    child.displayObject2.visible = true;
                    _container2.addChild(child.displayObject2);

                    GTimers.inst.callLater(buildNativeDisplayList);
                }
            }else {
               // _container2.addChild(child.displayObject2);
                child.displayObject2.visible = true;
            }
        }
        else
        {
            if (child.displayObject2.parent != null)
            {
                child.displayObject2.visible = false;
                //_container2.removeChild(child.displayObject2);
                if (_childrenRenderOrder == ChildrenRenderOrder.Arch)
                {
                    GTimers.inst.callLater(buildNativeDisplayList);
                }
            }
        }
    }

    private function buildNativeDisplayList():Void
    {
        var cnt:Int = _children.length;
        if (cnt == 0)
            return;

        var i:Int;
        var child:GObject;
        switch (_childrenRenderOrder)
        {
            case ChildrenRenderOrder.Ascent:
                {
                    for (i in 0...cnt)
                    {
                        child = _children[i];
                        if (child.displayObject2 != null && child.internalVisible) {
                            child.displayObject2.visible = true;
                            _container2.addChild(child.displayObject2);
                        }
                        else {
                            //child.parent = null;

                            try {
                                child.displayObject2.visible = false;
                            } catch (error:Dynamic) {
                                // 异常处理代码块
                            }

                        }
                    }
                }
            case ChildrenRenderOrder.Descent:
                {
                    i = cnt - 1;
                    while (i >= 0)
                    {
                        child = _children[i];
                        if (child.displayObject2 != null && child.internalVisible)
                            _container2.addChild(child.displayObject2);
                        i--;
                    }
                }

            case ChildrenRenderOrder.Arch:
                {
                    for (i in 0..._apexIndex)
                    {
                        child = _children[i];
                        if (child.displayObject2 != null && child.internalVisible)
                            _container2.addChild(child.displayObject2);
                    }
                    i = cnt - 1;
                    while (i >= _apexIndex)
                    {
                        child = _children[i];
                        if (child.displayObject2 != null && child.internalVisible)
                            _container2.addChild(child.displayObject2);
                        i--;
                    }
                }
        }
    }

    @:allow(haxePEngine)
    private function applyController(c:Controller):Void
    {
        _applyingController = c;
        for (child in _children)
        {
            child.handleControllerChanged(c);
        }
        _applyingController = null;
        c.runActions();
    }

    @:allow(haxePEngine)
    private function applyAllControllers():Void
    {
        var cnt:Int = _controllers.length;
        for (i in 0...cnt)
        {
            applyController(_controllers[i]);
        }
    }

    @:allow(haxePEngine)
    private function adjustRadioGroupDepth(obj:GObject, c:Controller):Void
    {
        var cnt:Int = _children.length;
        var i:Int;
        var child:GObject;
        var myIndex:Int = -1;
        var maxIndex:Int = -1;
        for (i in 0...cnt)
        {
            child = _children[i];
            if (child == obj)
            {
                myIndex = i;
            }
            else if (Std.isOfType(child, GButton)
                     && cast(child, GButton).relatedController == c)
            {
                if (i > maxIndex)
                    maxIndex = i;
            }
        }
        if (myIndex < maxIndex)
        {
            //如果正在applyingController，此时修改显示列表是危险的，但真正排除危险只能用显示列表的副本去做，这样性能可能损耗较大，
            //这里取个巧，让可能漏过的child补一下handleControllerChanged，反正重复执行是无害的。
            if(_applyingController != null)
                _children[maxIndex].handleControllerChanged(_applyingController);

            this.swapChildrenAt(myIndex, maxIndex);
        }
    }

    public function getTransitionAt(index:Int):Transition
    {
        return _transitions[index];
    }

    public function getTransition(transName:String):Transition
    {
        var cnt:Int = _transitions.length;
        for (i in 0...cnt)
        {
            var trans:Transition = _transitions[i];
            if (trans.name == transName)
                return trans;
        }

        return null;
    }

    @:final private function get_scrollPane():ScrollPane
    {
        return _scrollPane;
    }

    public function isChildInView(child:GObject):Bool
    {
        if (_scrollPane != null)
        {
            return _scrollPane.isChildInView(child);
        }
        else if (_container.scrollRect != null)
        {
            return child.x + child.width >= 0 && child.x <= this.width && child.y + child.height >= 0 && child.y <= this.height;
        }
        else
            return true;
    }

    public function getFirstChildInView():Int
    {
        var cnt:Int = _children.length;
        for (i in 0...cnt)
        {
            var child:GObject = _children[i];
            if (isChildInView(child))
                return i;
        }
        return -1;
    }

    @:final private function get_opaque():Bool
    {
        return _opaque;
    }

    private function set_opaque(value:Bool):Bool
    {
        if (_opaque != value)
        {
            _opaque = value;
            if (_opaque)
                updateOpaque();
            else
                _rootContainer.graphics.clear();
            _rootContainer.mouseEnabled = this.touchable && (_opaque || _hitArea != null);
        }
        return value;
    }

    @:final private function get_hitArea():PixelHitTest
    {
        return _hitArea;
    }

    private function set_hitArea(value:PixelHitTest):PixelHitTest
    {
        if (_rootContainer.hitArea != null)
            _rootContainer.removeChild(_rootContainer.hitArea);

        _hitArea = value;
        if (_hitArea != null)
        {
            _rootContainer.hitArea = _hitArea.createHitAreaSprite();
            _rootContainer.addChild(_rootContainer.hitArea);
            _rootContainer.mouseChildren = false;
        }
        else
        {
            _rootContainer.hitArea = null;
            _rootContainer.mouseChildren = this.touchable;
        }
        _rootContainer.mouseEnabled = this.touchable && (_opaque || _hitArea != null);
        return value;
    }

    @:allow(haxePEngine)
    private function handleTouchable(val:Bool):Void
    {
        _rootContainer.mouseEnabled = val && (_opaque || _hitArea != null);
        _rootContainer.mouseChildren = val && _hitArea == null;
    }

    private function get_margin():Margin
    {
        return _margin;
    }

    private function set_margin(value:Margin):Margin
    {
        _margin.copy(value);
        if (_container.scrollRect != null)
        {
            _container.x = _margin.left + _alignOffset.x;
            _container.y = _margin.top + _alignOffset.y;
        }
        handleSizeChanged();
        return value;
    }

    private function get_childrenRenderOrder():Int
    {
        return _childrenRenderOrder;
    }

    private function set_childrenRenderOrder(value:Int):Int
    {
        if (_childrenRenderOrder != value)
        {
            _childrenRenderOrder = value;
            buildNativeDisplayList();
        }
        return value;
    }

    private function get_apexIndex():Int
    {
        return _apexIndex;
    }

    private function set_apexIndex(value:Int):Int
    {
        if (_apexIndex != value)
        {
            _apexIndex = value;

            if (_childrenRenderOrder == ChildrenRenderOrder.Arch)
                buildNativeDisplayList();
        }
        return value;
    }

    private function get_mask():DisplayObject
    {
        return _container.mask;
    }

    private function set_mask(value:DisplayObject):DisplayObject
    {
        _container.mask = value;
        return value;
    }

    private function updateOpaque():Void
    {
        var w:Float = this.width;
        var h:Float = this.height;
        if (w == 0)
            w = 1;
        if (h == 0)
            h = 1;

        var g:Graphics = _rootContainer.graphics;
        g.clear();
        g.lineStyle(0, 0, 0);
        g.beginFill(0, 0);
        g.drawRect(0, 0, w, h);
        g.endFill();
    }

    private function updateClipRect():Void
    {
        var rect:Rectangle = _container.scrollRect;
        var w:Float = this.width - (_margin.left + _margin.right);
        var h:Float = this.height - (_margin.top + _margin.bottom);
        if (w <= 0)
            w = 0;
        if (h <= 0)
            h = 0;

        rect.width = w;
        rect.height = h;
        _container.scrollRect = rect;
    }

    private function setupScroll(scrollBarMargin:Margin,
                                 scroll:Int,
                                 scrollBarDisplay:Int,
                                 flags:Int,
                                 vtScrollBarRes:String,
                                 hzScrollBarRes:String):Void
    {
        if (_rootContainer == _container)
        {
            _container = new Sprite();
            _rootContainer.addChild(_container);
        }
        _scrollPane = new ScrollPane(this, scroll, scrollBarMargin, scrollBarDisplay, flags,
        vtScrollBarRes, hzScrollBarRes);
    }

    private function setupOverflow(overflow:Int):Void
    {
        if (overflow == OverflowType.Hidden)
        {
            if (_rootContainer == _container)
            {
                _container = new Sprite();
                _rootContainer.addChild(_container);
            }

            _container.scrollRect = new Rectangle();
            updateClipRect();

            _container.x = _margin.left;
            _container.y = _margin.top;
        }
        else if (_margin.left != 0 || _margin.top != 0)
        {
            if (_rootContainer == _container)
            {
                _container = new Sprite();
                _rootContainer.addChild(_container);
            }

            _container.x = _margin.left;
            _container.y = _margin.top;
        }
    }

    override private function handleSizeChanged():Void
    {
        if (_scrollPane != null)
            _scrollPane.onOwnerSizeChanged();
        if (_container.scrollRect != null)
            updateClipRect();

        if (_opaque)
            updateOpaque();
    }

    override private function handleGrayedChanged():Void
    {
        var c:Controller = getController("grayed");
        if (c != null)
        {
            c.selectedIndex = (this.grayed) ? 1 : 0;
            return;
        }

        var v:Bool = this.grayed;
        var cnt:Int = _children.length;
        for (i in 0...cnt)
        {
            _children[i].grayed = v;
        }
    }

    override public function handleControllerChanged(c:Controller):Void
    {
        super.handleControllerChanged(c);

        if (_scrollPane != null)
            _scrollPane.handleControllerChanged(c);
    }

    public function setBoundsChangedFlag():Void
    {
        if (_scrollPane == null && !_trackBounds)
            return;

        if (!_boundsChanged)
        {
            _boundsChanged = true;
            GTimers.inst.add(0, 1, __render);
        }
    }

    private function __render():Void
    {
        if (_boundsChanged)
        {
            for (child in _children)
            {
                child.ensureSizeCorrect();
            }
            updateBounds();
        }
    }

    public function ensureBoundsCorrect():Void
    {
        for (child in _children)
        {
            child.ensureSizeCorrect();
        }

        if (_boundsChanged)
            updateBounds();
    }

    private function updateBounds():Void
    {
        var ax:Int;
        var ay:Int;
        var aw:Int;
        var ah:Int;
        if (_children.length > 0)
        {
            ax = CompatUtil.INT_MAX_VALUE;
            ay = CompatUtil.INT_MAX_VALUE;
            var ar:Int = CompatUtil.INT_MIN_VALUE;
            var ab:Int = CompatUtil.INT_MIN_VALUE;
            var tmp:Int;

            for (child in _children)
            {
                tmp = Std.int(child.x);
                if (tmp < ax)
                    ax = tmp;
                tmp = Std.int(child.y);
                if (tmp < ay)
                    ay = tmp;
                tmp = Std.int(child.x + child.actualWidth);
                if (tmp > ar)
                    ar = tmp;
                tmp = Std.int(child.y + child.actualHeight);
                if (tmp > ab)
                    ab = tmp;
            }
            aw = ar - ax;
            ah = ab - ay;
        }
        else
        {
            ax = 0;
            ay = 0;
            aw = 0;
            ah = 0;
        }

        setBounds(ax, ay, aw, ah);
    }

    private function setBounds(ax:Int, ay:Int, aw:Int, ah:Int):Void
    {
        _boundsChanged = false;

        if (_scrollPane != null)
            _scrollPane.setContentSize(Math.round(ax + aw), Math.round(ay + ah));
    }

    private function get_viewWidth():Int
    {
        if (_scrollPane != null)
            return _scrollPane.viewWidth;
        else
            return Std.int(this.width - _margin.left - _margin.right);
    }

    private function set_viewWidth(value:Int):Int
    {
        if (_scrollPane != null)
            _scrollPane.viewWidth = value;
        else
            this.width = value + _margin.left + _margin.right;

        return value;
    }

    private function get_viewHeight():Int
    {
        if (_scrollPane != null)
            return _scrollPane.viewHeight;
        else
            return Std.int(this.height - _margin.top - _margin.bottom);
    }

    private function set_viewHeight(value:Int):Int
    {
        if (_scrollPane != null)
            _scrollPane.viewHeight = value;
        else
            Std.int(this.height = value + _margin.top + _margin.bottom);
        return value;
    }

    public function getSnappingPosition(xValue:Float, yValue:Float, resultPoint:Point = null):Point
    {
        if (resultPoint == null)
            resultPoint = new Point();

        var cnt:Int = _children.length;
        if (cnt == 0)
        {
            resultPoint.x = xValue;
            resultPoint.y = yValue;
            return resultPoint;
        }

        ensureBoundsCorrect();

        var obj:GObject = null;
        var prev:GObject;

        var i:Int = 0;
        if (yValue != 0)
        {
            while (i < cnt)
            {
                obj = _children[i];
                if (yValue < obj.y)
                {
                    if (i == 0)
                    {
                        yValue = 0;
                        break;
                    }
                    else
                    {
                        prev = _children[i - 1];
                        if (yValue < prev.y + prev.height / 2)
                        {
                            //top half part
                            yValue = prev.y;
                        }
                        else
                        {
                            //bottom half part
                            yValue = obj.y;
                        }
                        break;
                    }
                }
                i++;
            }

            if (i == cnt)
                yValue = obj.y;
        }

        if (xValue != 0)
        {
            if (i > 0)
                i--;

            while (i < cnt)
            {
                obj = _children[i];
                if (xValue < obj.x)
                {
                    if (i == 0)
                    {
                        xValue = 0;
                        break;
                    }
                    else
                    {
                        prev = _children[i - 1];
                        if (xValue < prev.x + prev.width / 2)
                        {
                            //top half part
                            xValue = prev.x;
                        }
                        else
                        {
                            //bottom half part
                            xValue = obj.x;
                        }
                        break;
                    }
                }
                i++;
            }

            if (i == cnt)
                xValue = obj.x;
        }

        resultPoint.x = xValue;
        resultPoint.y = yValue;
        return resultPoint;
    }

    @:allow(haxePEngine)
    private function childSortingOrderChanged(child:GObject, oldValue:Int, newValue:Int):Void
    {
        if (newValue == 0)
        {
            _sortingChildCount--;
            setChildIndex(child, _children.length);
        }
        else
        {
            if (oldValue == 0)
                _sortingChildCount++;

            var oldIndex:Int = Lambda.indexOf(_children, child);
            var index:Int = getInsertPosForSortingChild(child);
            if (oldIndex < index)
                _setChildIndex(child, oldIndex, index - 1);
            else
                _setChildIndex(child, oldIndex, index);
        }
    }

    override public function constructFromResource():Void
    {
        constructFromResource2(null, 0);
    }

    @:allow(haxePEngine)
    private function constructFromResource2(objectPool:Array<GObject>, poolIndex:Int):Void
    {
        var xml:FastXML = packageItem.owner.getComponentData(packageItem);

        var str:String;
        var arr:Array<Dynamic>;

        _underConstruct = true;

        str = xml.att.size;
        arr = str.split(",");
        sourceWidth = Std.parseInt(arr[0]);
        sourceHeight = Std.parseInt(arr[1]);
        initWidth = sourceWidth;
        initHeight = sourceHeight;

        setSize(sourceWidth, sourceHeight);

        str = xml.att.pivot;
        if (str != null)
        {
            arr = str.split(",");
            str = xml.att.anchor;
            internalSetPivot(Std.parseFloat(arr[0]), Std.parseFloat(arr[1]), str == "true");
        }

        str = xml.att.restrictSize;
        if (str != null)
        {
            arr = str.split(",");
            minWidth = Std.parseInt(arr[0]);
            maxWidth = Std.parseInt(arr[1]);
            minHeight = Std.parseInt(arr[2]);
            maxHeight = Std.parseInt(arr[3]);
        }

        str = xml.att.opaque;
        if (str != "false")
            this.opaque = true;

        var overflow:Int;
        str = xml.att.overflow;
        if (str != null)
            overflow = OverflowType.parse(str);
        else
            overflow = OverflowType.Visible;

        str = xml.att.margin;
        if (str != null && str != "")
            _margin.parse(str);

        if (overflow == OverflowType.Scroll)
        {
            var scroll:Int = ScrollType.Both;
            str = xml.att.scroll;
            if (str != null)
                scroll = ScrollType.parse(str);
            else
                scroll = ScrollType.Vertical;

            var scrollBarDisplay:Int = ScrollBarDisplayType.Default;
            str = xml.att.scrollBar;
            if (str != null)
                scrollBarDisplay = ScrollBarDisplayType.parse(str);
            else
                scrollBarDisplay = ScrollBarDisplayType.Default;
            var scrollBarFlags:Int = Std.parseInt(xml.att.scrollBarFlags);

            var scrollBarMargin:Margin = new Margin();
            str = xml.att.scrollBarMargin;
            if (str != null)
                scrollBarMargin.parse(str);

            var vtScrollBarRes:String = null;
            var hzScrollBarRes:String = null;
            str = xml.att.scrollBarRes;
            if (str != null)
            {
                arr = str.split(",");
                vtScrollBarRes = arr[0];
                hzScrollBarRes = arr[1];
            }

            setupScroll(scrollBarMargin, scroll, scrollBarDisplay, scrollBarFlags,
            vtScrollBarRes, hzScrollBarRes);
        }
        else
            setupOverflow(overflow);

        _buildingDisplayList = true;
        var col:FastXMLList = xml.nodes.controller;

        var controller:Controller;
        for (cxml in col.iterator())
        {
            controller = new Controller();
            _controllers.push(controller);
            controller._parent = this;
            controller.setup(cxml);
        }

        var child:GObject;
        var displayList:Array<DisplayListItem> = packageItem.displayList;
        var childCount:Int = displayList.length;
        var i:Int;
        for (i in 0...childCount)
        {
            var di:DisplayListItem = displayList[i];

            //trace(di.packageItem);
            if (objectPool != null)
            {
                child = objectPool[poolIndex + i];
            }
            else if (di.packageItem != null)
            {
                // 待补 修改为 _container2
                //child = UIObjectFactory.newObject(di.packageItem,_heapsparent);
                child = UIObjectFactory.newObject(di.packageItem,_container2);
                child.packageItem = di.packageItem;
                child.constructFromResource();
            }
            else {
                //child = UIObjectFactory.newObject2(di.type,_heapsparent);
                child = UIObjectFactory.newObject2(di.type,_container2);
            }

            child._underConstruct = true;
            child.setup_beforeAdd(di.desc);
            child.parent = this;
            _children.push(child);
        }
        this.relations.setup(xml);

        for (i in 0...childCount)
        {
            _children[i].relations.setup(displayList[i].desc);
        }

        for (i in 0...childCount)
        {
            child = _children[i];
            child.setup_afterAdd(displayList[i].desc);
            child._underConstruct = false;
        }

        str = xml.att.mask;
        if (str != null)
            this.mask = getChildById(str).displayObject;

        col = xml.nodes.transition;
        var trans:Transition;
        for (cxml in col.iterator())
        {
            trans = new Transition(this);
            _transitions.push(trans);
            trans.setup(cxml);
        }

        if (_transitions.length > 0)
        {
            this.addEventListener(Event.ADDED_TO_STAGE, p__addedToStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE, __removedFromStage);
        }

        applyAllControllers();

        _buildingDisplayList = false;
        _underConstruct = false;

        buildNativeDisplayList();
        setBoundsChangedFlag();

        constructFromXML(xml);
    }

    private function constructFromXML(xml:FastXML):Void
    {
    }

    override public function setup_afterAdd(xml:FastXML):Void
    {
        super.setup_afterAdd(xml);

        var str:String;

        if (scrollPane != null)
        {
            str = xml.att.pageController;
            if (str != null)
                scrollPane.pageController = parent.getController(str);
        }

        str = xml.att.controller;
        if (str != null)
        {
            var arr:Array<String> = str.split(",");
            var i:Int = 0;
            while (i < arr.length)
            {
                var cc:Controller = getController(arr[i]);
                if (cc != null)
                    cc.selectedPageId = arr[i + 1];
                i += 2;
            }
        }
    }

    @:final private function p__addedToStage(evt:Event):Void
    {
        var cnt:Int = _transitions.length;
        for (i in 0...cnt)
        {
            var trans:Transition = _transitions[i];
            if (trans.autoPlay)
                trans.play(null, null, trans.autoPlayRepeat, trans.autoPlayDelay);
        }
    }

    private function __removedFromStage(evt:Event):Void
    {
        var cnt:Int = _transitions.length;
        for (i in 0...cnt)
        {
            _transitions[i].OnOwnerRemovedFromStage();
        }
    }

    public function move_window_center():Void {
        this.x = (System.width-this.width)/2;
        this.y = (System.height-this.height)/2;
        // this.x = (this.parent.width - this.width) / 2;
        // this.y = (this.parent.height - this.height) / 2;

    }
}


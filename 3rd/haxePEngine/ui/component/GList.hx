package haxePEngine.ui.component;
import haxePEngine.utils.xml.*;
import haxePEngine.ui.base.*;
import haxePEngine.ui.component.base.Vector;
import haxePEngine.ui.display.UIDisplayObject;
import haxePEngine.ui.base.event.GTouchEvent;
import haxePEngine.ui.base.event.ItemEvent;
import haxePEngine.ui.component.GObject;
import haxePEngine.ui.base.GObjectPool;
import haxePEngine.ui.component.GRoot;
import haxePEngine.ui.base.Margin;
import haxePEngine.ui.utils.CompatUtil;
import haxePEngine.ui.utils.GTimers;
import haxePEngine.ui.component.base.display.DisplayObject;
import haxePEngine.ui.component.base.display.Sprite;
import haxePEngine.ui.component.base.display.Stage;
import haxePEngine.ui.component.base.error.Error;
import haxePEngine.ui.component.base.events.Event;
import haxePEngine.ui.component.base.events.MouseEvent;
import haxePEngine.ui.component.base.geom.Point;
import haxePEngine.ui.component.base.geom.Rectangle;

@:meta(Event(name = "itemClick", type = "haxePEngine.ui.base.event.ItemEvent"))

class GList extends GComponent
{
    public var layout(get, set):Int;
    public var lineGap(get, set):Int;
    public var columnGap(get, set):Int;
    public var align(get, set):Int;
    public var verticalAlign(get, set):Int;
    public var virtualItemSize(get, set):Point;
    public var defaultItem(get, set):String;
    public var autoResizeItem(get, set):Bool;
    public var selectionMode(get, set):Int;
    public var itemPool(get, never):GObjectPool;
    public var selectedIndex(get, set):Int;
    public var numItems(get, set):Int;
    public var lineCount(get, set):Int;
    public var columnCount(get, set):Int;
    public var selectionController(get, set):Controller;

    /**
     * itemRenderer(index:int, item:GObject);
     */
    public var itemRenderer:Int -> GObject -> Void;
    /**
     * itemProvider(index:int):String;
     */
    public var itemProvider:Int -> String;
    public var scrollItemToViewOnClick:Bool = false;
    public var foldInvisibleItems:Bool = false;

    private var _layout:Int = 0;
    private var _lineCount:Int;
    private var _columnCount:Int;
    private var _lineGap:Int = 0;
    private var _columnGap:Int = 0;
    private var _defaultItem:String;
    private var _autoResizeItem:Bool = false;
    private var _selectionMode:Int = 0;
    private var _align:Int = 0;
    private var _verticalAlign:Int = 0;
    private var _selectionController:Controller;

    private var _lastSelectedIndex:Int = 0;
    private var _pool:GObjectPool;

    //Virtual List support
    private var _virtual:Bool = false;
    private var _loop:Bool = false;
    private var _numItems:Int = 0;
    private var _realNumItems:Int = 0;
    private var _firstIndex:Int = 0; //the top left index
    private var _curLineItemCount:Int = 0; //item count in one line
    private var _curLineItemCount2:Int = 0; //只用在页面模式，表示垂直方向的项目数
    private var _itemSize:Point;
    private var _virtualListChanged:Int = 0; //1-content changed, 2-size changed
    private var _eventLocked:Bool = false;
    private var _virtualItems:Array<ItemInfo>;

    public function new()
    {
        super();

        _trackBounds = true;
        _pool = new GObjectPool();
        _layout = ListLayoutType.SingleColumn;
        _autoResizeItem = true;
        _lastSelectedIndex = -1;
        this.opaque = true;
        scrollItemToViewOnClick = true;
        _align = AlignType.Left;
        _verticalAlign = VertAlignType.Top;

        _container = new Sprite();
        _rootContainer.addChild(_container);
    }

    override public function dispose():Void
    {
        _pool.clear();
        scrollItemToViewOnClick = false;
        super.dispose();
    }

    @:final private function get_layout():Int
    {
        return _layout;
    }

    @:final private function set_layout(value:Int):Int
    {
        if (_layout != value)
        {
            _layout = value;
            setBoundsChangedFlag();
            if (_virtual)
                setVirtualListChangedFlag(true);
        }
        return value;
    }

    @:final public function get_lineCount():Int
    {
        return _lineCount;
    }

    @:final public function set_lineCount(value:Int):Int
    {
        if (_lineCount != value)
        {
            _lineCount = value;
            if (_layout == ListLayoutType.FlowVertical || _layout == ListLayoutType.Pagination)
            {
                setBoundsChangedFlag();
                if (_virtual)
                    setVirtualListChangedFlag(true);
            }
        }
        return value;
    }

    @:final public function get_columnCount():Int
    {
        return _columnCount;
    }

    @:final public function set_columnCount(value:Int):Int
    {
        if (_columnCount != value)
        {
            _columnCount = value;
            if (_layout == ListLayoutType.FlowHorizontal || _layout == ListLayoutType.Pagination)
            {
                setBoundsChangedFlag();
                if (_virtual)
                    setVirtualListChangedFlag(true);
            }
        }
        return value;
    }


    @:final private function get_lineGap():Int
    {
        return _lineGap;
    }

    @:final private function set_lineGap(value:Int):Int
    {
        if (_lineGap != value)
        {
            _lineGap = value;
            setBoundsChangedFlag();
            if (_virtual)
                setVirtualListChangedFlag(true);
        }
        return value;
    }

    @:final private function get_columnGap():Int
    {
        return _columnGap;
    }

    @:final private function set_columnGap(value:Int):Int
    {
        if (_columnGap != value)
        {
            _columnGap = value;
            setBoundsChangedFlag();
            if (_virtual)
                setVirtualListChangedFlag(true);
        }
        return value;
    }

    private function get_align():Int
    {
        return _align;
    }

    private function set_align(value:Int):Int
    {
        if (_align != value)
        {
            _align = value;
            setBoundsChangedFlag();
            if (_virtual)
                setVirtualListChangedFlag(true);
        }
        return value;
    }

    @:final private function get_verticalAlign():Int
    {
        return _verticalAlign;
    }

    private function set_verticalAlign(value:Int):Int
    {
        if (_verticalAlign != value)
        {
            _verticalAlign = value;
            setBoundsChangedFlag();
            if (_virtual)
                setVirtualListChangedFlag(true);
        }
        return value;
    }

    @:final private function get_virtualItemSize():Point
    {
        return _itemSize;
    }

    @:final private function set_virtualItemSize(value:Point):Point
    {
        if (_virtual)
        {
            if (_itemSize == null)
                _itemSize = new Point();
            _itemSize.copyFrom(value);
            setVirtualListChangedFlag(true);
        }
        return value;
    }

    @:final private function get_defaultItem():String
    {
        return _defaultItem;
    }

    @:final private function set_defaultItem(val:String):String
    {
        _defaultItem = val;
        return val;
    }

    @:final private function get_autoResizeItem():Bool
    {
        return _autoResizeItem;
    }

    @:final private function set_autoResizeItem(value:Bool):Bool
    {
        if (_autoResizeItem != value)
        {
            _autoResizeItem = value;
            setBoundsChangedFlag();
            if (_virtual)
                setVirtualListChangedFlag(true);
        }

        return value;
    }

    @:final private function get_selectionMode():Int
    {
        return _selectionMode;
    }

    @:final private function set_selectionMode(value:Int):Int
    {
        _selectionMode = value;
        return value;
    }

    @:final public function get_selectionController():Controller
    {
        return _selectionController;
    }

    @:final public function set_selectionController(value:Controller):Controller
    {
        _selectionController = value;
        return value;
    }

    private function get_itemPool():GObjectPool
    {
        return _pool;
    }

    public function getFromPool(url:String = null):GObject
    {
        if (url == null)
            url = _defaultItem;

        var ret:GObject = _pool.getObject(url);
        if (ret != null)
            ret.visible = true;
        return ret;
    }

    public function returnToPool(obj:GObject):Void
    {
        _pool.returnObject(obj);
    }

    override public function addChildAt(child:GObject, index:Int):GObject
    {
        super.addChildAt(child, index);

        if (Std.isOfType(child, GButton))
        {
            var button:GButton = cast(child, GButton);
            button.selected = false;
            button.changeStateOnClick = false;
            button.useHandCursor = false;
        }
        child.addEventListener(GTouchEvent.CLICK, __clickItem);
        child.addEventListener(MouseEvent.RIGHT_CLICK, __rightClickItem);

        return child;
    }

    public function addItem(url:String = null):GObject
    {
        if (url == null)
            url = _defaultItem;

        return addChild(UIPackage.createObjectFromURL(url));
    }

    public function addItemFromPool(url:String = null):GObject
    {
        return addChild(getFromPool(url));
    }

    override public function removeChildAt(index:Int, dispose:Bool = false):GObject
    {
        var child:GObject = super.removeChildAt(index, dispose);
        child.removeEventListener(GTouchEvent.CLICK, __clickItem);
        child.removeEventListener(MouseEvent.RIGHT_CLICK, __rightClickItem);

        return child;
    }

    public function removeChildToPoolAt(index:Int):Void
    {
        var child:GObject = super.removeChildAt(index);
        returnToPool(child);
    }

    public function removeChildToPool(child:GObject):Void
    {
        super.removeChild(child);
        returnToPool(child);
    }

    public function removeChildrenToPool(beginIndex:Int = 0, endIndex:Int = -1):Void
    {
        if (endIndex < 0 || endIndex >= _children.length)
            endIndex = _children.length - 1;

        for (i in beginIndex...endIndex + 1)
        {
            removeChildToPoolAt(beginIndex);
        }
    }

    private function get_selectedIndex():Int
    {
        var i:Int;
        if (_virtual)
        {
            for (i in 0..._realNumItems)
            {
                var ii:ItemInfo = _virtualItems[i];
                if (Std.isOfType(ii.obj, GButton) && cast(ii.obj, GButton).selected || ii.obj == null && ii.selected)
                {
                    if (_loop)
                        return i % _numItems;
                    else
                        return i;
                }
            }
        }
        else
        {
            var cnt:Int = _children.length;
            for (i in 0...cnt)
            {
                var obj:GButton = _children[i].asButton;
                if (obj != null && obj.selected)
                    return i;
            }
        }

        return -1;
    }

    private function set_selectedIndex(value:Int):Int
    {
        if (value >= 0 && value < numItems)
        {
            if(_selectionMode!=ListSelectionMode.Single)
                clearSelection();
            addSelection(value);
        }
        else
            clearSelection();

        return value;
    }

    public function getSelection():Array<Int>
    {
        var ret:Array<Int> = new Array<Int>();
        var i:Int;
        if (_virtual)
        {
            i = 0;
            while(i<_realNumItems)
            {
                var ii:ItemInfo = _virtualItems[i];
                if (Std.isOfType(ii.obj, GButton) && cast(ii.obj, GButton).selected || ii.obj == null && ii.selected)
                {
                    if (_loop)
                    {
                        i = i % _numItems;
                        if (ret.indexOf(i) != -1)
                        {
                            continue;
                        }
                    }
                    ret.push(i);
                }
                i++;
            }
        }
        else
        {
            var cnt:Int = _children.length;
            for (i in 0...cnt)
            {
                var obj:GButton = _children[i].asButton;
                if (obj != null && obj.selected)
                    ret.push(i);
            }
        }
        return ret;
    }

    public function addSelection(index:Int, scrollItToView:Bool = false):Void
    {
        if (_selectionMode == ListSelectionMode.None)
            return;

        checkVirtualList();

        if (_selectionMode == ListSelectionMode.Single)
            clearSelection();

        if (scrollItToView)
            scrollToView(index);

        _lastSelectedIndex = index;
        var obj:GButton = null;
        if (_virtual)
        {
            var ii:ItemInfo = _virtualItems[index];
            if (ii.obj != null)
                obj = ii.obj.asButton;
            ii.selected = true;
        }
        else
            obj = getChildAt(index).asButton;

        if (obj != null && !obj.selected)
        {
            obj.selected = true;
            updateSelectionController(index);
        }
    }

    public function removeSelection(index:Int):Void
    {
        if(_selectionMode == ListSelectionMode.None)
            return;

        var obj:GButton = null;
        if (_virtual)
        {
            var ii:ItemInfo = _virtualItems[index];
            if (ii.obj != null)
                obj = ii.obj.asButton;
            ii.selected = false;
        }
        else
            obj = getChildAt(index).asButton;

        if (obj != null)
            obj.selected = false;
    }

    public function clearSelection():Void
    {
        var i:Int;
        if (_virtual)
        {
            for (i in 0..._realNumItems)
            {
                var ii:ItemInfo = _virtualItems[i];
                if (Std.isOfType(ii.obj, GButton))
                    cast(ii.obj, GButton).selected = false;
                ii.selected = false;
            }
        }
        else
        {
            var cnt:Int = _children.length;
            for (i in 0...cnt)
            {
                var obj:GButton = _children[i].asButton;
                if (obj != null)
                    obj.selected = false;
            }
        }
    }

    private function clearSelectionExcept(g:GObject):Void
    {
        var i:Int;
        if (_virtual)
        {
            for (i in 0..._realNumItems)
            {
                var ii:ItemInfo = _virtualItems[i];
                if (ii.obj != g)
                {
                    if (Std.isOfType(ii.obj, GButton))
                        cast(ii.obj, GButton).selected = false;
                    ii.selected = false;
                }
            }
        }
        else
        {
            var cnt:Int = _children.length;
            for (i in 0...cnt)
            {
                var obj:GButton = _children[i].asButton;
                if (obj != null && obj != g)
                    obj.selected = false;
            }
        }
    }

    public function selectAll():Void
    {
        checkVirtualList();

        var last:Int = -1;
        var i:Int;
        if (_virtual)
        {
            for (i in 0..._realNumItems)
            {
                var ii:ItemInfo = _virtualItems[i];
                if (Std.isOfType(ii.obj, GButton) && !cast(ii.obj, GButton).selected)
                {
                    cast(ii.obj, GButton).selected = true;
                    last = i;
                }
                ii.selected = true;
            }
        }
        else
        {
            var cnt:Int = _children.length;
            for (i in 0...cnt)
            {
                var obj:GButton = _children[i].asButton;
                if (obj != null && !obj.selected)
                {
                    obj.selected = true;
                    last = i;
                }
            }
        }

        if (last != -1)
            updateSelectionController(last);
    }

    public function selectNone():Void
    {
        clearSelection();
    }

    public function selectReverse():Void
    {
        checkVirtualList();

        var last:Int = -1;
        var i:Int;
        if (_virtual)
        {
            for (i in 0..._realNumItems)
            {
                var ii:ItemInfo = _virtualItems[i];
                if (Std.isOfType(ii.obj, GButton))
                {
                    cast(ii.obj, GButton).selected = !cast(ii.obj, GButton).selected;
                    if (cast(ii.obj, GButton).selected)
                        last = i;
                }
                ii.selected = !ii.selected;
            }
        }
        else
        {
            var cnt:Int = _children.length;
            for (i in 0...cnt)
            {
                var obj:GButton = _children[i].asButton;
                if (obj != null)
                {
                    obj.selected = !obj.selected;
                    if (obj.selected)
                        last = i;
                }
            }
        }

        if (last != -1)
            updateSelectionController(last);
    }

    public function handleArrowKey(dir:Int):Void
    {
        var index:Int = this.selectedIndex;
        if (index == -1)
            return;

        var obj:GObject;
        var current:GObject;
        var k:Int = 0;
        var i:Int = 0;
        var cnt:Int;
        switch (dir)
        {
            case 1: //up
                if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowVertical)
                {
                    index--;
                    if (index >= 0)
                    {
                        clearSelection();
                        addSelection(index, true);
                    }
                }
                else if (_layout == ListLayoutType.FlowHorizontal || _layout == ListLayoutType.Pagination)
                {
                    current = _children[index];
                    k = 0;
                    i = index - 1;
                    while (i >= 0)
                    {
                        obj = _children[i];
                        if (obj.y != current.y)
                        {
                            current = obj;
                            break;
                        }
                        k++;
                        i--;
                    }
                    while (i >= 0)
                    {
                        obj = _children[i];
                        if (obj.y != current.y)
                        {
                            clearSelection();
                            addSelection(i + k + 1, true);
                            break;
                        }
                        i--;
                    }
                }

            case 3: //right
                if (_layout == ListLayoutType.SingleRow || _layout == ListLayoutType.FlowHorizontal || _layout == ListLayoutType.Pagination)
                {
                    index++;
                    if (index < _children.length)
                    {
                        clearSelection();
                        addSelection(index, true);
                    }
                }
                else if (_layout == ListLayoutType.FlowVertical)
                {
                    current = _children[index];
                    k = 0;
                    cnt = _children.length;
                    for (i in index + 1...cnt)
                    {
                        obj = _children[i];
                        if (obj.x != current.x)
                        {
                            current = obj;
                            break;
                        }
                        k++;
                    }
                    while (i < cnt)
                    {
                        obj = _children[i];
                        if (obj.x != current.x)
                        {
                            clearSelection();
                            addSelection(i - k - 1, true);
                            break;
                        }
                        i++;
                    }
                }

            case 5: //down
                if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowVertical)
                {
                    index++;
                    if (index < _children.length)
                    {
                        clearSelection();
                        addSelection(index, true);
                    }
                }
                else if (_layout == ListLayoutType.FlowHorizontal || _layout == ListLayoutType.Pagination)
                {
                    current = _children[index];
                    k = 0;
                    cnt = _children.length;
                    for (i in index + 1...cnt)
                    {
                        obj = _children[i];
                        if (obj.y != current.y)
                        {
                            current = obj;
                            break;
                        }
                        k++;
                    }
                    while (i < cnt)
                    {
                        obj = _children[i];
                        if (obj.y != current.y)
                        {
                            clearSelection();
                            addSelection(i - k - 1, true);
                            break;
                        }
                        i++;
                    }
                }

            case 7: //left
                if (_layout == ListLayoutType.SingleRow || _layout == ListLayoutType.FlowHorizontal || _layout == ListLayoutType.Pagination)
                {
                    index--;
                    if (index >= 0)
                    {
                        clearSelection();
                        addSelection(index, true);
                    }
                }
                else if (_layout == ListLayoutType.FlowVertical)
                {
                    current = _children[index];
                    k = 0;
                    i = index - 1;
                    while (i >= 0)
                    {
                        obj = _children[i];
                        if (obj.x != current.x)
                        {
                            current = obj;
                            break;
                        }
                        k++;
                        i--;
                    }
                    while (i >= 0)
                    {
                        obj = _children[i];
                        if (obj.x != current.x)
                        {
                            clearSelection();
                            addSelection(i + k + 1, true);
                            break;
                        }
                        i--;
                    }
                }
        }
    }

    public function getItemNear(globalX:Float, globalY:Float):GObject
    {
        ensureBoundsCorrect();

        var objs:Array<DisplayObject> = root.nativeStage.getObjectsUnderPoint(new Point(globalX, globalY));
        if (objs == null || objs.length == 0)
            return null;

        for (obj in objs)
        {
            while (obj != null && !Std.isOfType(obj, Stage))
            {
                if (Std.isOfType(obj, UIDisplayObject))
                {
                    var gobj:GObject = cast(obj, UIDisplayObject).owner;
                    while (gobj != null && gobj.parent != this)
                        gobj = gobj.parent;

                    if (gobj != null)
                        return gobj;
                }

                obj = obj.parent;
            }
        }
        return null;
    }

    private function __clickItem(evt:GTouchEvent):Void
    {
        if (this._scrollPane != null && this._scrollPane.isDragged)
            return;

        var item:GObject = cast((evt.currentTarget), GObject);
        setSelectionOnEvent(item);

        if (scrollPane != null && scrollItemToViewOnClick)
            scrollPane.scrollToView(item, true);

        var ie:ItemEvent = new ItemEvent(ItemEvent.CLICK, item);
        ie.stageX = evt.stageX;
        ie.stageY = evt.stageY;
        ie.clickCount = evt.clickCount;
        this.dispatchEvent(ie);
    }

    private function __rightClickItem(evt:MouseEvent):Void
    {
        var item:GObject = cast(evt.currentTarget, GObject);
        if (Std.isOfType(item, GButton) && !cast(item, GButton).selected)
            setSelectionOnEvent(item);

        if (scrollPane != null && scrollItemToViewOnClick)
            scrollPane.scrollToView(item, true);

        var ie:ItemEvent = new ItemEvent(ItemEvent.CLICK, item);
        ie.stageX = evt.stageX;
        ie.stageY = evt.stageY;
        ie.rightButton = true;
        this.dispatchEvent(ie);
    }

    private function setSelectionOnEvent(item:GObject):Void
    {
        if (!Std.isOfType(item, GButton) || _selectionMode == ListSelectionMode.None)
            return;

        var dontChangeLastIndex:Bool = false;
        var button:GButton = cast(item, GButton);
        var index:Int = childIndexToItemIndex(getChildIndex(item));

        if (_selectionMode == ListSelectionMode.Single)
        {
            if (!button.selected)
            {
                clearSelectionExcept(button);
                button.selected = true;
            }
        }
        else
        {
            var r:GRoot = this.root;
            if (r.shiftKeyDown)
            {
                if (!button.selected)
                {
                    if (_lastSelectedIndex != -1)
                    {
                        var min:Int = Std.int(Math.min(_lastSelectedIndex, index));
                        var max:Int = Std.int(Math.max(_lastSelectedIndex, index));
                        max = Std.int(Math.min(max, this.numItems-1));
                        var i:Int;
                        if (_virtual)
                        {
                            for (i in min...max+1)
                            {
                                var ii:ItemInfo = _virtualItems[i];
                                if (Std.isOfType(ii.obj, GButton))
                                    cast(ii.obj, GButton).selected = true;
                                ii.selected = true;
                            }
                        }
                        else
                        {
                            for(i in min...max+1)
                            {
                                var obj:GButton = getChildAt(i).asButton;
                                if(obj!=null)
                                    obj.selected = true;
                            }
                        }

                        dontChangeLastIndex = true;
                    }
                    else
                    {
                        button.selected = true;
                    }
                }
            }
            else if (r.ctrlKeyDown || _selectionMode == ListSelectionMode.Multiple_SingleClick)
            {
                button.selected = !button.selected;
            }
            else
            {
                if (!button.selected)
                {
                    clearSelectionExcept(button);
                    button.selected = true;
                }
                else
                    clearSelectionExcept(button);
            }
        }

        if (!dontChangeLastIndex)
            _lastSelectedIndex = index;

        if (button.selected)
            updateSelectionController(index);
    }

    public function resizeToFit(itemCount:Int = 2147483647, minSize:Int = 0):Void
    {
        ensureBoundsCorrect();

        var curCount:Int = this.numItems;
        if (itemCount > curCount)
            itemCount = curCount;

        if (_virtual)
        {
            var lineCount:Int = Math.ceil(itemCount / _curLineItemCount);
            if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
                this.viewHeight = Std.int(lineCount * _itemSize.y + Math.max(0, lineCount - 1) * _lineGap);
            else
                this.viewWidth = Std.int(lineCount * _itemSize.x + Math.max(0, lineCount - 1) * _columnGap);
        }
        else if (itemCount == 0)
        {
            if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
                this.viewHeight = minSize;
            else
                this.viewWidth = minSize;
        }
        else
        {
            var i:Int = itemCount - 1;
            var obj:GObject = null;
            while (i >= 0)
            {
                obj = this.getChildAt(i);
                if (!foldInvisibleItems || obj.visible)
                    break;
                i--;
            }
            if (i < 0)
            {
                if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
                    this.viewHeight = minSize;
                else
                    this.viewWidth = minSize;
            }
            else
            {
                var size:Int;
                if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
                {
                    size = Std.int(obj.y + obj.height);
                    if (size < minSize)
                        size = minSize;
                    this.viewHeight = size;
                }
                else
                {
                    size = Std.int(obj.x + obj.width);
                    if (size < minSize)
                        size = minSize;
                    this.viewWidth = size;
                }
            }
        }
    }

    public function getMaxItemWidth():Int
    {
        var cnt:Int = _children.length;
        var max:Int = 0;
        for (i in 0...cnt)
        {
            var child:GObject = getChildAt(i);
            if (child.width > max)
                max = Std.int(child.width);
        }
        return max;
    }

    override private function handleSizeChanged():Void
    {
        super.handleSizeChanged();

        setBoundsChangedFlag();
        if (_virtual)
            setVirtualListChangedFlag(true);
    }

    override public function handleControllerChanged(c:Controller):Void
    {
        super.handleControllerChanged(c);

        if (_selectionController == c)
            this.selectedIndex = c.selectedIndex;
    }

    private function updateSelectionController(index:Int):Void
    {
        if (_selectionController != null && !_selectionController.changing
            && index < _selectionController.pageCount)
        {
            var c:Controller = _selectionController;
            _selectionController = null;
            c.selectedIndex = index;
            _selectionController = c;
        }
    }

    override public function getSnappingPosition(xValue:Float, yValue:Float, resultPoint:Point = null):Point
    {
        if (_virtual)
        {
            if (resultPoint == null)
                resultPoint = new Point();

            var saved:Float;
            var index:Int;
            if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
            {
                saved = yValue;
                GList.pos_param = yValue;
                index = getIndexOnPos1(false);
                yValue = GList.pos_param;
                if (index < _virtualItems.length && saved - yValue > _virtualItems[index].height / 2 && index < _realNumItems)
                    yValue += _virtualItems[index].height + _lineGap;
            }
            else if (_layout == ListLayoutType.SingleRow || _layout == ListLayoutType.FlowVertical)
            {
                saved = xValue;
                GList.pos_param = xValue;
                index = getIndexOnPos2(false);
                xValue = GList.pos_param;
                if (index < _virtualItems.length && saved - xValue > _virtualItems[index].width / 2 && index < _realNumItems)
                    xValue += _virtualItems[index].width + _columnGap;
            }
            else
            {
                saved = xValue;
                GList.pos_param = xValue;
                index = getIndexOnPos3(false);
                xValue = GList.pos_param;
                if (index < _virtualItems.length && saved - xValue > _virtualItems[index].width / 2 && index < _realNumItems)
                    xValue += _virtualItems[index].width + _columnGap;
            }

            resultPoint.x = xValue;
            resultPoint.y = yValue;
            return resultPoint;
        }
        else
            return super.getSnappingPosition(xValue, yValue, resultPoint);
    }

    public function scrollToView(index:Int, ani:Bool = false, setFirst:Bool = false):Void
    {
        if (_virtual)
        {
            if (_numItems == 0)
                return;

            checkVirtualList();

            if (index >= _virtualItems.length)
                throw new Error("Invalid child index: " + index + ">" + _virtualItems.length);

            if (_loop)
                index = Math.floor(_firstIndex / _numItems) * _numItems + index;

            var rect:Rectangle;
            var ii:ItemInfo = _virtualItems[index];
            var pos:Float = 0;
            var i:Int;
            if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
            {
                i = 0;
                while (i < index)
                {
                    pos += _virtualItems[i].height + _lineGap;
                    i += _curLineItemCount;
                }
                rect = new Rectangle(0, pos, _itemSize.x, ii.height);
            }
            else if (_layout == ListLayoutType.SingleRow || _layout == ListLayoutType.FlowVertical)
            {
                i = 0;
                while (i < index)
                {
                    pos += _virtualItems[i].width + _columnGap;
                    i += _curLineItemCount;
                }
                rect = new Rectangle(pos, 0, ii.width, _itemSize.y);
            }
            else
            {
                var page:Int = Std.int(index / (_curLineItemCount * _curLineItemCount2));
                rect = new Rectangle(page * viewWidth + (index % _curLineItemCount) * (ii.width + _columnGap),
                (index / _curLineItemCount) % _curLineItemCount2 * (ii.height + _lineGap),
                ii.width, ii.height);
            }

            setFirst = true; //因为在可变item大小的情况下，只有设置在最顶端，位置才不会因为高度变化而改变，所以只能支持setFirst=true
            if (_scrollPane != null)
                scrollPane.scrollToView(rect, ani, setFirst);
        }
        else
        {
            var obj:GObject = getChildAt(index);
            if (_scrollPane != null)
                scrollPane.scrollToView(obj, ani, setFirst);
            else if (parent != null && parent.scrollPane != null)
                parent.scrollPane.scrollToView(obj, ani, setFirst);
        }
    }

    override public function getFirstChildInView():Int
    {
        return childIndexToItemIndex(super.getFirstChildInView());
    }

    public function childIndexToItemIndex(index:Int):Int
    {
        if (!_virtual)
            return index;

        if (_layout == ListLayoutType.Pagination)
        {
            for (i in _firstIndex..._realNumItems)
            {
                if (_virtualItems[i].obj != null)
                {
                    index--;
                    if (index < 0)
                        return i;
                }
            }

            return index;
        }
        else
        {
            index += _firstIndex;
            if (_loop && _numItems > 0)
                index = index % _numItems;

            return index;
        }
    }

    public function itemIndexToChildIndex(index:Int):Int
    {
        if (!_virtual)
            return index;

        if (_layout == ListLayoutType.Pagination)
        {
            return getChildIndex(_virtualItems[index].obj);
        }
        else
        {
            if (_loop && _numItems > 0)
            {
                var j:Int = _firstIndex % _numItems;
                if (index >= j)
                    index = _firstIndex + (index - j);
                else
                    index = _firstIndex + _numItems + (j - index);
            }
            else
                index -= _firstIndex;

            return index;
        }
    }

    public function setVirtual():Void
    {
        _setVirtual(false);
    }

    /// <summary>
    /// Set the list to be virtual list, and has loop behavior.
    /// </summary>
    public function setVirtualAndLoop():Void
    {
        _setVirtual(true);
    }

    /// <summary>
    /// Set the list to be virtual list.
    /// </summary>
    private function _setVirtual(loop:Bool):Void
    {
        if (!_virtual)
        {
            if (_scrollPane == null)
                throw new Error("PEngine: Virtual list must be scrollable!");

            if (loop)
            {
                if (_layout == ListLayoutType.FlowHorizontal || _layout == ListLayoutType.FlowVertical)
                    throw new Error("PEngine: Loop list is not supported for FlowHorizontal or FlowVertical layout!");

                _scrollPane.bouncebackEffect = false;
            }

            _virtual = true;
            _loop = loop;
            _virtualItems = new Array<ItemInfo>();
            removeChildrenToPool();

            if (_itemSize == null)
            {
                _itemSize = new Point();
                var obj:GObject = getFromPool(null);
                if (obj == null)
                {
                    throw new Error("PEngine: Virtual List must have a default list item resource.");
                    _itemSize.x = 100;
                    _itemSize.y = 100;
                }
                else
                {
                    _itemSize.x = obj.width;
                    _itemSize.y = obj.height;
                    returnToPool(obj);
                }
            }

            if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
                _scrollPane.scrollSpeed = Std.int(_itemSize.y);
            else
                _scrollPane.scrollSpeed = Std.int(_itemSize.x);

            _scrollPane.addEventListener(Event.SCROLL, __scrolled);
            setVirtualListChangedFlag(true);
        }
    }

    /// <summary>
    /// Set the list item count.
    /// If the list is not virtual, specified number of items will be created.
    /// If the list is virtual, only items in view will be created.
    /// </summary>
    private function get_numItems():Int
    {
        if (_virtual)
            return _numItems;
        else
            return _children.length;
    }

    private function set_numItems(value:Int):Int
    {
        var i:Int;

        if (_virtual)
        {
            if (itemRenderer == null)
                throw new Error("PEngine: Set itemRenderer first!");

            _numItems = value;
            if (_loop)
                _realNumItems = _numItems * 5;
                //设置5倍数量，用于循环滚动
            else
                _realNumItems = _numItems;

            //_virtualItems的设计是只增不减的
            var oldCount:Int = _virtualItems.length;
            if (_realNumItems > oldCount)
            {
                for (i in oldCount..._realNumItems)
                {
                    var ii:ItemInfo = new ItemInfo();
                    ii.width = _itemSize.x;
                    ii.height = _itemSize.y;

                    _virtualItems.push(ii);
                }
            }
            else
            {
                for (i in _realNumItems...oldCount)
                    _virtualItems[i].selected = false;
            }

            if (this._virtualListChanged != 0)
                GTimers.inst.remove(_refreshVirtualList); //立即刷新


            _refreshVirtualList();
        }
        else
        {
            var cnt:Int = _children.length;
            if (value > cnt)
            {
                for (i in cnt...value)
                {
                    if (itemProvider == null)
                        addItemFromPool();
                    else
                        addItemFromPool(itemProvider(i));
                }
            }
            else
            {
                removeChildrenToPool(value, cnt);
            }

            if (itemRenderer != null)
            {
                for (i in 0...value)
                {
                    itemRenderer(i, getChildAt(i));
                }
            }
        }
        return value;
    }

    public function refreshVirtualList():Void
    {
        setVirtualListChangedFlag(false);
    }

    private function checkVirtualList():Void
    {
        if (this._virtualListChanged != 0)
        {
            this._refreshVirtualList();
            GTimers.inst.remove(_refreshVirtualList);
        }
    }

    private function setVirtualListChangedFlag(layoutChanged:Bool = false):Void
    {
        if (layoutChanged)
            _virtualListChanged = 2;
        else if (_virtualListChanged == 0)
            _virtualListChanged = 1;

        GTimers.inst.callLater(_refreshVirtualList);
    }

    private function _refreshVirtualList():Void
    {
        var layoutChanged:Bool = _virtualListChanged == 2;
        _virtualListChanged = 0;
        _eventLocked = true;

        if (layoutChanged)
        {
            if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.SingleRow)
                _curLineItemCount = 1;
            else if (_layout == ListLayoutType.FlowHorizontal)
            {
                if (_columnCount > 0)
                    _curLineItemCount = _columnCount;
                else
                {
                    _curLineItemCount = Math.floor((_scrollPane.viewWidth + _columnGap) / (_itemSize.x + _columnGap));
                    if (_curLineItemCount <= 0)
                        _curLineItemCount = 1;
                }
            }
            else if (_layout == ListLayoutType.FlowVertical)
            {
                if (_lineCount > 0)
                    _curLineItemCount = _lineCount;
                else
                {
                    _curLineItemCount = Math.floor((_scrollPane.viewHeight + _lineGap) / (_itemSize.y + _lineGap));
                    if (_curLineItemCount <= 0)
                        _curLineItemCount = 1;
                }
            }
            else //pagination
            {
                if (_columnCount > 0)
                    _curLineItemCount = _columnCount;
                else
                {
                    _curLineItemCount = Math.floor((_scrollPane.viewWidth + _columnGap) / (_itemSize.x + _columnGap));
                    if (_curLineItemCount <= 0)
                        _curLineItemCount = 1;
                }

                if (_lineCount > 0)
                    _curLineItemCount2 = _lineCount;
                else
                {
                    _curLineItemCount2 = Math.floor((_scrollPane.viewHeight + _lineGap) / (_itemSize.y + _lineGap));
                    if (_curLineItemCount2 <= 0)
                        _curLineItemCount2 = 1;
                }

            }
        }

        var ch:Float = 0;
        var cw:Float = 0;
        if (_realNumItems > 0)
        {
            var i:Int;
            var len:Int = Math.ceil(_realNumItems / _curLineItemCount) * _curLineItemCount;
            var len2:Int = Std.int(Math.min(_curLineItemCount, _realNumItems));
            if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
            {
                i = 0;
                while (i < len)
                {
                    ch += _virtualItems[i].height + _lineGap;
                    i += _curLineItemCount;
                }
                if (ch > 0)
                    ch -= _lineGap;

                if (_autoResizeItem)
                    cw = scrollPane.viewWidth;
                else
                {
                    for (i in 0...len2)
                        cw += _virtualItems[i].width + _columnGap;
                    if (cw > 0)
                        cw -= _columnGap;
                }
            }
            else if (_layout == ListLayoutType.SingleRow || _layout == ListLayoutType.FlowVertical)
            {
                i = 0;
                while (i < len)
                {
                    cw += _virtualItems[i].width + _columnGap;
                    i += _curLineItemCount;
                }
                if (cw > 0)
                    cw -= _columnGap;

                if (_autoResizeItem)
                    ch = this.scrollPane.viewHeight;
                else
                {
                    for (i in 0...len2)
                        ch += _virtualItems[i].height + _lineGap;
                    if (ch > 0)
                        ch -= _lineGap;
                }
            }
            else
            {
                var pageCount:Int = Math.ceil(len / (_curLineItemCount * _curLineItemCount2));
                cw = pageCount * viewWidth;
                ch = viewHeight;
            }
        }

        handleAlign(cw, ch);
        _scrollPane.setContentSize(cw, ch);

        _eventLocked = false;

        handleScroll(true);
    }

    private function __scrolled(evt:Event):Void
    {
        handleScroll(false);
    }

    private function getIndexOnPos1(forceUpdate:Bool):Int
    {
        if (_realNumItems < _curLineItemCount)
        {
            pos_param = 0;
            return 0;
        }

        var i:Int;
        var pos2:Float;
        var pos3:Float;

        if (numChildren > 0 && !forceUpdate)
        {
            pos2 = this.getChildAt(0).y;
            if (pos2 > pos_param)
            {
                for (i in _firstIndex - _curLineItemCount...0)
                {
                    pos2 -= (_virtualItems[i].height + _lineGap);
                    if (pos2 <= pos_param)
                    {
                        pos_param = pos2;
                        return i;
                    }
                }

                pos_param = 0;
                return 0;
            }
            else
            {
                for (i in _firstIndex..._realNumItems)
                {
                    pos3 = pos2 + _virtualItems[i].height + _lineGap;
                    if (pos3 > pos_param)
                    {
                        pos_param = pos2;
                        return i;
                    }
                    pos2 = pos3;
                }

                pos_param = pos2;
                return _realNumItems - _curLineItemCount;
            }
        }
        else
        {
            pos2 = 0;
            for (i in 0..._realNumItems)
            {
                pos3 = pos2 + _virtualItems[i].height + _lineGap;
                if (pos3 > pos_param)
                {
                    pos_param = pos2;
                    return i;
                }
                pos2 = pos3;
            }

            pos_param = pos2;
            return _realNumItems - _curLineItemCount;
        }
    }

    private function getIndexOnPos2(forceUpdate:Bool):Int
    {
        if (_realNumItems < _curLineItemCount)
        {
            pos_param = 0;
            return 0;
        }

        var i:Int;
        var pos2:Float;
        var pos3:Float;

        if (numChildren > 0 && !forceUpdate)
        {
            pos2 = this.getChildAt(0).x;
            if (pos2 > pos_param)
            {
                for (i in _firstIndex - _curLineItemCount...0)
                {
                    pos2 -= (_virtualItems[i].width + _columnGap);
                    if (pos2 <= pos_param)
                    {
                        pos_param = pos2;
                        return i;
                    }
                }

                pos_param = 0;
                return 0;
            }
            else
            {
                for (i in _firstIndex..._realNumItems)
                {
                    pos3 = pos2 + _virtualItems[i].width + _columnGap;
                    if (pos3 > pos_param)
                    {
                        pos_param = pos2;
                        return i;
                    }
                    pos2 = pos3;
                }

                pos_param = pos2;
                return _realNumItems - _curLineItemCount;
            }
        }
        else
        {
            pos2 = 0;
            for (i in 0..._realNumItems)
            {
                pos3 = pos2 + _virtualItems[i].width + _columnGap;
                if (pos3 > pos_param)
                {
                    pos_param = pos2;
                    return i;
                }
                pos2 = pos3;
            }

            pos_param = pos2;
            return _realNumItems - _curLineItemCount;
        }
    }

    private function getIndexOnPos3(forceUpdate:Bool):Int
    {
        if (_realNumItems < _curLineItemCount)
        {
            pos_param = 0;
            return 0;
        }

        var viewWidth:Float = this.viewWidth;
        var page:Int = Math.floor(pos_param / viewWidth);
        var startIndex:Int = page * (_curLineItemCount * _curLineItemCount2);
        var pos2:Float = page * viewWidth;
        var i:Int;
        var pos3:Float;
        for (i in 0..._curLineItemCount)
        {
            pos3 = pos2 + _virtualItems[startIndex + i].width + _columnGap;
            if (pos3 > pos_param)
            {
                pos_param = pos2;
                return startIndex + i;
            }
            pos2 = pos3;
        }

        pos_param = pos2;
        return startIndex + _curLineItemCount - 1;
    }

    private function handleScroll(forceUpdate:Bool):Void
    {
        if (_eventLocked)
            return;

        var pos:Float;
        var roundSize:Int;

        if (_layout == ListLayoutType.SingleColumn || _layout == ListLayoutType.FlowHorizontal)
        {
            if (_loop)
            {
                pos = scrollPane.scrollingPosY;
                //循环列表的核心实现，滚动到头尾时重新定位
                roundSize = Std.int(_numItems * (_itemSize.y + _lineGap));
                if (pos == 0)
                    scrollPane.posY = roundSize;
                else if (pos == scrollPane.contentHeight - scrollPane.viewHeight)
                    scrollPane.posY = scrollPane.contentHeight - roundSize - this.viewHeight;
            }

            handleScroll1(forceUpdate);
            handleArchOrder1();
        }
        else if (_layout == ListLayoutType.SingleRow || _layout == ListLayoutType.FlowVertical)
        {
            if (_loop)
            {
                pos = scrollPane.scrollingPosX;
                //循环列表的核心实现，滚动到头尾时重新定位
                roundSize = Std.int(_numItems * (_itemSize.x + _columnGap));
                if (pos == 0)
                    scrollPane.posX = roundSize;
                else if (pos == scrollPane.contentWidth - scrollPane.viewWidth)
                    scrollPane.posX = scrollPane.contentWidth - roundSize - this.viewWidth;
            }

            handleScroll2(forceUpdate);
            handleArchOrder2();
        }
        else
        {
            if (_loop)
            {
                pos = scrollPane.scrollingPosX;
                //循环列表的核心实现，滚动到头尾时重新定位
                roundSize = Std.int((_numItems / (_curLineItemCount * _curLineItemCount2)) * viewWidth);
                if (pos == 0)
                    scrollPane.posX = roundSize;
                else if (pos == scrollPane.contentWidth - scrollPane.viewWidth)
                    scrollPane.posX = scrollPane.contentWidth - roundSize - this.viewWidth;
            }

            handleScroll3(forceUpdate);
        }

        _boundsChanged = false;
    }

    private static var itemInfoVer:Int = 0; //用来标志item是否在本次处理中已经被重用了
    private static var enterCounter:Int = 0; //因为HandleScroll是会重入的，这个用来避免极端情况下的死锁
    private static var pos_param:Float;

    private function handleScroll1(forceUpdate:Bool):Void
    {
        enterCounter++;
        if (enterCounter > 3)
            return;

        var pos:Float = scrollPane.scrollingPosY;
        var max:Float = pos + scrollPane.viewHeight;
        var end:Bool = max == scrollPane.contentHeight; //这个标志表示当前需要滚动到最末，无论内容变化大小

        //寻找当前位置的第一条项目
        GList.pos_param = pos;
        var newFirstIndex:Int = getIndexOnPos1(forceUpdate);
        pos = GList.pos_param;
        if (newFirstIndex == _firstIndex && !forceUpdate)
        {
            enterCounter--;
            return;
        }

        var oldFirstIndex:Int = _firstIndex;
        _firstIndex = newFirstIndex;
        var curIndex:Int = newFirstIndex;
        var forward:Bool = oldFirstIndex > newFirstIndex;
        var oldCount:Int = this.numChildren;
        var lastIndex:Int = oldFirstIndex + oldCount - 1;
        var reuseIndex:Int = (forward) ? lastIndex : oldFirstIndex;
        var curX:Float = 0;
        var curY:Float = pos;
        var needRender:Bool;
        var deltaSize:Float = 0;
        var firstItemDeltaSize:Float = 0;
        var url:String = defaultItem;
        var ii:ItemInfo;
        var ii2:ItemInfo;
        var i:Int;
        var j:Int;
        var partSize:Int = Std.int((scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount);

        itemInfoVer++;

        while (curIndex < _realNumItems && (end || curY < max))
        {
            ii = _virtualItems[curIndex];

            if (ii.obj == null || forceUpdate)
            {
                if (itemProvider != null)
                {
                    url = itemProvider(curIndex % _numItems);
                    if (url == null)
                        url = _defaultItem;
                    url = UIPackage.normalizeURL(url);
                }

                if (ii.obj != null && ii.obj.resourceURL != url)
                {
                    if (Std.isOfType(ii.obj, GButton))
                        ii.selected = cast(ii.obj, GButton).selected;
                    removeChildToPool(ii.obj);
                    ii.obj = null;
                }
            }

            if (ii.obj == null)
            {
                //搜索最适合的重用item，保证每次刷新需要新建或者重新render的item最少
                if (forward)
                {
                    j = reuseIndex;
                    while (j >= oldFirstIndex)
                    {
                        ii2 = _virtualItems[j];
                        if (ii2.obj != null && ii2.updateFlag != itemInfoVer && ii2.obj.resourceURL == url)
                        {
                            if (Std.isOfType(ii2.obj, GButton))
                                ii2.selected = cast(ii2.obj, GButton).selected;
                            ii.obj = ii2.obj;
                            ii2.obj = null;
                            if (j == reuseIndex)
                                reuseIndex--;
                            break;
                        }
                        j--;
                    }
                }
                else
                {
                    for (j in reuseIndex...lastIndex+1)
                    {
                        ii2 = _virtualItems[j];
                        if (ii2.obj != null && ii2.updateFlag != itemInfoVer && ii2.obj.resourceURL == url)
                        {
                            if (Std.isOfType(ii2.obj, GButton))
                                ii2.selected = cast(ii2.obj, GButton).selected;
                            ii.obj = ii2.obj;
                            ii2.obj = null;
                            if (j == reuseIndex)
                                reuseIndex++;
                            break;
                        }
                    }
                }

                if (ii.obj != null)
                {
                    setChildIndex(ii.obj, (forward) ? curIndex - newFirstIndex : numChildren);
                }
                else
                {
                    ii.obj = _pool.getObject(url);
                    if (forward)
                        this.addChildAt(ii.obj, curIndex - newFirstIndex);
                    else
                        this.addChild(ii.obj);
                }
                if (Std.isOfType(ii.obj, GButton))
                    cast(ii.obj, GButton).selected = ii.selected;

                needRender = true;
            }
            else
                needRender = forceUpdate;

            if (needRender)
            {
                if (_autoResizeItem && (_layout == ListLayoutType.SingleColumn || _columnCount > 0))
                    ii.obj.setSize(partSize, ii.obj.height, true);

                itemRenderer(curIndex % _numItems, ii.obj);
                if (curIndex % _curLineItemCount == 0)
                {
                    deltaSize += Math.ceil(ii.obj.height) - ii.height;
                    if (curIndex == newFirstIndex && oldFirstIndex > newFirstIndex)
                    {
                        //当内容向下滚动时，如果新出现的项目大小发生变化，需要做一个位置补偿，才不会导致滚动跳动
                        firstItemDeltaSize = Math.ceil(ii.obj.height) - ii.height;
                    }
                }
                ii.width = Math.ceil(ii.obj.width);
                ii.height = Math.ceil(ii.obj.height);
            }

            ii.updateFlag = itemInfoVer;
            ii.obj.setXY(curX, curY);
            if (curIndex == newFirstIndex) //要显示多一条才不会穿帮
                max += ii.height;

            curX += ii.width + _columnGap;

            if (curIndex % _curLineItemCount == _curLineItemCount - 1)
            {
                curX = 0;
                curY += ii.height + _lineGap;
            }
            curIndex++;
        }

        for (i in 0...oldCount)
        {
            ii = _virtualItems[oldFirstIndex + i];
            if (ii.updateFlag != itemInfoVer && ii.obj != null)
            {
                if (Std.isOfType(ii.obj, GButton))
                    ii.selected = cast(ii.obj, GButton).selected;
                removeChildToPool(ii.obj);
                ii.obj = null;
            }
        }

        if (deltaSize != 0 || firstItemDeltaSize != 0)
            _scrollPane.changeContentSizeOnScrolling(0, deltaSize, 0, firstItemDeltaSize);

        if (curIndex > 0 && this.numChildren > 0 && _container.y < 0 && getChildAt(0).y > -_container.y) //最后一页没填满！
            handleScroll1(false);

        enterCounter--;
    }

    private function handleScroll2(forceUpdate:Bool):Void
    {
        enterCounter++;
        if (enterCounter > 3)
            return;

        var pos:Float = scrollPane.scrollingPosX;
        var max:Float = pos + scrollPane.viewWidth;
        var end:Bool = pos == scrollPane.contentWidth; //这个标志表示当前需要滚动到最末，无论内容变化大小

        //寻找当前位置的第一条项目
        GList.pos_param = pos;
        var newFirstIndex:Int = getIndexOnPos2(forceUpdate);
        pos = GList.pos_param;
        if (newFirstIndex == _firstIndex && !forceUpdate)
        {
            enterCounter--;
            return;
        }

        var oldFirstIndex:Int = _firstIndex;
        _firstIndex = newFirstIndex;
        var curIndex:Int = newFirstIndex;
        var forward:Bool = oldFirstIndex > newFirstIndex;
        var oldCount:Int = this.numChildren;
        var lastIndex:Int = oldFirstIndex + oldCount - 1;
        var reuseIndex:Int = (forward) ? lastIndex : oldFirstIndex;
        var curX:Float = pos;
        var curY:Float = 0;
        var needRender:Bool;
        var deltaSize:Float = 0;
        var firstItemDeltaSize:Float = 0;
        var url:String = defaultItem;
        var ii:ItemInfo;
        var ii2:ItemInfo;
        var i:Int;
        var j:Int;
        var partSize:Int = Std.int((scrollPane.viewHeight - _lineGap * (_curLineItemCount - 1)) / _curLineItemCount);

        itemInfoVer++;

        while (curIndex < _realNumItems && (end || curX < max))
        {
            ii = _virtualItems[curIndex];

            if (ii.obj == null || forceUpdate)
            {
                if (itemProvider != null)
                {
                    url = itemProvider(curIndex % _numItems);
                    if (url == null)
                        url = _defaultItem;
                    url = UIPackage.normalizeURL(url);
                }

                if (ii.obj != null && ii.obj.resourceURL != url)
                {
                    if (Std.isOfType(ii.obj, GButton))
                        ii.selected = cast(ii.obj, GButton).selected;
                    removeChildToPool(ii.obj);
                    ii.obj = null;
                }
            }

            if (ii.obj == null)
            {
                if (forward)
                {
                    j = reuseIndex;
                    while (j >= oldFirstIndex)
                    {
                        ii2 = _virtualItems[j];
                        if (ii2.obj != null && ii2.updateFlag != itemInfoVer && ii2.obj.resourceURL == url)
                        {
                            if (Std.isOfType(ii2.obj, GButton))
                                ii2.selected = cast(ii2.obj, GButton).selected;
                            ii.obj = ii2.obj;
                            ii2.obj = null;
                            if (j == reuseIndex)
                                reuseIndex--;
                            break;
                        }
                        j--;
                    }
                }
                else
                {
                    for (j in reuseIndex...lastIndex+1)
                    {
                        ii2 = _virtualItems[j];
                        if (ii2.obj != null && ii2.updateFlag != itemInfoVer && ii2.obj.resourceURL == url)
                        {
                            if (Std.isOfType(ii2.obj, GButton))
                                ii2.selected = cast(ii2.obj, GButton).selected;
                            ii.obj = ii2.obj;
                            ii2.obj = null;
                            if (j == reuseIndex)
                                reuseIndex++;
                            break;
                        }
                    }
                }

                if (ii.obj != null)
                {
                    setChildIndex(ii.obj, (forward) ? curIndex - newFirstIndex : numChildren);
                }
                else
                {
                    ii.obj = _pool.getObject(url);
                    if (forward)
                        this.addChildAt(ii.obj, curIndex - newFirstIndex);
                    else
                        this.addChild(ii.obj);
                }
                if (Std.isOfType(ii.obj, GButton))
                    cast(ii.obj, GButton).selected = ii.selected;

                needRender = true;
            }
            else
                needRender = forceUpdate;

            if (needRender)
            {
                if (_autoResizeItem && (_layout == ListLayoutType.SingleRow || _lineCount > 0))
                    ii.obj.setSize(ii.obj.width, partSize, true);

                itemRenderer(curIndex % _numItems, ii.obj);
                if (curIndex % _curLineItemCount == 0)
                {
                    deltaSize += Math.ceil(ii.obj.width) - ii.width;
                    if (curIndex == newFirstIndex && oldFirstIndex > newFirstIndex)
                    {
                        //当内容向下滚动时，如果新出现的一个项目大小发生变化，需要做一个位置补偿，才不会导致滚动跳动
                        firstItemDeltaSize = Math.ceil(ii.obj.width) - ii.width;
                    }
                }
                ii.width = Math.ceil(ii.obj.width);
                ii.height = Math.ceil(ii.obj.height);
            }

            ii.updateFlag = itemInfoVer;
            ii.obj.setXY(curX, curY);
            if (curIndex == newFirstIndex) //要显示多一条才不会穿帮
                max += ii.width;

            curY += ii.height + _lineGap;

            if (curIndex % _curLineItemCount == _curLineItemCount - 1)
            {
                curY = 0;
                curX += ii.width + _columnGap;
            }
            curIndex++;
        }

        for (i in 0...oldCount)
        {
            ii = _virtualItems[oldFirstIndex + i];
            if (ii.updateFlag != itemInfoVer && ii.obj != null)
            {
                if (Std.isOfType(ii.obj, GButton))
                    ii.selected = cast(ii.obj, GButton).selected;
                removeChildToPool(ii.obj);
                ii.obj = null;
            }
        }

        if (deltaSize != 0 || firstItemDeltaSize != 0)
            _scrollPane.changeContentSizeOnScrolling(deltaSize, 0, firstItemDeltaSize, 0);

        if (curIndex > 0 && this.numChildren > 0 && _container.x < 0 && getChildAt(0).x > -_container.x) //最后一页没填满！
            handleScroll2(false);

        enterCounter--;
    }

    private function handleScroll3(forceUpdate:Bool):Void
    {
        var pos:Float = scrollPane.scrollingPosX;

        //寻找当前位置的第一条项目
        GList.pos_param = pos;
        var newFirstIndex:Int = getIndexOnPos3(forceUpdate);
        pos = GList.pos_param;
        if (newFirstIndex == _firstIndex && !forceUpdate)
            return;

        var oldFirstIndex:Int = _firstIndex;
        _firstIndex = newFirstIndex;

        //分页模式不支持不等高，所以渲染满一页就好了

        var reuseIndex:Int = oldFirstIndex;
        var virtualItemCount:Int = _virtualItems.length;
        var pageSize:Int = _curLineItemCount * _curLineItemCount2;
        var startCol:Int = newFirstIndex % _curLineItemCount;
        var viewWidth:Float = this.viewWidth;
        var page:Int = Std.int(newFirstIndex / pageSize);
        var startIndex:Int = page * pageSize;
        var lastIndex:Int = startIndex + pageSize * 2; //测试两页
        var needRender:Bool;
        var i:Int;
        var ii:ItemInfo;
        var ii2:ItemInfo;
        var col:Int;
        var url:String = _defaultItem;
        var partWidth:Int = Std.int((scrollPane.viewWidth - _columnGap * (_curLineItemCount - 1)) / _curLineItemCount);
        var partHeight:Int = Std.int((scrollPane.viewHeight - _lineGap * (_curLineItemCount2 - 1)) / _curLineItemCount2);

        itemInfoVer++;

        //先标记这次要用到的项目
        for (i in startIndex...lastIndex)
        {
            if (i >= _realNumItems)
                continue;

            col = i % _curLineItemCount;
            if (i - startIndex < pageSize)
            {
                if (col < startCol)
                    continue;
            }
            else
            {
                if (col > startCol)
                    continue;
            }

            ii = _virtualItems[i];
            ii.updateFlag = itemInfoVer;
        }

        var lastObj:GObject = null;
        var insertIndex:Int = 0;
        for (i in startIndex...lastIndex)
        {
            if (i >= _realNumItems)
                continue;

            ii = _virtualItems[i];
            if (ii.updateFlag != itemInfoVer)
                continue;

            if (ii.obj == null)
            {
                //寻找看有没有可重用的
                while (reuseIndex < virtualItemCount)
                {
                    ii2 = _virtualItems[reuseIndex];
                    if (ii2.obj != null && ii2.updateFlag != itemInfoVer)
                    {
                        if (Std.isOfType(ii2.obj, GButton))
                            ii2.selected = cast(ii2.obj, GButton).selected;
                        ii.obj = ii2.obj;
                        ii2.obj = null;
                        break;
                    }
                    reuseIndex++;
                }

                if (insertIndex == -1)
                    insertIndex = getChildIndex(lastObj) + 1;

                if (ii.obj == null)
                {
                    if (itemProvider != null)
                    {
                        url = itemProvider(i % _numItems);
                        if (url == null)
                            url = _defaultItem;
                        url = UIPackage.normalizeURL(url);
                    }

                    ii.obj = _pool.getObject(url);
                    this.addChildAt(ii.obj, insertIndex);
                }
                else
                {
                    insertIndex = setChildIndexBefore(ii.obj, insertIndex);
                }
                insertIndex++;

                if (Std.isOfType(ii.obj, GButton))
                    cast(ii.obj, GButton).selected = ii.selected;

                needRender = true;
            }
            else
            {
                needRender = forceUpdate;
                insertIndex = -1;
                lastObj = ii.obj;
            }

            if (needRender)
            {
                if (_autoResizeItem)
                {
                    if (_curLineItemCount == _columnCount && _curLineItemCount2 == _lineCount)
                        ii.obj.setSize(partWidth, partHeight, true);
                    else if (_curLineItemCount == _columnCount)
                        ii.obj.setSize(partWidth, ii.obj.height, true);
                    else if (_curLineItemCount2 == _lineCount)
                        ii.obj.setSize(ii.obj.width, partHeight, true);
                }

                itemRenderer(i % _numItems, ii.obj);
                ii.width = Math.ceil(ii.obj.width);
                ii.height = Math.ceil(ii.obj.height);
            }
        }

        //排列item
        var borderX:Int = Std.int((startIndex / pageSize) * viewWidth);
        var xx:Int = borderX;
        var yy:Int = 0;
        var lineHeight:Int = 0;
        for (i in startIndex...lastIndex)
        {
            if (i >= _realNumItems)
                continue;

            ii = _virtualItems[i];
            if (ii.updateFlag == itemInfoVer)
                ii.obj.setXY(xx, yy);

            if (ii.height > lineHeight)
                lineHeight = Std.int(ii.height);
            if (i % _curLineItemCount == _curLineItemCount - 1)
            {
                xx = borderX;
                yy += lineHeight + _lineGap;
                lineHeight = 0;

                if (i == startIndex + pageSize - 1)
                {
                    borderX += Std.int(viewWidth);
                    xx = borderX;
                    yy = 0;
                }
            }
            else
                xx += Std.int(ii.width + _columnGap);

        }

        //释放未使用的
        for (i in reuseIndex...virtualItemCount)
        {
            ii = _virtualItems[i];
            if (ii.updateFlag != itemInfoVer && ii.obj != null)
            {
                if (Std.isOfType(ii.obj, GButton))
                    ii.selected = cast(ii.obj, GButton).selected;
                removeChildToPool(ii.obj);
                ii.obj = null;
            }
        }
    }

    private function handleArchOrder1():Void
    {
        if (this.childrenRenderOrder == ChildrenRenderOrder.Arch)
        {
            var mid:Float = _scrollPane.posY + this.viewHeight / 2;
            var minDist:Float = CompatUtil.INT_MAX_VALUE;
            var dist:Float;
            var apexIndex:Int = 0;
            var cnt:Int = this.numChildren;
            for (i in 0...cnt)
            {
                var obj:GObject = getChildAt(i);
                if (!foldInvisibleItems || obj.visible)
                {
                    dist = Math.abs(mid - obj.y - obj.height / 2);
                    if (dist < minDist)
                    {
                        minDist = dist;
                        apexIndex = i;
                    }
                }
            }
            this.apexIndex = apexIndex;
        }
    }

    private function handleArchOrder2():Void
    {
        if (this.childrenRenderOrder == ChildrenRenderOrder.Arch)
        {
            var mid:Float = _scrollPane.posX + this.viewWidth / 2;
            var minDist:Float = CompatUtil.INT_MAX_VALUE;
            var dist:Float;
            var apexIndex:Int = 0;
            var cnt:Int = this.numChildren;
            for (i in 0...cnt)
            {
                var obj:GObject = getChildAt(i);
                if (!foldInvisibleItems || obj.visible)
                {
                    dist = Math.abs(mid - obj.x - obj.width / 2);
                    if (dist < minDist)
                    {
                        minDist = dist;
                        apexIndex = i;
                    }
                }
            }
            this.apexIndex = apexIndex;
        }
    }

    private function handleAlign(contentWidth:Float, contentHeight:Float):Void
    {
        var newOffsetX:Float = 0;
        var newOffsetY:Float = 0;

        if (contentHeight < viewHeight)
        {
            if (_verticalAlign == VertAlignType.Middle)
                newOffsetY = Std.int((viewHeight - contentHeight) / 2);
            else if (_verticalAlign == VertAlignType.Bottom)
                newOffsetY = viewHeight - contentHeight;
        }

        if (contentWidth < this.viewWidth)
        {
            if (_align == AlignType.Center)
                newOffsetX = Std.int((viewWidth - contentWidth) / 2);
            else if (_align == AlignType.Right)
                newOffsetX = viewWidth - contentWidth;
        }

        if (newOffsetX != _alignOffset.x || newOffsetY != _alignOffset.y)
        {
            _alignOffset.setTo(newOffsetX, newOffsetY);
            if (scrollPane != null)
                scrollPane.adjustMaskContainer();
            else
            {
                _container.x = _margin.left + _alignOffset.x;
                _container.y = _margin.top + _alignOffset.y;
            }
        }
    }

    override private function updateBounds():Void
    {
        if (_virtual)
            return;

        var i:Int = 0;
        var j:Int = 0;
        var child:GObject;
        var curX:Int = 0;
        var curY:Int = 0;
        var maxWidth:Int = 0;
        var maxHeight:Int = 0;
        var cw:Int = 0;
        var ch:Int = 0;
        var j:Int = 0;
        var page:Int = 0;
        var k:Int = 0;
        var cnt:Int = _children.length;
        var viewWidth:Float = this.viewWidth;
        var viewHeight:Float = this.viewHeight;
        var lineSize:Float = 0;
        var lineStart:Int = 0;
        var ratio:Float;

        if (_layout == ListLayoutType.SingleColumn)
        {
            for (i in 0...cnt)
            {
                child = getChildAt(i);
                if (foldInvisibleItems && !child.visible)
                    continue;

                if (curY != 0)
                    curY += _lineGap;
                child.y = curY;
                if (_autoResizeItem)
                    child.setSize(viewWidth, child.height, true);
                curY += Math.ceil(child.height);
                if (child.width > maxWidth)
                    maxWidth = Std.int(child.width);
            }
            cw = Math.ceil(maxWidth);
            ch = curY;
        }
        else if (_layout == ListLayoutType.SingleRow)
        {
            for (i in 0...cnt)
            {
                child = getChildAt(i);
                if (foldInvisibleItems && !child.visible)
                    continue;

                if (curX != 0)
                    curX += _columnGap;
                child.x = curX;
                if (_autoResizeItem)
                    child.setSize(child.width, viewHeight, true);
                curX += Math.ceil(child.width);
                if (child.height > maxHeight)
                    maxHeight = Std.int(child.height);
            }
            cw = curX;
            ch = Math.ceil(maxHeight);
        }
        else if (_layout == ListLayoutType.FlowHorizontal)
        {
            if (_autoResizeItem && _columnCount > 0)
            {
                for (i in 0...cnt)
                {
                    child = getChildAt(i);
                    if (foldInvisibleItems && !child.visible)
                        continue;

                    lineSize += child.sourceWidth;
                    j++;
                    if (j == _columnCount || i == cnt - 1)
                    {
                        ratio = (viewWidth - lineSize - (j - 1) * _columnGap) / lineSize;
                        curX = 0;
                        for (j in lineStart...i + 1)
                        {
                            child = getChildAt(j);
                            if (foldInvisibleItems && !child.visible)
                                continue;

                            child.setXY(curX, curY);

                            if (j < i)
                            {
                                child.setSize(child.sourceWidth + Math.round(child.sourceWidth * ratio), child.height, true);
                                curX += Math.ceil(child.width) + _columnGap;
                            }
                            else
                            {
                                child.setSize(viewWidth - curX, child.height, true);
                            }
                            if (child.height > maxHeight)
                                maxHeight = Std.int(child.height);
                        }
                        //new line
                        curY += Math.ceil(maxHeight) + _lineGap;
                        maxHeight = 0;
                        j = 0;
                        lineStart = i + 1;
                        lineSize = 0;
                    }
                }
                ch = curY + Math.ceil(maxHeight);
                cw = Std.int(viewWidth);
            }
            else
            {
                for (i in 0...cnt)
                {
                    child = getChildAt(i);
                    if (foldInvisibleItems && !child.visible)
                        continue;

                    if (curX != 0)
                        curX += _columnGap;

                    if (_columnCount != 0 && j >= _columnCount
                        || _columnCount == 0 && curX + child.width > viewWidth && maxHeight != 0)
                    {
                        //new line
                        curX = 0;
                        curY += Math.ceil(maxHeight) + _lineGap;
                        maxHeight = 0;
                        j = 0;
                    }
                    child.setXY(curX, curY);
                    curX += Math.ceil(child.width);
                    if (curX > maxWidth)
                        maxWidth = curX;
                    if (child.height > maxHeight)
                        maxHeight = Std.int(child.height);
                    j++;
                }
                ch = curY + Math.ceil(maxHeight);
                cw = Math.ceil(maxWidth);
            }

        }
        else if (_layout == ListLayoutType.FlowVertical)
        {
            if (_autoResizeItem && _lineCount > 0)
            {
                for (i in 0...cnt)
                {
                    child = getChildAt(i);
                    if (foldInvisibleItems && !child.visible)
                        continue;

                    lineSize += child.sourceHeight;
                    j++;
                    if (j == _lineCount || i == cnt - 1)
                    {
                        ratio = (viewHeight - lineSize - (j - 1) * _lineGap) / lineSize;
                        curY = 0;
                        for (j in lineStart...i + 1)
                        {
                            child = getChildAt(j);
                            if (foldInvisibleItems && !child.visible)
                                continue;

                            child.setXY(curX, curY);

                            if (j < i)
                            {
                                child.setSize(child.width, child.sourceHeight + Math.round(child.sourceHeight * ratio), true);
                                curY += Math.ceil(child.height) + _lineGap;
                            }
                            else
                            {
                                child.setSize(child.width, viewHeight - curY, true);
                            }
                            if (child.width > maxWidth)
                                maxWidth = Std.int(child.width);
                        }
                        //new line
                        curX += Math.ceil(maxWidth) + _columnGap;
                        maxWidth = 0;
                        j = 0;
                        lineStart = i + 1;
                        lineSize = 0;
                    }
                }
                cw = curX + Math.ceil(maxWidth);
                ch = Std.int(viewHeight);
            }
            else
            {
                for (i in 0...cnt)
                {
                    child = getChildAt(i);
                    if (foldInvisibleItems && !child.visible)
                        continue;

                    if (curY != 0)
                        curY += _lineGap;

                    if (_lineCount != 0 && j >= _lineCount
                        || _lineCount == 0 && curY + child.height > viewHeight && maxWidth != 0)
                    {
                        curY = 0;
                        curX += Math.ceil(maxWidth) + _columnGap;
                        maxWidth = 0;
                        j = 0;
                    }
                    child.setXY(curX, curY);
                    curY += Math.ceil(child.height);
                    if (curY > maxHeight)
                        maxHeight = curY;
                    if (child.width > maxWidth)
                        maxWidth = Std.int(child.width);
                    j++;
                }
                cw = curX + Math.ceil(maxWidth);
                ch = Math.ceil(maxHeight);
            }

        }
        else //pagination
        {
            var eachHeight:Int = 0;
            if (_autoResizeItem && _lineCount > 0)
                eachHeight = Math.floor((viewHeight - (_lineCount - 1) * _lineGap) / _lineCount);

            if (_autoResizeItem && _columnCount > 0)
            {
                for (i in 0...cnt)
                {
                    child = getChildAt(i);
                    if (foldInvisibleItems && !child.visible)
                        continue;

                    lineSize += child.sourceWidth;
                    j++;
                    if (j == _columnCount || i == cnt - 1)
                    {
                        ratio = (viewWidth - lineSize - (j - 1) * _columnGap) / lineSize;
                        curX = 0;
                        for (j in lineStart...i + 1)
                        {
                            child = getChildAt(j);
                            if (foldInvisibleItems && !child.visible)
                                continue;

                            child.setXY(page * viewWidth + curX, curY);

                            if (j < i)
                            {
                                child.setSize(child.sourceWidth + Math.round(child.sourceWidth * ratio),
                                _lineCount > 0 ? eachHeight : child.height, true);
                                curX += Math.ceil(child.width) + _columnGap;
                            }
                            else
                            {
                                child.setSize(viewWidth - curX, _lineCount > 0 ? eachHeight : child.height, true);
                            }
                            if (child.height > maxHeight)
                                maxHeight = Std.int(child.height);
                        }
                        //new line
                        curY += Math.ceil(maxHeight) + _lineGap;
                        maxHeight = 0;
                        j = 0;
                        lineStart = i + 1;
                        lineSize = 0;

                        k++;

                        if (_lineCount != 0 && k >= _lineCount
                            || _lineCount == 0 && curY + child.height > viewHeight)
                        {
                            //new page
                            page++;
                            curY = 0;
                            k = 0;
                        }
                    }
                }
            }
            else
            {
                for (i in 0...cnt)
                {
                    child = getChildAt(i);
                    if (foldInvisibleItems && !child.visible)
                        continue;

                    if (curX != 0)
                        curX += _columnGap;

                    if (_autoResizeItem && _lineCount > 0)
                        child.setSize(child.width, eachHeight, true);

                    if (_columnCount != 0 && j >= _columnCount
                        || _columnCount == 0 && curX + child.width > viewWidth && maxHeight != 0)
                    {
                        //new line
                        curX = 0;
                        curY += Math.ceil(maxHeight) + _lineGap;
                        maxHeight = 0;
                        j = 0;
                        k++;

                        if (_lineCount != 0 && k >= _lineCount
                            || _lineCount == 0 && curY + child.height > viewHeight && maxWidth != 0)//new page
                        {
                            page++;
                            curY = 0;
                            k = 0;
                        }
                    }
                    child.setXY(page * viewWidth + curX, curY);
                    curX += Math.ceil(child.width);
                    if (curX > maxWidth)
                        maxWidth = curX;
                    if (child.height > maxHeight)
                        maxHeight = Std.int(child.height);
                    j++;
                }
            }
            ch = page > 0 ? Std.int(viewHeight) : curY + Math.ceil(maxHeight);
            cw = (page + 1) * Std.int(viewWidth);

        }

        handleAlign(cw, ch);
        setBounds(0, 0, cw, ch);
    }

    override public function setup_beforeAdd(xml:FastXML):Void
    {
        super.setup_beforeAdd(xml);

        var str:String;
        str = xml.att.layout;
        if (str != null)
            _layout = ListLayoutType.parse(str);

        var overflow:Int;
        str = xml.att.overflow;
        if (str != null)
            overflow = OverflowType.parse(str);
        else
            overflow = OverflowType.Visible;

        str = xml.att.margin;
        if (str != null)
            _margin.parse(str);

        str = xml.att.align;
        if (str != null)
            _align = AlignType.parse(str);

        str = xml.att.vAlign;
        if (str != null)
            _verticalAlign = VertAlignType.parse(str);

        if (overflow == OverflowType.Scroll)
        {
            var scroll:Int;
            str = xml.att.scroll;
            if (str != null)
                scroll = ScrollType.parse(str);
            else
                scroll = ScrollType.Vertical;

            var scrollBarDisplay:Int;
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
                var arr:Array<Dynamic> = str.split(",");
                vtScrollBarRes = arr[0];
                hzScrollBarRes = arr[1];
            }

            setupScroll(scrollBarMargin, scroll, scrollBarDisplay, scrollBarFlags,
            vtScrollBarRes, hzScrollBarRes);
        }
        else
            setupOverflow(overflow);

        str = xml.att.lineGap;
        if (str != null)
            _lineGap = Std.parseInt(str);

        str = xml.att.colGap;
        if (str != null)
            _columnGap = Std.parseInt(str);

        str = xml.att.lineItemCount;
        if (str != null)
        {
            if (_layout == ListLayoutType.FlowHorizontal || _layout == ListLayoutType.Pagination)
                _columnCount = Std.parseInt(str);
            else if (_layout == ListLayoutType.FlowVertical)
                _lineCount = Std.parseInt(str);
        }

        str = xml.att.lineItemCount2;
        if (str != null)
            _lineCount = Std.parseInt(str);

        str = xml.att.selectionMode;
        if (str != null)
            _selectionMode = ListSelectionMode.parse(str);

        str = xml.att.defaultItem;
        if (str != null)
            _defaultItem = str;

        str = xml.att.autoItemSize;
        if (_layout == ListLayoutType.SingleRow || _layout == ListLayoutType.SingleColumn)
            _autoResizeItem = str != "false";
        else
            _autoResizeItem = str == "true";

        str = xml.att.renderOrder;
        if (str != null)
        {
            _childrenRenderOrder = ChildrenRenderOrder.parse(str);
            if (_childrenRenderOrder == ChildrenRenderOrder.Arch)
            {
                str = xml.att.apex;
                if (str != null)
                    _apexIndex = Std.parseInt(str);
            }
        }

        var col:FastXMLList = xml.nodes.item;
        for (cxml in col.iterator())
        {
            var url:String = cxml.att.url;
            if (url == null)
                url = _defaultItem;
            if (url == null)
                continue;

            var obj:GObject = getFromPool(url);
            if (obj != null)
            {
                addChild(obj);
                str = cxml.att.title;
                if (str != null)
                    obj.text = str;
                str = cxml.att.icon;
                if (str != null)
                    obj.icon = str;
                str = cxml.att.name;
                if (str != null)
                    obj.name = str;
            }
        }
    }

    override public function setup_afterAdd(xml:FastXML):Void
    {
        super.setup_afterAdd(xml);

        var str:String = xml.att.selectionController;
        if (str != null)
            _selectionController = parent.getController(str);
    }
}


class ItemInfo
{
    public var width:Float = 0;
    public var height:Float = 0;
    public var obj:GObject;
    public var updateFlag:Int = 0;
    public var selected:Bool;

    public function new()
    {
    }
}

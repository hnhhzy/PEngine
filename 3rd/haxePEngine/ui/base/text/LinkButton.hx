package haxePEngine.ui.base.text;


import haxePEngine.ui.component.base.display.Sprite;

class LinkButton extends Sprite
{
    public var owner : HtmlNode;
    
    @:allow(haxePEngine.ui.base.text)
    private function new()
    {
        super();
    }

    public function setSize(w:Float, h:Float):Void
    {
        // 待补
        // buttonMode = true;
        // graphics.beginFill(0, 0);
        // graphics.drawRect(0, 0, w, h);
        // graphics.endFill();
    }
}

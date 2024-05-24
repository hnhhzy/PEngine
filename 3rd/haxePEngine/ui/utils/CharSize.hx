package haxePEngine.ui.utils;

import Reflect;
import haxePEngine.ui.component.base.display.BitmapData;
import haxePEngine.ui.component.base.geom.Rectangle;
import haxePEngine.ui.component.base.text.TextField;
import haxePEngine.ui.component.base.text.TextFieldAutoSize;
import haxePEngine.ui.component.base.text.TextFormat;

class CharSize
{
    private static var testTextField:TextField;
    private static var testTextField2:TextField;
    private static var testTextFormat:TextFormat;
    private static var results:Dynamic;
    private static var boldResults:Dynamic;
    private static var holderResults:Dynamic;

    private static var helperBmd:BitmapData;

    public static var TEST_STRING:String = "fj|_我案愛爱";
    public static var PLACEHOLDER_FONT:String = "Arial";

    public static function getSize(size:Int, font:String, bold:Bool):Dynamic
    {
        if (testTextField == null)
        {
            // 待补
            testTextField = new TextField();
            testTextField.autoSize = TextFieldAutoSize.LEFT;
            testTextField.text = TEST_STRING;

            if (testTextFormat == null)
                testTextFormat = new TextFormat();

            results = { };
            boldResults = { };
        }
        var col:Dynamic = (bold) ? Reflect.field(boldResults, font) : Reflect.field(results, font);
        if (col == null)
        {
            col = { };
            //col = new hl.types.ArrayDyn();
            if (bold)
                Reflect.setField(boldResults, font, col);
            else
                Reflect.setField(results, font, col);
        }
        //var ret:Dynamic = col[size];
        // 修复
        //var ret:Dynamic = try col[size] catch (e:Dynamic) null;
        var ret:Dynamic = try Reflect.field(col, Std.string(size)) catch (e:Dynamic) null;
        if (ret != null)
            return ret;

        ret = { };        
        // 修复
        Reflect.setField(col, Std.string(size), ret);
        //trace(col);
        //col[size] = ret;

        testTextFormat.font = font;
        testTextFormat.size = size;
        testTextFormat.bold = bold;
        // 待补
        // testTextField.setTextFormat(testTextFormat);
        // testTextField.embedFonts = FontUtils.isEmbeddedFont(testTextFormat);

        //ret.height = testTextField.textHeight;
        if (ret.height == 0)
            ret.height = size;

        if (helperBmd == null || helperBmd.width < testTextField.width || helperBmd.height < testTextField.height)
            helperBmd = new BitmapData(Std.int(Math.max(128, testTextField.width)), Std.int(Math.max(128, testTextField.height)), true, 0);
        else
            helperBmd.fillRect(helperBmd.rect, 0);

        // 待补
        //helperBmd.draw(testTextField);
        var bounds:Rectangle = helperBmd.getColorBoundsRect(0xFF000000, 0, false);
        ret.yIndent = bounds.top - 2 - Std.int((ret.height - Math.max(bounds.height, size)) / 2);
        
        //trace(col);
        return ret;
    }

    public static function getHolderWidth(font:String, size:Int):Int
    {
        // 待补
        return 0;
        // if (testTextField2 == null)
        // {
        //     testTextField2 = new TextField();
        //     testTextField2.autoSize = TextFieldAutoSize.LEFT;
        //     testTextField2.text = "　";

        //     if (testTextFormat == null)
        //         testTextFormat = new TextFormat();
        //     holderResults = {};
        // }
        // var col:Dynamic = Reflect.field(holderResults,font);
        // if (col == null)
        // {
        //     col = {};
        //     Reflect.setField(holderResults, font, col);
        // }
        // var ret:Dynamic = col[size];
        // if (Math.isNaN(ret))
        // {
        //     testTextFormat.font = font;
        //     testTextFormat.size = size;
        //     testTextFormat.bold = false;
        //     testTextField2.setTextFormat(testTextFormat);
        //     testTextField2.embedFonts = FontUtils.isEmbeddedFont(testTextFormat);

        //     ret = testTextField2.textWidth;
        //     col[size] = ret;
        // }

        // return Std.int(ret);
    }

    public function new()
    {
    }
}

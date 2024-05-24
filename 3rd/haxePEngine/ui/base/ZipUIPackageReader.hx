package haxePEngine.ui.base;


import haxe.io.Bytes;
import haxePEngine.ui.utils.ZipReader;
import haxePEngine.ui.component.base.utils.ByteArray;

class ZipUIPackageReader implements IUIPackageReader
{
    private var _desc:ZipReader;
    private var _files:ZipReader;

    public function new(desc:ByteArray, res:ByteArray)
    {
        _desc = new ZipReader(desc);
        if (res != null && res.length > 0)
            _files = new ZipReader(res);
        else
            _files = _desc;
    }

    public function readDescFile(fileName:String):String
    {
        var ba:ByteArray = _desc.getEntryData(fileName);
        ba.position = 0;
        var str:String = ba.readUTFBytes(ba.length);

        return str;
    }

    public function readResFile(fileName:String):ByteArray
    {
        return _files.getEntryData(fileName);
    }
}

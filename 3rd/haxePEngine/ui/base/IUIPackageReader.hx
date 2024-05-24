package haxePEngine.ui.base;


import haxePEngine.ui.component.base.utils.ByteArray;

interface IUIPackageReader
{
    function readDescFile(fileName : String) : String;
    function readResFile(fileName : String) : ByteArray;
}

package haxePEngine.ui.base;


interface IUISource
{
    var fileName(get, set) : String;    
    
    var loaded(get, never) : Bool;

    function load(callback : Dynamic) : Void;
}

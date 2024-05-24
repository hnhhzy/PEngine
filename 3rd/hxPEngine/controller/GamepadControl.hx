package hxPEngine.controller;

import hxd.Event;

class GamepadControl {
    public static function addEventTarget(callback:Event->Void):Void {
        hxd.Window.getInstance().addEventTarget(callback);
    }
    
}
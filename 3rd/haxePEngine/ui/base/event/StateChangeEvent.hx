package haxePEngine.ui.base.event;


import haxePEngine.ui.component.base.events.Event;

class StateChangeEvent extends Event
{
    public static inline var CHANGED : String = "stateChanged";
    
    public function new(type : String)
    {
        super(type, false, false);
    }
}


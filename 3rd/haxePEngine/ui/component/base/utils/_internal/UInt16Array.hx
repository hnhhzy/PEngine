package haxePEngine.ui.component.base.utils._internal;

#if lime
typedef UInt16Array = lime.utils.UInt16Array;
#elseif js
typedef UInt16Array = js.lib.UInt16Array;
#else
typedef UInt16Array = Dynamic;
#end
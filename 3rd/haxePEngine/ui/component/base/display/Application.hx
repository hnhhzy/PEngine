package haxePEngine.ui.component.base.display;

// 待补 改为hxd.App
import haxePEngine.ui.component.base.utils._internal.Lib;
#if lime
import lime.app.Application as LimeApplication;
import lime.ui.WindowAttributes;
#end

/**
	The Application class is a Lime Application instance that uses
	OpenFL Window by default when a new window is created.
**/

@:access(haxePEngine.ui.component.base.display.DisplayObject)
@:access(haxePEngine.ui.component.base.display.LoaderInfo)
@:access(haxePEngine.ui.component.base.display.Window)
@SuppressWarnings("checkstyle:FieldDocComment")
class Application #if lime extends LimeApplication #end
{
	#if !lime
	public static var current:Application;

	public var window:Window;
	#end

	public function new()
	{
		#if lime
		super();
		#end

		if (Lib.application == null)
		{
			Lib.application = this;
		}

		#if (!flash && !macro)
		if (Lib.current == null) Lib.current = new MovieClip();
		Lib.current.__loaderInfo = LoaderInfo.create(null);
		Lib.current.__loaderInfo.content = Lib.current;
		#end
	}

	#if lime
	public override function createWindow(attributes:WindowAttributes):Window
	{
		var window = new Window(this, attributes);

		__windows.push(window);
		__windowByID.set(window.id, window);

		window.onClose.add(__onWindowClose.bind(window), false, -10000);

		if (__window == null)
		{
			__window = window;

			window.onActivate.add(onWindowActivate);
			window.onRenderContextLost.add(onRenderContextLost);
			window.onRenderContextRestored.add(onRenderContextRestored);
			window.onDeactivate.add(onWindowDeactivate);
			window.onDropFile.add(onWindowDropFile);
			window.onEnter.add(onWindowEnter);
			window.onExpose.add(onWindowExpose);
			window.onFocusIn.add(onWindowFocusIn);
			window.onFocusOut.add(onWindowFocusOut);
			window.onFullscreen.add(onWindowFullscreen);
			window.onKeyDown.add(onKeyDown);
			window.onKeyUp.add(onKeyUp);
			window.onLeave.add(onWindowLeave);
			window.onMinimize.add(onWindowMinimize);
			window.onMouseDown.add(onMouseDown);
			window.onMouseMove.add(onMouseMove);
			window.onMouseMoveRelative.add(onMouseMoveRelative);
			window.onMouseUp.add(onMouseUp);
			window.onMouseWheel.add(onMouseWheel);
			window.onMove.add(onWindowMove);
			window.onRender.add(render);
			window.onResize.add(onWindowResize);
			window.onRestore.add(onWindowRestore);
			window.onTextEdit.add(onTextEdit);
			window.onTextInput.add(onTextInput);

			onWindowCreate();
		}

		onCreateWindow.dispatch(window);

		return window;
	}
	#end
}
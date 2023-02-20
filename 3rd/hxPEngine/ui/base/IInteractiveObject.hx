package hxPEngine.ui.base;

import h2d.Interactive;
import hxPEngine.ui.base.IDisplayObject;

interface IInteractiveObject  extends IDisplayObject {
	public var enableInteractive(default, set):Bool;

	/**
	 * 交互器
	 */
	public var interactive:Interactive;
}
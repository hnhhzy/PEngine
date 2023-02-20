package hxPEngine.ui.data;

/**
 * 按钮皮肤，如果只提供松开纹理时，则会呈现缩放效果
 */
 class ButtonSkin {
	/**
	 * 松开时显示的纹理
	 */
	public var up:Dynamic;

	/**
	 * 按下时显示的纹理
	 */
	public var down:Dynamic;

	/**
	 * 构造一个按钮皮肤，如果只提供松开纹理时，则会呈现缩放效果
	 * @param up 
	 * @param down 
	 */
	public function new(up:Dynamic, ?down:Dynamic) {
		this.up = up;
		this.down = down;
	}
}
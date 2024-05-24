package hxPEngine.ui.util.entity;

class AnimBase extends h2d.Anim {
	var angleList:Array<Float>;
	var curIndex:Int = -1;

	public var degreesList(never, set):Array<Float>;

	private function set_degreesList(?degreesList:Array<Float>):Array<Float> {
		if (curIndex != -1) {
			var r = -angleList[curIndex];
			if (r != 0) {
				this.rotate(r);
			}
		}
		curIndex = -1;
		degreesList = degreesList == null ? [] : degreesList;
		angleList = new Array<Float>();
		for (r in degreesList) {
			var angle = r * Math.PI / 180; // 转换为弧度
			angleList.push(angle);
		}
		return degreesList;
	}

	public function new(?degreesList:Array<Float>, ?frames:Array<h2d.Tile>, speed:Float = 15, ?parent:h2d.Object) {
		angleList = new Array<Float>();
		this.degreesList = degreesList;

		super(frames, speed, parent);
	}

	override function draw(ctx:h2d.RenderContext) {
		var t = getFrame();

		var nowIndex = Std.int(curFrame);

		if (fading) {
			var i = nowIndex + 1;
			if (i >= frames.length) {
				if (!loop)
					return;
				i = 0;
			}
			var t2 = frames[i];
			var old = ctx.globalAlpha;
			var alpha = curFrame - Std.int(curFrame);
			ctx.globalAlpha *= 1 - alpha;
			emitTile(ctx, t);
			ctx.globalAlpha = old * alpha;
			emitTile(ctx, t2);
			ctx.globalAlpha = old;
		} else {
			emitTile(ctx, t);
		}
		if (angleList.length > 0 && frames.length > 0) {
			if (nowIndex != curIndex) {
				if (curIndex == -1) {
					var r = angleList[nowIndex];
					if (r != 0) {
						this.rotate(r);
					}
				} else {
					var r = -angleList[curIndex] + angleList[nowIndex];
					if (r != 0) {
						this.rotate(r);
					}
				}
				curIndex = nowIndex;
			}
		}
	}
}

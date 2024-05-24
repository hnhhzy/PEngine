package haxePEngine.ui.component.base.geom;

class Matrix extends h2d.col.Matrix {
	static var __pool(default, null):Any;

    public var tx(get, set):Float;
    public var ty(get, set):Float;

    private function get_tx():Float {
        return this.x;
    }

    private function set_tx(value:Float):Float {
        if (this.x != value)
        {
            this.x = value;                
        }
        return value;
    }

    private function get_ty():Float {
        return this.y;
    }

    private function set_ty(value:Float):Float {
        if (this.y != value)
        {
            this.y = value;                
        }
        return value;
    }

	public function new(a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, x:Float = 0, y:Float = 0) {
        super();
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
        this.x = x;
        this.y = y;
    }

	function __transformX(arg0:Float, arg1:Float):Float {
		throw new haxe.exceptions.NotImplementedException();
	}

	function __transformY(arg0:Float, arg1:Float):Float {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function transformPoint(point:Point):Point {
		throw new haxe.exceptions.NotImplementedException();
	}

	function __transformInversePoint(global:Point) {}

	function __transformInverseX(arg0:Float, arg1:Float):Float {
		throw new haxe.exceptions.NotImplementedException();
	}

	function __transformInverseY(arg0:Float, arg1:Float):Float {
		throw new haxe.exceptions.NotImplementedException();
	}

	function equals(__renderTransformCache:Matrix):Bool {
        // 待补
        return true;
	}
}
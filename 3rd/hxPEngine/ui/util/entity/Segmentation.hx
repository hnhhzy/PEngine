package hxPEngine.ui.util.entity;

class Segmentation {
	public var src : String;
    public var direction : String;
	public var data : Array<DataImage>;
	public var carousel : Bool;
    public var rate : Float;
	public var defaulaction : Bool;
	public var keys : Array<Int>;
	public var down : Int; 
	public var judge : Int; // 判断是套图 还是一组图 1 为套图 2 为一组图

	public var collision : Int; // 判断是否碰撞 0 关闭 1 边框碰撞 2 矩形碰撞 3 中心点碰撞（加像素）
    public var collisionproperty :Property; // 碰撞属性
    public var mask :Int; // 判断是否遮罩 0 关闭 1 矩形遮罩 2 中心点遮罩
    public var maskproperty :Property; // 遮罩属性
	public var overturn: Int; // 判断是否翻转 0 关闭 1 水平翻转 2 垂直翻转 3 水平垂直翻转
	public var rotate:Array<Float>; // 旋转角度

	public var collisiondata:Array<Property>; // 碰撞数据
	public var maskdata:Array<Property>; // 碰撞数据
	public function new() {
	}
}
package hxPEngine.ui.util.entity;

import h2d.Tile;

class RolejsTile {
	public var carousel : Bool; //是否循环
    public var rate : Float;  //速率
    public var direction : String; //方向
	public var data : Array<Tile>; //数据
    public var defaulaction : Bool; //是否默认动作
    public var keys : Array<Int>; //动作键
    public var down : Int;  //1 松手触发 2 按下触发
    public var collision : Int; // 判断是否碰撞 0 关闭 1 边框碰撞 2 矩形碰撞 3 中心点碰撞（加像素） 4 多边形碰撞
    public var collisionproperty :Property; // 碰撞属性
    public var mask :Int; // 判断是否遮罩 0 关闭  1 矩形遮罩 2 中心点遮罩 3 多边形遮罩
    public var maskproperty :Property; // 遮罩属性
    public var overturn: Int; // 判断是否翻转 0 关闭 1 水平翻转 2 垂直翻转 3 水平垂直翻转
    public var positionX : Int; //偏移量
    public var positionY : Int;

    public var rotate:Array<Float>; // 旋转角度

    public var collisiondata:Array<Property>; // 碰撞数据

    public var maskdata:Array<Property>; // 碰撞数据
	public function new() {
	}
}
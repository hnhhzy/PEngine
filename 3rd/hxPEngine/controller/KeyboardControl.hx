package hxPEngine.controller;
import hxPEngine.ui.util.entity.Keyboard;
import format.abc.Data.ABCData;
import hxd.Event;
import hxd.Key;



class KeyboardControl {

    public  var pressdown:Int = 0;

    private var keyCombos:Map<String, Void->Void>; // 使用哈希表存储按键组合和操作的映射
    private var keyCombosClick:Map<String, Void->Void>; // 使用哈希表存储按键组合和操作的映射




    private function getKeyComboString(keyCombo:Array<Int>):String {
        keyCombo.sort(function(a, b) return a - b); // 按键排序
        return keyCombo.map(function(keyCode) {
            return "KEY_" + String.fromCharCode(keyCode);
        }).join(",");
    }

    public function new() {
        //GamepadControl.addEventTarget(onEvent);


        //trace("键盘控制器初始化");
        hxd.Window.getInstance().addEventTarget(onEvent);

        keyCombos = new Map<String, Void->Void>();
        keyCombosClick = new Map<String, Void->Void>();

        // 添加按键组合和操作的映射
        //keyCombos.set([Key.W, Key.A], combo1Action);
        //keyCombos.set([Key.S, Key.D], combo2Action);
        
        // keyCombos.set(getKeyComboString([Key.W, Key.A]), combo1Action);
        // keyCombos.set(getKeyComboString([Key.S, Key.D]), combo2Action);



    }

    public function setKeyBind(m:Array<Int>,fun:Void->Void) {
        keyCombos.set(getKeyComboString(m), fun);
    }

    public function setKeyBindClick(m:Array<Int>,fun:Void->Void) {
        keyCombosClick.set(getKeyComboString(m), fun);
    }




    private var keyCombos1:Map<String, Void->Void>; // 使用哈希表存储按键组合和操作的映射
    private var keyCombosClick1:Map<String, Void->Void>;
    //清除按键绑定
    public function clearKeyBind() {
       // trace("按键绑定已经清除1"+keyCombos);
        keyCombos1 = new Map<String, Void->Void>();
        keyCombosClick1 = new Map<String, Void->Void>();
        keyCombos1 = keyCombos;
        keyCombosClick1 = keyCombosClick;
       // keyCombos.clear();
        //keyCombosClick.clear();

        keyCombos = new Map<String, Void->Void>();
        keyCombosClick = new Map<String, Void->Void>();
    }

    public function Assignment(){
        keyCombos = keyCombos1;
        keyCombosClick = keyCombosClick1;
       // trace("按键绑定已经清除"+keyCombos1);
    }


    public function getMap():Map<Int,Int>{
        return map;
    }
    public function getPressDown():Int{
        return pressdown;
    }


    var map:Map<Int,Int> = new Map<Int,Int>();
    var keymap:Map<Int,String> = new Map<Int,String>();

    var arr:Array<Int> = new Array<Int>();

    public function getArray():Array<Int>{
        return arr;
    }

    public function setMap(key:Int,keyboard:String):Void{
        keymap.set(key,keyboard);
    }


    
    var pressedKeys:Array<Int> = [];


    private function addkey(key:Int) {
        if(pressedKeys.indexOf(key) == -1){
            pressedKeys.push(key);
        }
    }

    var determine:Int = 0;

    private var isKeyPressed:Bool = false; 

    var keyName:String = "";

    private function onEvent(event:Event):Void {
        

        switch(event.kind) {
            case EKeyDown: {
                //trace("按下键盘1:"+isKeyPressed);
                
                
                addkey(event.keyCode);
                

                var keyComboString:String = getKeyComboString(pressedKeys);

                // trace("按下键盘2:"+keyComboString);
                // trace("按下键盘3:"+keyName);
                // trace("按下键盘4:"+isKeyPressed);
                //trace("按下键盘1:"+keyComboString);
                if (isKeyPressed && keyComboString == keyName) {
                    //trace("按下键盘1:"+keyComboString);
                    return; // 如果按键已经按下，则不执行动作
                }else{
                    //trace("按下键盘2:"+keyComboString);
                }
                // 检查按键组合
                if (keyCombos.exists(keyComboString)) {
                    keyName = keyComboString;
                    var action:Void->Void = keyCombos.get(keyComboString);
                    //trace("3333333333333333333333");
                    action();
                    isKeyPressed = true;
                    //trace("按下键盘1:"+keyComboString);
                    
                }
                //trace("按下键盘2:"+determine);

                return;
            }
            case EKeyUp: {
                
                
                
                
                
                
                var keyComboString:String = getKeyComboString(pressedKeys);
                // 检查按键组合
                if (keyCombosClick.exists(keyComboString)) {
                   
                    var action:Void->Void = keyCombosClick.get(keyComboString);
                    action();
                    //trace("4444444444444444444444");
                }

                //trace('pressed_keys keyCode: ${keyComboString}');
               
                //trace("松开键盘2:"+determine);
                pressedKeys.remove(event.keyCode);
                var keyComboString1:String = getKeyComboString(pressedKeys);
                if(isKeyPressed && !keyCombos.exists(keyComboString1)){
                    RoleJS.Loop();
                    isKeyPressed = false;
                    //trace("11111111111111111111111");
                    
                }

                
                if (keyCombos.exists(keyComboString1)) {
                    keyName = keyComboString;
                    var action:Void->Void = keyCombos.get(keyComboString1);
                    action();
                    //isKeyPressed = true;
                    //trace("22222222222222222222");
                    //isKeyPressed = true;
                    //trace("按下键盘1:"+determine);
                }
                
                //trace("松开键盘1:"+pressedKeys);
                return;
            }
            case EFocusLost: {
                //trace('丢焦点');
                pressedKeys = [];
            }
            case ECheck:{
                trace("检查键盘");
                
            }
            case _:
        }

        //var key = getKeyValue(pressed_keys); // 通过keyCode值获取对应的按键枚举值
        //trace('pressed_keys keyCode: ${key}');

        //trace('pressed_keys keyCode: ${pressed_keys}');




        // // 处理事件的代码
        // switch(event.kind) {
        //     case EKeyDown: {      
        //         pressdown = 1;          
        //         map[event.keyCode] = 1;
        //         arr.push(event.keyCode);

        //         // if(setmap[event.keyCode]["status"] == 1)
        //         // {
        //         //     setmap[event.keyCode]["dirt"]   // 方向

        //         // }

        //         //keymap.get(event.keyCode).


        //        // trace('DOWN keyCode: ${event.keyCode}, charCode: ${event.charCode}');
        //        if( event.keyCode & (Key.W | Key.A) != 0 ) {
        //             trace('按下WA');
        //        }



        //         switch(event.keyCode) {
        //             case Key.W: {
        //                 if(map[Key.A] == 1) {
        //                     //trace("往左上走动画");
                          

        //                     //RoleJS.PlayAnimation("pao","8");
                            
        //                 } else if(map[Key.D] == 1) {
        //                     //trace("往右上走动画");
        //                    // RoleJS.PlayAnimation("pao","2");
        //                 } else {
        //                     //RoleJS.PlayAnimation("pao","1");
        //                     //trace("往上走动画");
        //                     //anim.x = anim.x+5;
        //                     //trace(anim.x);
        //                     // var ss = arrTile1.get("tiao4");

        //                     // if(anim == null){
        //                     //     anim = new h2d.Anim(null,s2d);
        //                     //     anim.play(ss, 0.1);
        //                     //     anim.x = 200;
                                
        //                     // }else{
        //                     //     anim.play(ss, 0.1);
        //                     //     anim.x = 200;
        //                     // }
        //                     //anim = new h2d.Anim(null,s2d);
        //                     // anim.play(ss, 0.1);
        //                     // anim.x = 200;
        //                 }
        //             }
        //             case Key.S: {
        //                 if(map[Key.A] == 1) {
        //                     //RoleJS.PlayAnimation("pao","6");
        //                     //trace("往左下走动画");
        //                 } else if(map[Key.D] == 1) {
        //                     //RoleJS.PlayAnimation("pao","4");
        //                     //trace("往右下走动画");
        //                 } else {
        //                     //RoleJS.PlayAnimation("pao","5");
        //                    // trace("往下走动画");
        //                 }
        //             }
        //             case Key.A: {
        //                 if(map[Key.W] == 1) {
        //                     //RoleJS.PlayAnimation("pao","8");
        //                     //trace("往左上走动画");
        //                 } else if(map[Key.S] == 1) {
        //                     //RoleJS.PlayAnimation("pao","6");
        //                     //trace("往左下走动画");
        //                 } else {
        //                     //RoleJS.PlayAnimation("pao","7");
        //                     //trace("往左走动画");
        //                 }
        //             }
        //             case Key.D: {
        //                 if(map[Key.W] == 1) {
        //                     //RoleJS.PlayAnimation("pao","2");
        //                     //trace("往右上走动画");
        //                 } else if(map[Key.S] == 1) {
        //                     //RoleJS.PlayAnimation("pao","4");
        //                     //trace("往右下走动画");
        //                 } else {
        //                    // RoleJS.PlayAnimation("pao","3");
        //                     //trace("往右走动画");
        //                 }
        //             }
        //             default: {
        //                 trace('DOWN keyCode: ${event.keyCode}, charCode: ${event.charCode}');
        //             }
        //         }
        //     }
        //     case EKeyUp: {
        //             //map[event.keyCode] = 0;
        //             map.remove(event.keyCode);
        //             arr.remove(event.keyCode);
        //             pressdown = 0;
        //             trace('UP keyCode: ${event.keyCode}, charCode: ${event.charCode}');
        //         }
        //     case _:
        // }
    }


    
    
    
}
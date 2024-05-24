package module;


import levels.SnowLevel;
//import ui.control.*;

class MainHX extends hxd.App {
    //private var m_mainPanel:MainPanel;
    //private var m_battleScene:BattleLevel;
    private var m_snowScene:SnowLevel;

    override function update(dt : Float) {
        #if hl
        //haxePEngine.utils.hl.Thread.loop( );
        hxPEngine.ui.util.hl.Thread.loop( );
        #end
        //m_battleScene.update(dt);
        m_snowScene.update(dt);
     }

    override function onResize() {
        var stage = hxd.Window.getInstance();
        trace('Resized to ${stage.width}px * ${stage.height}px');
    }

    override function init() {
        super.init();
    
        hxd.Res.initLocal();

        //m_battleScene = new BattleLevel(s2d);
        m_snowScene = new SnowLevel(s2d);



        // var assets = new Assets(); 
        // assets.loadFile("res/ui/View.pui");
        // assets.start(onAssetsLoaded);
    }

    // function onAssetsLoaded(f:Float) {
    //     if (f == 1) {
    //         trace("assets loaded");
	// 		UIConfig.defaultFont="Tahoma";
            
	// 		UIConfig.defaultScrollBounceEffect=false;
	// 		UIConfig.defaultScrollTouchEffect=false;
	// 		UIConfig.buttonUseHandCursor = true;

    //         ui.view.ViewBinder.bindAll();
    //         m_mainPanel = new MainPanel(s2d);
    //     }
    // }

    static function main() {
        new MainHX();
    }
}
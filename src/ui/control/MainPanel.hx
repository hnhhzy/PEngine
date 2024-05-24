package ui.control;

import hxd.System;
import ui.view.*;
import haxePEngine.ui.utils.*;
import haxePEngine.ui.component.*;

class MainPanel {
    private var _view:UI_Login;

    public function new(?parent:h2d.Object) {
        _view = UI_Login.createInstance(parent);
        _view.move_window_center();
        // _view.x = System.width/2-_view.width/2;
        // _view.y = System.height/2-_view.height/2;
    }
}
package haxePEngine.ui.base.tree;

import haxePEngine.ui.base.tree.TreeNode;

import haxePEngine.ui.component.GComponent;
import haxePEngine.ui.base.event.ItemEvent;

interface ITreeListener
{

    function treeNodeCreateCell(node : TreeNode) : GComponent;
    function treeNodeRender(node : TreeNode, obj : GComponent) : Void;
    function treeNodeWillExpand(node : TreeNode, expand : Bool) : Void;
    function treeNodeClick(node : TreeNode, evt : ItemEvent) : Void;
}

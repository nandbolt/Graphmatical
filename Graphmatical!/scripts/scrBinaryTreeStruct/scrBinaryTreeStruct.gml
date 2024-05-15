/// @func	BinaryTree();
function BinaryTree() constructor
{
	// Init tree
	root = noone;
	
	/// @func	destroyTree({BinaryTreeNode} node);
	static destroyTree = function(_node)
	{
		// If node exists
		if (_node)
		{
			// Left tree
			destroyTree(_node.children[0]);
			
			// Right tree
			destroyTree(_node.children[1]);
			
			// Self
			show_debug_message("Node " + string(_node) + " destroyed.");
			_node.cleanup();
			delete _node;
		}
	}
	
	/// @func	printTree({BinaryTreeNode} node);
	static printTree = function(_node)
	{
		// If node exists
		if (_node)
		{
			// Use recursion to print tree nodes
			printTree(_node.children[0]);
			show_debug_message(string(_node));
			printTree(_node.children[1]);
		}
	}
}
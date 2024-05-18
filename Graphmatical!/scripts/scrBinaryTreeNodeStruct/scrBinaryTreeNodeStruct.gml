/// @func	BinaryTreeNode(data, leftChild, rightChild);
/// @arg	{Any}					data
/// @arg	{Struct.BinaryTreeNode}	leftChild
/// @arg	{Struct.BinaryTreeNode}	rightChild
function BinaryTreeNode(_data=undefined, _leftChild=noone, _rightChild=noone) constructor
{
	// Init node
	data = _data;
	children = [_leftChild, _rightChild];
	
	/// @func	cleanup();
	static cleanup = function()
	{
		children = -1;
	}
	
	/// @func	toString();
	static toString = function()
	{
		// Get data
		var _nodeString = "[Data: " + string(data);
		
		// Get child data
		if (children[0] != noone) _nodeString += ", LChild Data: " + string(children[0].data);
		if (children[1] != noone) _nodeString += ", RChild Data: " + string(children[1].data);
		
		// Return string
		return _nodeString + "]";
	}
}
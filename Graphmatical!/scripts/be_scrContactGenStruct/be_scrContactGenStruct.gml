/// @func	BEContactGen();
/// @desc	A contact generator which adds a contact that applies to given boxes. This is an interface,
///			meaning only inherited contact generators will be instanced (not this base class).
function BEContactGen() constructor
{
	boxes = be_oBoxEngine.boxes;
	contacts = be_oBoxEngine.contacts;
	
	/// @func	addContact({int} contactIdx, {int} limit);
	/// @param	{int}	contact		The contact to add.
	///	@param	{int}	limit		The max number of contacts in the array that can be written to.
	/// @return	{int}				The number of contacts that have been written.
	/// @desc	Fills the contact structure with a generated contact.
	static addContact = function(_contactIdx, _limit){ return 0; }
}
// Equations
for (var _i = 0; _i < array_length(equations); _i++)
{
	if (is_struct(equations[_i]))
	{
		equations[_i].cleanup();
		delete equations[_i];
	}
}
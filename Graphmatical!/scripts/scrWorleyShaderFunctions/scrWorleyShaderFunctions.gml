/// @func	layerWorleyShaderStart();
function layerWorleyShaderStart()
{
	if (event_type == ev_draw)
	{
		if (event_number == 0)
		{
			// Set shader
			shader_set(shdrWorleyNoise);
		}
	}
}

/// @func	layerWorleyShaderEnd();
function layerWorleyShaderEnd()
{
	if (event_type == ev_draw)
	{
		if (event_number == 0)
		{
			// Reset shader
			shader_reset();
		}
	}
}
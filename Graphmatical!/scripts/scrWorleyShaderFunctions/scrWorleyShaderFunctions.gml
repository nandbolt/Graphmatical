/// @func	layerWorleyShaderStart();
function layerWorleyShaderStart()
{
	if (event_type == ev_draw)
	{
		if (event_number == 0)
		{
			// Set shader
			shader_set(shdrWorleyNoise);
			shader_set_uniform_f(oWorld.uTime, current_time * 0.0001);
			shader_set_uniform_f(oWorld.uResolution, 1920.0 * 0.25, 1080.0 * 0.25);
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
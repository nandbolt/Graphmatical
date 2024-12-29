/// @func	layerWorleyShaderStart();
function layerWorleyShaderStart()
{
	if (event_type == ev_draw)
	{
		if (event_number == 0)
		{
			// Set shader
			shader_set(shdrWorleyNoise);
			shader_set_uniform_f(oLevel.uTime, current_time * 0.0001);
			shader_set_uniform_f(oLevel.uResolution, 1920.0 * 0.5, 1080.0 * 0.5);
			shader_set_uniform_f(oLevel.uOffset, camera_get_view_x(view_camera[0]) * 0.5, camera_get_view_y(view_camera[0]) * 0.25);
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
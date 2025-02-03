//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_colorOutline;
uniform float u_texelWidth;
uniform float u_texelHeight;
uniform float u_alphaOutline;

void main()
{
	vec4 texColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	// Neighbor offset
	vec2 offx = vec2(u_texelWidth, 0.);
	vec2 offy = vec2(0., u_texelHeight);
	
	// Keep largest alpha from neighbors + self
	float alpha = texColor.a;
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offx).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offx).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offy).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offy).a);
	
	// Set final color
    gl_FragColor = vec4(texColor.rgb * texColor.a + u_colorOutline * (1. - texColor.a),
		alpha * texColor.a + u_alphaOutline * (1. - texColor.a) * alpha);
}

//
// Worley noise + voronoi with borders fragment shader (based on the cellular noise section in the book of shaders: https://thebookofshaders.com/12/
// as well as https://www.ronja-tutorials.com/post/028-voronoi-noise/)
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_resolution;
uniform float u_time;

vec2 random2(vec2 p)
{
	return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

void main()
{
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
	st.x *= u_resolution.x / u_resolution.y;
	vec3 color = vec3(.0);
	
	// Scale
	st *= 3.;
	
	// Tile the space
	vec2 i_st = floor(st);
	vec2 f_st = fract(st);
	
	// Minimum distance + point
	float minDist = 1.0;
	vec2 minPoint;
	
	// 1st pass (point)
	for (int y = -1; y <= 1; y++)
	{
		for (int x = -1; x <= 1; x++)
		{
			// Neighbor place in grid
			vec2 neighbor = vec2(float(x), float(y));
			
			// Random position from current + neighbor place in grid
			vec2 point = random2(i_st + neighbor);
			
			// Animate the point
			point = 0.5 + 0.25 * sin(u_time + 6.2831 * point);
			
			// Vector between the pixel and the point
			vec2 diff = neighbor + point - f_st;
			
			// Distance to the point
			float dist = length(diff);
			if (dist < minDist)
			{
				// Keep the closer distance
				minDist = dist;
				
				// Keep the position of the closer point
				minPoint = point;
			}
		}
	}
	
	// Color
	color.rgb = mix(vec3(0.2, 0.22, 0.25), vec3(0.7, 0.8, 1.0), minPoint.y * 0.5);
    
	// Final color
	gl_FragColor = vec4(color, 1.0);
}
shader_type canvas_item;
render_mode blend_mix;

// The logic that enables or disables this condition will be located in other parts of the scene--
// This shader is attached to CoQ10 and Cytochrome: The logic is in their TrackingArea2D
uniform bool enable = false;

uniform vec4 glow_color : source_color = vec4(0.0, 0.6, 0.7, 1);

// For these-- Hint_Range is the range between which the variables can be
// And the value after the = is the base set value between the ranges
uniform float intensity : hint_range(0.0, 1.0) = .8;

// Ironically, the bigger the spread value, the more concentrated the glow will be
uniform float spread : hint_range(0.1, 5) = 5; 
uniform float pulse_speed : hint_range(0.0, 5) = 3.0;

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    vec2 centered_uv = UV - vec2(0.5);
    float dist = length(centered_uv) * spread;
    float alpha = max(0.0, 1.0 - dist);

    alpha *= (1.0 + 0.2 * sin(TIME * pulse_speed));
    alpha = clamp(alpha * intensity, 0.0, 1.0);

    vec3 glow = glow_color.rgb * alpha;

	// Logic to enable or disable this shader as-necessary
	if (!enable) { // If-not-enabled, then render normally
		COLOR = COLOR;
	}
    else { // Else-when enabled, add effect 
	// Add glow on top of the base texture
    COLOR.rgb = base.rgb + glow;
	
    // Preserve original transparency to avoid shadow halo
    COLOR.a = base.a;
	}
}

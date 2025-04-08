shader_type canvas_item;

uniform float disintegration_amount : hint_range(0.0, 1.0) = 0.5;
uniform float time = 0.5;
uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform float noise_scale : hint_range(0.0, 10.0) = 3.0;
uniform sampler2D noise_map : filter_nearest;
uniform float smear_amount = 2.0;

void fragment() {
    vec2 uv = UV;
    //uv = TEXTURE_PIXEL_SIZE * round(UV / TEXTURE_PIXEL_SIZE);

    // Get noise value for this pixel
    float noise_value = texture(noise_map, vec2(uv.x,0) * noise_scale).r;

    // Calculate the displacement amount based on time and noise
    float displacement = speed * time;

    // Displace the UV coordinates based on noise and displacement
    vec2 displaced_uv = uv + vec2(0, noise_value * 0.5) * displacement;

    // Clamp the UV coordinates to ensure they stay within the texture bounds
    displaced_uv = clamp(displaced_uv, 0.0, 1.0);

    // Sample the texture based on the disintegration amount
    float disintegration = smoothstep(0.0, 1.0, noise_value * time * disintegration_amount);

    // Sample the texture
    vec4 base_color = texture(TEXTURE, displaced_uv);

    // Calculate the color to mix in from above
    vec2 smear_offset = vec2(0.0, smear_amount); // Adjust based on pixel size
    vec4 smear_color = texture(TEXTURE, displaced_uv - smear_offset);
    if(displaced_uv.y >= 1.0 || displaced_uv.y <= 0.0){
        smear_color = vec4(0.0);
        base_color = vec4(0.0);
    }
    if(displaced_uv.y - smear_offset.y >= 1.0 || displaced_uv.y - smear_offset.y <= 0.0){
        smear_color = vec4(0.0);
    }



   // Mix the base color and the smear color
    COLOR = mix(mix(smear_color,base_color,base_color.a), smear_color, disintegration);
}

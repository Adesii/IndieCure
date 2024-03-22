shader_type canvas_item;


uniform int OCTAVE = 12;
uniform int pixelSize = 4;
uniform float tiling = 1;
uniform sampler2D texts: filter_nearest, repeat_enable;

uniform float Time_Offset = 0.0;
uniform float minimum_offset = 0.0;


varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX,0.0,1.0)).xy;
}

void fragment() {

// Calculate the offset for the texture sampling
vec2 offset = world_pos + vec2(0.5, 0.5);
offset.x += Time_Offset;

// Calculate the tiling factor
float tilingFactor =  tiling / 128.0;

// Compose the tiling factor into a vector
vec2 tilingVector = vec2(tilingFactor, tilingFactor);

// Apply the offset and tiling to the texture coordinates
vec2 textureCoords = offset * tilingVector;

vec2 pixelsize = vec2(float(pixelSize), float(pixelSize));

vec2 pixelcords = round(textureCoords*pixelsize)/pixelsize;


// Sample the texture using the modified texture coordinates
vec4 sampledColor = texture(texts, pixelcords);
float timed_offset =  (sin(Time_Offset*0.001)*0.1) + minimum_offset;

// Round the color values
vec4 roundedColor = round(sampledColor+timed_offset);

// Set the output alpha value to the rounded color's red channel
COLOR.a = roundedColor.x;



}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

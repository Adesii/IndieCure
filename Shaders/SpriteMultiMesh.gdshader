shader_type canvas_item;

instance uniform bool fliph = false;
instance uniform int framecount = 4;
instance uniform int frame = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	if (!fliph) {
		uv.x = 1.0 - uv.x;
	}
	uv.x = uv.x / float(framecount); // Assuming frames are evenly distributed across the texture
	uv.x += float(frame) / float(framecount);


	uv.y = 1.0 - uv.y;
	
	COLOR = texture(TEXTURE, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

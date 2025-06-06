#ifdef GL_ES
precision mediump float;
#endif

extern vec2 pixel_size;
extern vec2 screen_size;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
    return transform_projection * vertex_position;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 pixelated_coords = floor(screen_coords / pixel_size) * pixel_size;
    vec2 tex_coords = pixelated_coords / screen_size;
    return Texel(tex, tex_coords) * color;
}

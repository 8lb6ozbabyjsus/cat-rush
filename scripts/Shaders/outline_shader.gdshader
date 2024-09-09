shader_type canvas_item;
render_mode unshaded;

// Outline shader uniforms
uniform bool Smooth = true;
uniform bool outline_on = true;
uniform float outline_width : hint_range(0.0, 64) = 1.0;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int pixel_size : hint_range(1, 10) = 4;
uniform float width_speed : hint_range(0.1, 10) = 1;

// Rainbow shader uniforms
uniform vec4 first_color = vec4(0.972, 0.451, 0.125, 1.0);
uniform vec4 second_color = vec4(0.510, 0.392, 0.745, 1.0);
uniform vec4 third_color = vec4(0.400, 0.220, 0.761, 1.0);
uniform vec4 fourth_color = vec4(0.086, 0.557, 0.710, 1.0);
uniform float position = 7.0;
uniform float size = 0.5;
uniform float angle = 0.5;
uniform float time_scale = 3.0;

// Combined shader uniform
uniform bool use_rainbow = true;

void fragment() {
    vec4 pixel_color = texture(TEXTURE, UV);
    
    // Outline shader logic
    if (outline_on) {
        float _width = outline_width + ((sin(TIME * width_speed) + 1.0) - 2.0) * 10.0;
        vec2 unit = (1.0 / float(pixel_size)) / vec2(textureSize(TEXTURE, 0));
        
        if (pixel_color.a == 0.0) {
            pixel_color = outline_color;
            pixel_color.a = 0.0;
            for (float x = -ceil(_width); x <= ceil(_width); x++) {
                for (float y = -ceil(_width); y <= ceil(_width); y++) {
                    if (texture(TEXTURE, UV + vec2(x * unit.x, y * unit.y)).a == 0.0 || (x == 0.0 && y == 0.0)) {
                        continue;
                    }
                    if (Smooth) {
                        pixel_color.a += outline_color.a / (pow(x, 2) + pow(y, 2)) * (1.0 - pow(2.0, -_width));
                        if (pixel_color.a > 1.0) {
                            pixel_color.a = 1.0;
                        }
                    } else {
                        pixel_color.a = outline_color.a;
                    }
                }
            }
        }
    }
    
    // Rainbow shader logic
    if (use_rainbow && pixel_color.a > 0.0) {
        float time = TIME * time_scale;
        float pivot = position + 0.75;
        vec2 uv = UV - pivot;
        float rotated = uv.x * cos(radians(angle)) - uv.y * sin(radians(angle));

        float t = mod(time, 4.0);
        vec4 color_a, color_b;

        if (t < 1.0) {
            color_a = first_color;
            color_b = second_color;
        } else if (t < 2.0) {
            color_a = second_color;
            color_b = third_color;
        } else if (t < 3.0) {
            color_a = third_color;
            color_b = fourth_color;
        } else {
            color_a = fourth_color;
            color_b = first_color;
        }

        vec4 gradient_color = mix(color_a, color_b, fract(t));
        float pos = smoothstep((1.0 - size) + position, size + 0.0001 + position, rotated + pivot);
        vec4 rainbow_color = mix(gradient_color, second_color, pos);
        
        pixel_color.rgb = rainbow_color.rgb;
    }

    COLOR = pixel_color;
}
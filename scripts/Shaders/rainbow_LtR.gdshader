shader_type canvas_item;

uniform vec4 first_color = vec4(0.972, 0.451, 0.125, 1.0);  // Color 1: #F87320
uniform vec4 second_color = vec4(0.510, 0.392, 0.745, 1.0); // Color 2: #8264BE
uniform vec4 third_color = vec4(0.400, 0.220, 0.761, 1.0);  // Color 3: #6638C2
uniform vec4 fourth_color = vec4(0.086, 0.557, 0.710, 1.0); // Color 4: #168EB5

uniform float position = 7.0;
uniform float size = 0.5;
uniform float angle = 0.5;
uniform float time_scale = 3.0;

void fragment() {
    // Calculate the gradient color
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
    vec4 final_color = mix(gradient_color, second_color, pos);

    // Sample the texture color at the current UV
    vec4 original_color = texture(TEXTURE, UV);

    // Preserve the alpha channel of the original text, and apply the gradient color
    COLOR = vec4(final_color.rgb, original_color.a) * original_color.a;

    // Force the last character to update properly
    if (original_color.a == 0.0) {
        discard;
    }
}

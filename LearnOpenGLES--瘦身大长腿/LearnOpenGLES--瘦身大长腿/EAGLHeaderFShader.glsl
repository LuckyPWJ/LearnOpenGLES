
#version 300 es

precision mediump float;
in vec2 f_texture;
out vec4 out_color;
uniform sampler2D texture0;

void main()
{
    out_color = texture(texture0,f_texture);
}

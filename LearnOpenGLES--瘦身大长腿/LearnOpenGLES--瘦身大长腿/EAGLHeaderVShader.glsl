
#version 300 es

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec2 a_texture;

out vec2 f_texture;

uniform mat4 roateMartix;

void main()
{
    gl_Position = vec4(a_pos,1.0f);
    f_texture   = a_texture;
}

#version 300 es

layout(location = 0) in vec2 a_pos;
layout(location = 1) in vec2 a_textoods;

out vec2 a_fragTexToods;

void main(){
    gl_Position = vec4(a_pos.x,a_pos.y,0.0f,1.0f);
    a_fragTexToods = a_textoods;
}

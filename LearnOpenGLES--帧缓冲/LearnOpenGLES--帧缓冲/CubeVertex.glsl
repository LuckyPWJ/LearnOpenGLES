#version 300 es

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec2 a_textoods;

out vec2 a_fragTexToods;

uniform mat4 projection;
uniform mat4 model;
uniform mat4 view;

void main(){
    gl_Position = projection * view * model * vec4(a_pos,1.0f);
    
    a_fragTexToods = a_textoods;
}

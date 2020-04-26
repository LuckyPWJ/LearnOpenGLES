
#version 300 es

layout(location = 0) in vec4 a_pos;
layout(location = 1) in vec2 a_texCoord;

out vec2 frag_textoord;

void main(){
    gl_Position = a_pos;
    frag_textoord = a_texCoord;
}

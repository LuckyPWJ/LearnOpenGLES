#version 300 es

layout(location = 0) in vec3 apos;
layout(location = 1) in vec2 aTexture;

out vec2 outTexture;

void main(){
    gl_Position = vec4(apos ,1.0f);
    outTexture  = aTexture;
}

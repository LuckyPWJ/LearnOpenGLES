
#version 300 es

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec3 a_color;
layout(location = 2) in vec2 a_texture;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

out vec3 a_fragColor;
out vec2 a_fragTexture;

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(a_pos,1.0f);
    a_fragColor = a_color;
    a_fragTexture = a_texture;
}

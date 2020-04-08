
#version 300 es

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec3 a_color;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

out vec3 a_fragColor;

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(a_pos,1.0f);
    a_fragColor = a_color;
}

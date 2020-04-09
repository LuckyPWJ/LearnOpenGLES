#version 300 es

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec3 a_normal;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 a_fragPos;
out vec3 a_fragNormal;

void main(){
    a_fragPos   = vec3(model * vec4(a_pos,1.0));
    gl_Position = projection * view * vec4(a_fragPos,1.0f);
    a_fragNormal = a_normal;
   
}

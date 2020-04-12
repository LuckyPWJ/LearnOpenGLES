
#version 300 es

layout(location = 0) in vec3 a_pos;
layout(location = 1) in vec3 a_normal;

out vec3 a_fragNormal;
out vec3 a_fragPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main(){
    a_fragPos = vec3(model * vec4(a_pos,1.0f));
    gl_Position = projection * view * model * vec4(a_pos,1.0f);
    a_fragNormal = a_normal;
}

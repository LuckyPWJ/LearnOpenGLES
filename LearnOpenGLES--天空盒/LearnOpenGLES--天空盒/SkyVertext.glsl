
#version 300 es

layout(location = 0) in vec3 a_pos;

out vec3 TexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;


void main(){
    TexCoords = a_pos;
    gl_Position = projection * view * vec4(a_pos,1.0f);
}


#version 300 es

precision mediump float;

in vec3 TexCoords;

out vec4 fragColor;

uniform samplerCube skybox;

void main(){
    fragColor = texture(skybox, TexCoords);
}

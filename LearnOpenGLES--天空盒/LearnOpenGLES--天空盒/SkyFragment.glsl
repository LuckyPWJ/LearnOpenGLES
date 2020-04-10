
#version 300 es

precision mediump float;

in vec3 TexCoords;

out vec4 fragColor;

uniform samplerCube skybox;

void main(){
    fragColor = texture(skybox, TexCoords);
//    fragColor = vec4(1.0f,0.0f,0.0f,1.0f);
}

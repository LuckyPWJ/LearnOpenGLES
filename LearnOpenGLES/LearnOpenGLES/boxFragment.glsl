#version 300 es

in mediump vec2 outTexture;
out mediump vec4 outFragColor;

uniform sampler2D texture0;

void main(){
    outFragColor = texture(texture0,outTexture);
}

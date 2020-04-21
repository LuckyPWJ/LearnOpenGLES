
#version 300 es

precision mediump float;

in vec2 a_fragTexToods;

out vec4 fragColor;

uniform sampler2D texture0;

void main(){
    fragColor = texture(texture0, a_fragTexToods);
}



#version 300 es

precision mediump float;

in vec2 a_fragTexcoord;

out vec4 fragColor;
uniform sampler2D ourTexture;

void main(){
    fragColor = texture(ourTexture,a_fragTexcoord);
//    fragColor = vec4(1.0f,0.6f,0.4f,1.0f);
}

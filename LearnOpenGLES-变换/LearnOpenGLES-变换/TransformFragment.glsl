
#version 300 es

precision mediump float;

in  vec3 a_fragColor;
in  vec2 a_fragTexture;
out vec4 out_fragColor;
uniform sampler2D texture0;

void main(){
    out_fragColor = texture(texture0,a_fragTexture) * vec4(a_fragColor,1.0f);
}

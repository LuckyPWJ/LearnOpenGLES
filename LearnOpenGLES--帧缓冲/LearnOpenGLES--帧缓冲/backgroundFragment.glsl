#version 300 es

precision mediump float;

in vec2 a_fragTexToods;

out vec4 fragColor;

uniform sampler2D texture1;

void main(){
    //原始效果
//    fragColor = texture(texture1, a_fragTexToods);
    //反相
    fragColor = vec4(vec3(1.0 - texture(texture1, a_fragTexToods)), 1.0f);

    
}

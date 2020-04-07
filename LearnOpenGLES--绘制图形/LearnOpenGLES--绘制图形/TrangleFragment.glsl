
#version 300 es

in  mediump vec3 fragColor;

out mediump vec4 outFragColor;

void main(){
    outFragColor = vec4(fragColor,1.0f);
}

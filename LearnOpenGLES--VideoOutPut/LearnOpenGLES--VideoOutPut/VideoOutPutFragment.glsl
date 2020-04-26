
#version 300 es

precision mediump float;

in vec2 frag_textoord;

out vec4 fragColor;

uniform sampler2D SamplerY;
uniform sampler2D SamplerUV;
uniform mat3 colorConversionMatrix;

void main(){
    mediump vec3 yuv;
    lowp vec3 rgb;
    //yuv 转 rgb
    yuv.x = (texture(SamplerY, frag_textoord).r - (16.0/255.0));
    yuv.yz = (texture(SamplerUV, frag_textoord).ra - vec2(0.5, 0.5));
    rgb = colorConversionMatrix * yuv;

    fragColor = vec4(rgb,1);
}

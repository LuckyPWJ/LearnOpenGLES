
#version 300 es
precision mediump float;
in vec2 v_texCoord;
out vec4 outColor;
uniform sampler2D s_TextureMap;

void main()
{
    outColor = texture(s_TextureMap, v_texCoord);
}   



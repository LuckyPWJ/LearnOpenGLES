
#version 300 es

precision mediump float;

in vec3 a_fragNormal;
in vec3 a_fragPos;
out vec4 fragColor;

uniform vec3 lightPos;
uniform vec3 objectColor;


void main(){
   //环境光
    vec3 ambientColor = vec3( 0.6f, 0.6f,0.6f);
    vec3 diffuserColor = vec3(1.0f,1.0f,1.0f);

    vec3 normal = normalize(a_fragNormal);
    vec3 lightDir = normalize(lightPos - a_fragPos);
    float diff = max(dot(lightDir,normal),0.0f);

    fragColor = vec4((ambientColor + diffuserColor * diff) * objectColor,1.0f);
}

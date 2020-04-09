
#version 300 es

precision mediump float;

in vec3 a_fragPos;
in vec3 a_fragNormal;

uniform vec3 lightColor;
uniform vec3 objectColor;
uniform vec3 lightPos;
uniform vec3 viewPos;
uniform mat3 transposeNormal;

out vec4 fragColor;

void main(){
    
    vec3 normal = normalize(a_fragNormal * transposeNormal);
    //环境光
    float abmientStrength = 0.1;
    vec3 ambientColor = abmientStrength * lightColor;
    
    //漫反射光
    //先计算光源的向量，
    vec3 lightDir = normalize(lightPos - a_fragPos);
    //计算光源向量和法线向量的点积，计算光源对当前片段实际的漫反射影响
    float diffuse = max(dot(normal,lightDir),0.0f);
    vec3 diffuseColor = diffuse * lightColor;

    //镜面反射光
    float specualStrength = 0.5f;
    //计算观察者到正方体向量
    vec3 viewDir = normalize(viewPos - a_fragPos);
    //计算反射镜面光和法线向量的点积
    vec3 reflectDir = reflect(-lightDir,normal);
    float spec = pow(max(dot(viewDir,reflectDir),0.0),32.0);
    vec3 specualColor = specualStrength * spec * lightColor;

    fragColor = vec4((ambientColor + diffuseColor + specualColor) * objectColor,1.0f);
    
}

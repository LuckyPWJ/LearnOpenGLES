//
//  PJLinkHelper.m
//  LearnOpenGLES
//
//  Created by LuckyPan on 2020/4/7.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "PJLinkHelper.h"

@implementation PJLinkHelper

+(GLuint)loadWithShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    if (!filePath) {
        return 0;
    }
    NSError * error;
    NSString * shaderString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    //创建着色器编译器
    GLuint shader = glCreateShader(shaderType);
    //加载着色器语言
    const char * shaderUTF8String = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderUTF8String, NULL);
    //编译着色器
    glCompileShader(shader);
    //查询编译状态
    GLint complied;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &complied);
    if (!complied) {
        GLint len;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &len);
        if (len > 0) {
            char * infoLog = malloc(sizeof(char) * len);
            glGetShaderInfoLog(shader, len, NULL, infoLog);
            NSLog(@"%@ shader load info = %s",shaderName,infoLog);
            free(infoLog);
            return 0;
        }
    }
    return shader;
}

+(GLuint)loadWithVShader:(GLuint )vShader fShader:(GLuint)fShader
{
    GLuint program = glCreateProgram();
    
    glAttachShader(program, vShader);
    glAttachShader(program, fShader);

    glLinkProgram(program);
    
    GLint linked;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    if (!linked) {
        GLint infoLen;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 0) {
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(program, infoLen, NULL, infoLog);
            NSLog(@"link program error = %s",infoLog);
            return 0;
        }
    }
    glDeleteShader(vShader);
    glDeleteShader(fShader);
    return program;
}
@end

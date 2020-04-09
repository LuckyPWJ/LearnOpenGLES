//
//  ViewController.m
//  LearnOpenGLES--光照
//
//  Created by LuckyPan on 2020/4/9.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import "PJLinkHelper.h"
#import <GLKit/GLKit.h>
#import "glm.hpp"
#import "matrix_transform.hpp"
#import "type_ptr.hpp"

@interface ViewController ()<GLKViewDelegate>
{
    EAGLContext *_context;
    GLuint _lightProgram;
    GLuint _objectProgram;
    GLuint _instanceVao;
    GLuint _lightVao;
    GLKView *_glkView;
    NSTimer *_timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:_context];
    
    GLKView * view = [[GLKView alloc] initWithFrame:self.view.bounds context:_context];
    view.delegate  = self;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [self.view addSubview:view];
    _glkView = view;

    GLuint vShader = [PJLinkHelper loadWithShaderName:@"LightVertex" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"LightFragment" shaderType:GL_FRAGMENT_SHADER];
    _lightProgram  = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    
    GLuint vShader1 = [PJLinkHelper loadWithShaderName:@"ObjectVertex" shaderType:GL_VERTEX_SHADER];
    GLuint fShader1 = [PJLinkHelper loadWithShaderName:@"ObjectFragment" shaderType:GL_FRAGMENT_SHADER];
    _objectProgram  = [PJLinkHelper loadWithVShader:vShader1 fShader:fShader1];
    
    [self initData];
    
   _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];

}

-(void)timeAction
{
    [_glkView setNeedsDisplay];
}

-(void)initData
{
    glEnable(GL_DEPTH_TEST);

    GLfloat vertexs[] = {
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
        
        -0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f,  0.0f,  1.0f,
        
        -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
        -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
        
        0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
        0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
        0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
        0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
        0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
        0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
        
        -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
        0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
        0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
        0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
        
        -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f
    };
    
    GLuint instanceVao,instanceVbo;
    glGenVertexArrays(1, &instanceVao);
    glBindVertexArray(instanceVao);
    
    glGenBuffers(1, &instanceVbo);
    glBindBuffer(GL_ARRAY_BUFFER, instanceVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void *)0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);
    
    _instanceVao = instanceVao;
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
    GLuint lightVao,lightVbo;
    glGenVertexArrays(1, &lightVao);
    glBindVertexArray(lightVao);
    
    glGenBuffers(1, &lightVbo);
    glBindBuffer(GL_ARRAY_BUFFER, lightVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs),vertexs , GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(0);
    
    _lightVao = lightVao;
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
}

-(void)drawInWidth:(GLuint)width height:(GLuint)height
{
    glViewport(0, 0, width, height);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glUseProgram(_objectProgram);
    glBindVertexArray(_instanceVao);

    float radius = 2.0f;
    float x = radius * sin(CFAbsoluteTimeGetCurrent());
    float z = radius * cos(CFAbsoluteTimeGetCurrent());

    glm::vec3 lightPos = glm::vec3(x, 0.0f,z);
    glm::vec3 cameraPos = glm::vec3(2.0f,2.0f,10.0f);
    glm::mat4 model = glm::mat4(1.0f);
    glm::mat4 view  = glm::mat4(1.0f);
    glm::mat4 projection = glm::mat4(1.0f);
    glm::mat3 transposeNormal = glm::transpose(glm::inverse(model));
    view = glm::lookAt(cameraPos, glm::vec3(0.0f,0.0f,0.0f), glm::vec3(0.0f,1.0f,0.0f));
    projection = glm::perspective(glm::radians(45.0f), (GLfloat)(width)/height, 0.1f, 100.0f);
    glUniformMatrix3fv(glGetUniformLocation(_objectProgram, "transposeNormal"), 1, GL_FALSE, glm::value_ptr(transposeNormal));
    glUniformMatrix4fv(glGetUniformLocation(_objectProgram, "model"), 1, GL_FALSE, glm::value_ptr(model));
    glUniformMatrix4fv(glGetUniformLocation(_objectProgram, "view"), 1, GL_FALSE, glm::value_ptr(view));
    glUniformMatrix4fv(glGetUniformLocation(_objectProgram, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    glUniform3f(glGetUniformLocation(_objectProgram, "objectColor"), 1.0f, 0.5f, 0.3f);
    glUniform3f(glGetUniformLocation(_objectProgram, "lightColor"), 1.0f, 1.0f, 1.0f);
    glUniform3f(glGetUniformLocation(_objectProgram, "lightPos"),lightPos.x,lightPos.y,lightPos.z);
    glUniform3f(glGetUniformLocation(_objectProgram, "viewPos"),cameraPos.x,cameraPos.y,cameraPos.z);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    glUseProgram(_lightProgram);
    glBindVertexArray(_lightVao);
    
    glm::mat4 lightModel = glm::mat4(1.0f);
    lightModel = glm::translate(lightModel,lightPos);
    lightModel = glm::scale(lightModel, glm::vec3(0.2f,0.2f,0.2f));

    glUniformMatrix4fv(glGetUniformLocation(_lightProgram, "model"), 1, GL_FALSE, glm::value_ptr(lightModel));
    glUniformMatrix4fv(glGetUniformLocation(_lightProgram, "view"), 1, GL_FALSE, glm::value_ptr(view));
    glUniformMatrix4fv(glGetUniformLocation(_lightProgram, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self drawInWidth:(int)view.drawableWidth height:(int)view.drawableHeight];
}



@end

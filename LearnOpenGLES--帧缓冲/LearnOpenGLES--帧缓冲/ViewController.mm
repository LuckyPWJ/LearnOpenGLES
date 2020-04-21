//
//  ViewController.m
//  LearnOpenGLES--帧缓冲
//
//  Created by LuckyPan on 2020/4/13.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKView.h>
#import <GLKit/GLKit.h>
#import "PJLinkHelper.h"
#import "PJUtil.h"
#import "glm.hpp"
#import "type_ptr.hpp"
#import "matrix_transform.hpp"

@interface ViewController ()<GLKViewDelegate>
{
    EAGLContext *_context;
    GLuint _program;
    GLuint _cubeProgram;
    GLuint _vao;
    GLuint _cubeVao;
    GLuint _floorVao;
    GLuint _fbo;
    GLint _defaultFbo;
    GLuint _cubeTextureId;
    GLuint _floorTextureId;
    GLuint _fboTextureId;
    GLKView *_glkView;
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
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [self.view addSubview:view];
    _glkView = view;
    
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"backgroundVertex" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"backgroundFragment" shaderType:GL_FRAGMENT_SHADER];
    _program = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    
    GLuint cubeVShader = [PJLinkHelper loadWithShaderName:@"CubeVertex" shaderType:GL_VERTEX_SHADER];
    GLuint cubeFShader = [PJLinkHelper loadWithShaderName:@"CubeFragment" shaderType:GL_FRAGMENT_SHADER];
    _cubeProgram = [PJLinkHelper loadWithVShader:cubeVShader fShader:cubeFShader];
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_defaultFbo);
    
    [self initData];
}

-(void)initData
{
    
    _defaultFbo = 0;
    _fbo        = 0;
    
    GLfloat cubeVertices[] = {
        // positions          // texture Coords
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
        0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,

        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,

        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,

        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
    };
    GLfloat planeVertices[] = {
        // positions          // texture Coords
        5.0f, -0.5f,  5.0f,  2.0f, 0.0f,
        -5.0f, -0.5f,  5.0f,  0.0f, 0.0f,
        -5.0f, -0.5f, -5.0f,  0.0f, 2.0f,

        5.0f, -0.5f,  5.0f,  2.0f, 0.0f,
        -5.0f, -0.5f, -5.0f,  0.0f, 2.0f,
        5.0f, -0.5f, -5.0f,  2.0f, 2.0f
    };
    GLfloat quadVertices[] = {
        // positions   // texCoords
        -0.8f,  0.8f,  0.0f, 1.0f,
        -0.8f, -0.8f,  0.0f, 0.0f,
        0.8f, -0.8f,  1.0f, 0.0f,

        -0.8f,  0.8f,  0.0f, 1.0f,
        0.8f, -0.8f,  1.0f, 0.0f,
        0.8f,  0.8f,  1.0f, 1.0f
    };


    glGenVertexArrays(1, &_cubeVao);
    glBindVertexArray(_cubeVao);
    GLuint cubeVbo;
    glGenBuffers(1, &cubeVbo);
    glBindBuffer(GL_ARRAY_BUFFER, cubeVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertices), cubeVertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);

    glGenVertexArrays(1, &_floorVao);
    glBindVertexArray(_floorVao);
    GLuint floorVbo;
    glGenBuffers(1, &floorVbo);
    glBindBuffer(GL_ARRAY_BUFFER, floorVbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(planeVertices), planeVertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);

    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    GLuint vbo;
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(quadVertices), quadVertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (void *)(2 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);

    GLuint cubeTextureId = [PJUtil getTextureIdFromImage:[UIImage imageNamed:@"container.jpg"]];
    _cubeTextureId = cubeTextureId;
    GLuint floorTextureId = [PJUtil getTextureIdFromImage:[UIImage imageNamed:@"metal"]];
    _floorTextureId = floorTextureId;

    GLfloat width =  self.view.bounds.size.width;
    GLfloat height = self.view.bounds.size.height;
 
    glGenFramebuffers(1, &_fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, _fbo);
    
    glGenTextures(1, &_fboTextureId);
    glBindTexture(GL_TEXTURE_2D, _fboTextureId);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,width,height, 0,GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _fboTextureId, 0);
    glBindTexture(GL_TEXTURE_2D, 0);

    GLuint rbo;
    glGenRenderbuffers(1, &rbo);
    glBindRenderbuffer(GL_RENDERBUFFER, rbo);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, width, height); // use a single renderbuffer object for both a depth AND stencil buffer.
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo);

    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"ERROR::FRAMEBUFFER:: Framebuffer is not complete! = %d",glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }

    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFbo);
    glBindTexture(GL_TEXTURE_2D, 0);
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glViewport(0, 0, (GLuint)view.drawableWidth/2, (GLuint)view.drawableHeight/2);
    glBindFramebuffer(GL_FRAMEBUFFER, _fbo);
//    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);

    glUseProgram(_cubeProgram);
    glm::mat4 model = glm::mat4(1.0f);
    glm::mat4 views = glm::mat4(1.0f);
    glm::mat4 projection = glm::mat4(1.0f);

    views = glm::lookAt(glm::vec3(0.0f,1.0f,3.0f), glm::vec3(0.0f,0.0f,0.0f), glm::vec3(0.0f,1.0f,0.0f));
    projection = glm::perspective(glm::radians(45.f), (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight, 0.1f, 100.0f);
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "model"), 1, GL_FALSE, glm::value_ptr(model));
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "view"), 1, GL_FALSE, glm::value_ptr(views));
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "projection"), 1, GL_FALSE, glm::value_ptr(projection));

    glBindVertexArray(_cubeVao);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _cubeTextureId);
    model = glm::translate(model, glm::vec3(-1.0f, 0.0f, -1.0f));
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "model"), 1, GL_FALSE, glm::value_ptr(model));
    glDrawArrays(GL_TRIANGLES, 0, 36);

    glBindVertexArray(_floorVao);
    glBindTexture(GL_TEXTURE_2D, _floorTextureId);
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "model"), 1, GL_FALSE, glm::value_ptr(glm::mat4(1.0f)));
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArray(0);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFbo);
    //这一行代码是关键
    [_glkView bindDrawable];
    glDisable(GL_DEPTH_TEST);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(_program);
    glBindVertexArray(_vao);
    glBindTexture(GL_TEXTURE_2D, _fboTextureId);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end

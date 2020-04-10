//
//  ViewController.m
//  LearnOpenGLES--天空盒
//
//  Created by LuckyPan on 2020/4/10.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>
#import "PJLinkHelper.h"
#import "glm.hpp"
#import "type_ptr.hpp"
#import "matrix_transform.hpp"
#import "PJUtil.h"

@interface ViewController ()<GLKViewDelegate>
{
    EAGLContext *_context;
    GLuint _skyProgram;
    GLuint _cubeProgram;
    GLuint _vaoId;
    GLuint _cubeVaoId;
    GLuint _textureId;
    GLuint _cuboTextureId;
    CGFloat _degree;
    
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
    
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"SkyVertext" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"SkyFragment" shaderType:GL_FRAGMENT_SHADER];
    
    _skyProgram = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    
    GLuint vShader1 = [PJLinkHelper loadWithShaderName:@"CubeVertex" shaderType:GL_VERTEX_SHADER];
    GLuint fShader1 = [PJLinkHelper loadWithShaderName:@"CubeFragment" shaderType:GL_FRAGMENT_SHADER];
    
    _cubeProgram = [PJLinkHelper loadWithVShader:vShader1 fShader:fShader1];
    
    [self initData];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _degree += 0.05;
        [view setNeedsDisplay];
    }];
}

-(GLuint)loadCubemap:(NSArray *)faces
{
    GLuint textureId;
    glGenTextures(1, &textureId);
    glBindTexture(GL_TEXTURE_CUBE_MAP, textureId);
    
    for (GLuint i = 0; i < faces.count; i ++) {
        UIImage * image = [UIImage imageNamed:faces[i]];
        CGImageRef imageRef = image.CGImage;
        GLuint width        = (GLuint)CGImageGetWidth(imageRef);
        GLuint height       = (GLuint)CGImageGetHeight(imageRef);
        CGRect rect         = CGRectMake(0, 0, width, height);
        
        CGColorSpaceRef colorSpaceRef = CGImageGetColorSpace(imageRef);
        void * imageData = malloc(width * height * 4);
        CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpaceRef, kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipLast);
//        CGContextTranslateCTM(context, 0, height);
//        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGColorSpaceRelease(colorSpaceRef);
        CGContextClearRect(context, rect);
        CGContextDrawImage(context, rect, imageRef);
        CGContextRelease(context);
        GLenum cube = GL_TEXTURE_CUBE_MAP_POSITIVE_X + i;
        glTexImage2D(cube, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
        free(imageData);
    }
    
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    return textureId;
}

-(void)initData
{
    _degree = 0;
//    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
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

    GLfloat skyboxVertices[] = {
        // positions
        
        5.0f, -5.0f, -5.0f,
        5.0f, -5.0f,  5.0f,
        5.0f,  5.0f,  5.0f,
        5.0f,  5.0f,  5.0f,
        5.0f,  5.0f, -5.0f,
        5.0f, -5.0f, -5.0f,  //右
        -5.0f, -5.0f,  5.0f,
        -5.0f, -5.0f, -5.0f,
        -5.0f,  5.0f, -5.0f,
        -5.0f,  5.0f, -5.0f,
        -5.0f,  5.0f,  5.0f,
        -5.0f, -5.0f,  5.0f,  //左
        
        -5.0f,  5.0f, -5.0f,
        5.0f,  5.0f, -5.0f,
        5.0f,  5.0f,  5.0f,
        5.0f,  5.0f,  5.0f,
        -5.0f,  5.0f,  5.0f,
        -5.0f,  5.0f, -5.0f, //上
        
        -5.0f, -5.0f, -5.0f,
        -5.0f, -5.0f,  5.0f,
        5.0f, -5.0f, -5.0f,
        5.0f, -5.0f, -5.0f,
        -5.0f, -5.0f,  5.0f,
        5.0f, -5.0f,  5.0f , //下
        
        -5.0f,  5.0f, -5.0f,
          -5.0f, -5.0f, -5.0f,
          5.0f, -5.0f, -5.0f,
          5.0f, -5.0f, -5.0f,
          5.0f,  5.0f, -5.0f,
          -5.0f,  5.0f, -5.0f,  //后
//
        -5.0f, -5.0f,  5.0f,
         -5.0f,  5.0f,  5.0f,
         5.0f,  5.0f,  5.0f,
         5.0f,  5.0f,  5.0f,
         5.0f, -5.0f,  5.0f,
         -5.0f, -5.0f,  5.0f, //前
        
    };
   
    GLuint cubeVaoId,vboId;
    glGenVertexArrays(1, &cubeVaoId);
    glBindVertexArray(cubeVaoId);
    _cubeVaoId = cubeVaoId;
    
    glGenBuffers(1, &vboId);
    glBindBuffer(GL_ARRAY_BUFFER, vboId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertices), cubeVertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void *)NULL);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);
    glBindVertexArray(0);
    
    UIImage * cubeImage = [UIImage imageNamed:@"marble.jpg"];
    _cuboTextureId = [PJUtil getTextureIdFromImage:cubeImage];
    
    NSArray * faces = @[
        @"right.jpg",
        @"left.jpg",
        @"top.jpg",
        @"bottom.jpg",
        @"back.jpg",
        @"front.jpg"
    ];
    
    _textureId = [self loadCubemap:faces];
    GLuint skyboxVAO, skyboxVBO;
    glGenVertexArrays(1, &skyboxVAO);
    glBindVertexArray(skyboxVAO);
    _vaoId = skyboxVAO;
    glGenBuffers(1, &skyboxVBO);
    glBindBuffer(GL_ARRAY_BUFFER, skyboxVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(skyboxVertices), skyboxVertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (void*)NULL);
    glEnableVertexAttribArray(0);
    glBindVertexArray(0);
    
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glViewport(0, 0, (int)view.drawableWidth, (int)view.drawableHeight);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glUseProgram(_cubeProgram);

    glm::mat4 viewMatrix  = glm::mat4(1.0f);
    glm::mat4 projection = glm::mat4(1.0f);
    glm::mat4 model = glm::mat4(1.0f);
    model = glm::scale(model, glm::vec3(0.5f,0.5f,0.5f));
    float radius = 5.0f;
    float camX = sin(_degree) * radius;
    float camZ = cos(_degree) * radius;
    glm::vec3 cameraPos = glm::vec3(camX,0.0f,camZ);
    viewMatrix = glm::lookAt(cameraPos,glm::vec3(0.0f,0.0f,0.0f), glm::vec3(0.0f,1.0f,0.0f));
    projection = glm::perspective(glm::radians(45.f), (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight, 0.1f, 100.0f);
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "model"), 1, GL_FALSE, glm::value_ptr(model));
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "view"), 1, GL_FALSE, glm::value_ptr(viewMatrix));
    glUniformMatrix4fv(glGetUniformLocation(_cubeProgram, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    
    glBindVertexArray(_cubeVaoId);
//    glUniform1i(glGetUniformLocation(_cubeProgram, "ourTexture"), 0);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _cuboTextureId);
    glDrawArrays(GL_TRIANGLES, 0, 36);
    glBindVertexArray(0);
    
//     glDepthFunc(GL_LEQUAL);
    glUseProgram(_skyProgram);
//    viewMatrix = glm::mat4(glm::mat3(viewMatrix));
    glUniformMatrix4fv(glGetUniformLocation(_skyProgram, "view"), 1, GL_FALSE, glm::value_ptr(viewMatrix));
    glUniformMatrix4fv(glGetUniformLocation(_skyProgram, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    glBindVertexArray(_vaoId);
    glUniform1f(glGetUniformLocation(_skyProgram, "skybox"), 0);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_CUBE_MAP, _textureId);
    glDrawArrays(GL_TRIANGLES, 0, 36);
    glBindVertexArray(0);
//      glDepthFunc(GL_LESS);
}

@end

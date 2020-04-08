//
//  ViewController.m
//  LearnOpenGLES
//
//  Created by LuckyPan on 2020/4/7.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import "PJLinkHelper.h"
#import <GLKit/GLKit.h>

@interface ViewController ()<GLKViewDelegate>{
    EAGLContext *_context;
    GLuint       _program;
    GLuint       _vaoId;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:_context];
    
    GLKView * glkView = [[GLKView alloc] initWithFrame:self.view.bounds context:_context];
    glkView.delegate  = self;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [self.view addSubview:glkView];
    
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"boxVertext" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"boxFragment" shaderType:GL_FRAGMENT_SHADER];
    
    GLuint program = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    _program       = program;
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glViewport(0, 0, (int)view.drawableWidth, (int)view.drawableHeight);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(_program);
    
    GLfloat width = self.view.bounds.size.width;
    GLfloat height = self.view.bounds.size.height;
    GLfloat wScale = 96.0/width * 2.0;
    GLfloat hScale = 96.0/height * 2.0;
    GLfloat fhScale = -hScale;
    
    GLfloat vertexs[] = {
        wScale,hScale,0.0f,   1.0f,1.0f,
        wScale,fhScale,0.0f,  1.0f,0.0f,
        -wScale,hScale,0.0f,  0.0f,1.0f,
        -wScale,fhScale,0.0f, 0.0f,0.0f
    };
    
    GLint indexs[] = {
        0,1,2,
        1,2,3
    };
    
    GLuint vboIds[] = {};
    glGenBuffers(2, vboIds);
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indexs), indexs, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);
    
    UIImage * image  = [UIImage imageNamed:@"木箱"];
    GLuint textureId = [self getTextureId:image];
    
    glUniform1f(glGetUniformLocation(_program, "texture0"), 0);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D,textureId);
    
    GLfloat s = sin(60.0f);
    GLfloat c = cos(60.0f);
    
    GLfloat zRoation[] = {
        c,s,0,0,
        -s,c,0,0,
        0,0,1.0f,0,
        0,0,0,1.0f
    };
    glUniformMatrix4fv(glGetUniformLocation(_program, "roateMatrix"), 1, GL_FALSE, (GLfloat *)&zRoation);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
}

-(GLuint)getTextureId:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    GLuint width = (GLuint)CGImageGetWidth(imageRef);
    GLuint height = (GLuint)CGImageGetHeight(imageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    void * imageData = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpaceRef, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClearRect(context, rect);
    CGColorSpaceRelease(colorSpaceRef);
    CGContextDrawImage(context, rect, imageRef);
    CGContextRelease(context);
    
    glEnable(GL_TEXTURE_2D);
    GLuint textureId;
    glGenTextures(1, &textureId);
    glBindTexture(GL_TEXTURE_2D, textureId);
    glGenerateMipmap(GL_TEXTURE_2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0,GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    free(imageData);
    
    return textureId;
}


@end

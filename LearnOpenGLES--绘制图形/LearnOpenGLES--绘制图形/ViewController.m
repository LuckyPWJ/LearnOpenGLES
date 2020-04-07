//
//  ViewController.m
//  LearnOpenGLES--绘制图形
//
//  Created by LuckyPan on 2020/4/7.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import "PJLinkHelper.h"
#import <GLKit/GLKit.h>


@interface ViewController ()<GLKViewDelegate>
{
    EAGLContext *_context;
    GLuint       _program;
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
    
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"TrangleVertext" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"TrangleFragment" shaderType:GL_FRAGMENT_SHADER];
    
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
    
    
//    GLfloat trangleVertexs[] = {
//        -0.5f,-0.5f,0.0f,  //v0
//        -0.5f,0.5f,0.0f,   //v1
//        0.5f,0.5f,0.0f,    //v2
//        -0.5f,-0.5f,0.0f,  //v0
//        0.5f,0.5f,0.0f,    //v2
//        0.5f,-0.5f,0.0f,   //v3
//    };
//
//    glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, trangleVertexs);
//    glEnableVertexAttribArray(0);
//    glDrawArrays(GL_TRIANGLES, 0, 6);
//    glDrawArrays(GL_TRIANGLE_FAN, 0, 6);
  
    //GL_TRIANGLE_STRIP
    GLfloat trangleVertexs[] = {
        -0.5f,-0.5f,0.0f,  //v0
        -0.5f,0.5f,0.0f,   //v1
        0.5f,0.5f,0.0f,    //v2
        0.5f,0.5f,0.0f,    //v2
        -0.5f,-0.5f,0.0f,    //v0
        0.5f,-0.5f,0.0f,   //v3
    };
    //使用常量顶点属性设置图元像素颜色
    glVertexAttrib3f(1.0f, 0.5f, 0.6f, 1.0f);
    glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, trangleVertexs);
    glEnableVertexAttribArray(0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);
}


@end

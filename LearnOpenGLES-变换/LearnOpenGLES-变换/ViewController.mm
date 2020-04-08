//
//  ViewController.m
//  LearnOpenGLES-变换
//
//  Created by LuckyPan on 2020/4/8.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import "PJLinkHelper.h"
#import "glm.hpp"
#include "matrix_transform.hpp"
#include "type_ptr.hpp"
#import <GLKit/GLKit.h>

@interface ViewController ()<GLKViewDelegate>
{
    EAGLContext *_context;
    GLuint _program;
    NSTimer *_timer;
    BOOL xOn;
    BOOL yOn;
    float _xdegree;
    float _ydegree;
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
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [self.view addSubview:view];
    _glkView = view;
    
    [self setUpButton];
    
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"TransformVertex" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"TransformFragment" shaderType:GL_FRAGMENT_SHADER];
    
    GLuint program = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    _program = program;
}

-(void)setUpButton
{
    UIButton * xBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xBtn.frame = CGRectMake(40, 40, 40, 30);
    [xBtn setTitle:@"X旋转" forState:UIControlStateNormal];
    [xBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [xBtn addTarget:self action:@selector(xAction) forControlEvents:UIControlEventTouchUpInside];
    xBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:xBtn];
    
    UIButton * yBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yBtn.frame = CGRectMake(120, 40, 40, 30);
    [yBtn setTitle:@"Y旋转" forState:UIControlStateNormal];
    [yBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [yBtn addTarget:self action:@selector(yAction) forControlEvents:UIControlEventTouchUpInside];
    yBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:yBtn];
}


-(void)xAction
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timerRes) userInfo:nil repeats:YES];
    }
    xOn = !xOn;
    
}

-(void)yAction
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timerRes) userInfo:nil repeats:YES];
    }
    yOn = !yOn;
}

-(void)timerRes
{
    _xdegree += xOn * 5;
    _ydegree += yOn * 5;
    
    [_glkView setNeedsDisplay];
}

-(void)drawInWidth:(int)width height:(int)height
{
    glViewport(0, 0, width, height);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(_program);
    
    GLfloat vertexs[] = {
        -0.5,0.5,0,     1.0f,0.0f,1.0f,      //左上
        -0.5,-0.5,0,    0.0f,1.0f,0.0f,      //左下
        0.5,0.5,0,      0.0f,0.0f,1.0f,      //右上
        0.5,-0.5,0,     1.0f,1.0f,1.0f,      //右下
        0,0,1.0f,       1.0f,0.0f,0.5f,      //中间
    };
    
    GLint indexs[] = {
        0,1,2,
        1,2,3,
        0,1,4,
        1,3,4,
        2,3,4,
        0,2,4,
    };
    
    GLuint vbo,ebo;
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);

    glGenBuffers(1, &ebo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indexs), indexs, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), NULL);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(1);
    
    glm::mat4 model = glm::mat4(1.0);
    model = glm::rotate(model, glm::radians(_xdegree), glm::vec3(1.0,0.0f,0.0f));
    model = glm::rotate(model, glm::radians(_ydegree), glm::vec3(0.0,1.0f,0.0f));
    GLint modelLocation = glGetUniformLocation(_program, "modelViewMatrix");
    glUniformMatrix4fv(modelLocation, 1, GL_FALSE, glm::value_ptr(model));
    
    glm::mat4 projection = glm::mat4(1.0);
    GLint projectionLocation = glGetUniformLocation(_program, "projectionMatrix");
    glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, glm::value_ptr(projection));

    glDrawElements(GL_TRIANGLES, sizeof(indexs) / sizeof(indexs[0]), GL_UNSIGNED_INT, 0);
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self drawInWidth:(int)view.drawableWidth height:(int)view.drawableHeight];
}
 

@end

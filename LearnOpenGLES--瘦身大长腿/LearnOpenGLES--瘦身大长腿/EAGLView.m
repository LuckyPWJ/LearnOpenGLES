//
//  EAGLView.m
//  LearnOpenGLES--瘦身大长腿
//
//  Created by LuckyPan on 2020/5/1.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "EAGLView.h"
#import "PJUtil.h"
#import "PJLinkHelper.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface EAGLView()
{
    EAGLContext *_context;
    GLuint _frameBuffer;
    GLuint _program;
    GLuint _textureId;
    GLuint _vao;
    GLuint _vbo;
    GLuint _renderBuffer;
    GLfloat _scale;
}

@property (nonatomic , strong) CAEAGLLayer * myEagLayer;

@end

@implementation EAGLView

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 0.0f;
        
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        
        [EAGLContext setCurrentContext:_context];
        
        _myEagLayer = (CAEAGLLayer *)self.layer;
        
        _myEagLayer.opaque = YES;
        
        // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
        _myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        [self linkShaderAndProgram];
        
        [self setUpData];
        
        [self setUpFrameBuffer];
        
        [self draw];
        
        CADisplayLink *link =  [CADisplayLink displayLinkWithTarget:self selector:@selector(linkAction:)];
        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    return self;
}

-(void)deleteBuffers
{
    glDeleteVertexArrays(1, &_vao);
    glDeleteBuffers(1, &_vbo);
}

-(void)linkAction:(CADisplayLink *)link
{
    [self deleteBuffers];
    [self setUpData];
    [self draw];
}

-(void)linkShaderAndProgram
{
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"vShader" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"fShader" shaderType:GL_FRAGMENT_SHADER];
    _program = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    
    _textureId = [PJUtil getTextureIdFromImage:[UIImage imageNamed:@"t01c74358303225e0ee.jpg"]];
}

-(void)setUpData
{
    CGFloat x1 = -0.3f;
    CGFloat x2 = 0.3f;
    GLfloat vFboVertices[] = {
        -1.0f, -1.0f,  0.0f,                          0.0f, 0.0f,
        -1.0f, 1.0f,   0.0f,                          0.0f, 1.0f,
        (x1 - _scale)/(1.0f + _scale),-1.0f,0.0f,     0.3f, 0.0f,
        (x1 - _scale)/(1.0f + _scale),1.0f,0.0f,      0.3f, 1.0f,
        (x2 + _scale)/(1.0f + _scale),-1.0f,0.0f,     0.6f, 0.0f,
        (x2 + _scale)/(1.0f + _scale),1.0f,0.0f,      0.6f, 1.0f,
        1.0f, -1.0f,   0.0f,                          1.0f, 0.0f,
        1.0f, 1.0f,    0.0f,                          1.0f, 1.0f,
    };
    
    GLuint vbo,vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);
    _vao = vao;
    
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vFboVertices), vFboVertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT) * 5, 0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT) * 5, (void *)(3 * sizeof(GL_FLOAT)));
    glEnableVertexAttribArray(1);
    _vbo = vbo;

}

-(void)setUpFrameBuffer
{
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"GL_FRAMEBUFFER  连接失败");
    }
}

-(void)draw
{
    CGFloat width = self.bounds.size.width / 2 * (1 + _scale);
    CGFloat height = self.bounds.size.height / 2;
    CGFloat x = (self.bounds.size.width - width) / 2;
    glViewport(x,height/2 , width , height);
    glClearColor(0.8f, 0.6f, 0.3f, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_program);
    glActiveTexture(GL_TEXTURE0);
    glBindVertexArray(_vao);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 8);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)setScaleValue:(float)scaleValue
{
    _scale = (GLfloat)scaleValue;
}

@end

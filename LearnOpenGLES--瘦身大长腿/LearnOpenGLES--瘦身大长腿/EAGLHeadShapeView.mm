//
//  EAGLHeadShapeView.m
//  LearnOpenGLES--瘦身大长腿
//
//  Created by LuckyPan on 2020/5/7.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "EAGLHeadShapeView.h"
#import "PJUtil.h"
#import "PJLinkHelper.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "glm.hpp"
#import "type_ptr.hpp"
#import "matrix_transform.hpp"

static const float kTestImageWidth = 500;

static const float kTestImageHeight = 604;

static const int keyPointsCount = 9;

static const int trangleCount = 28;

static GLfloat keyPoints[18] = {
    220,210,  //0
    180,150,
    275,40,
    445,150,
    470,210,
    430,260,
    340,310,
    260,260,
    340,210,  //8
};

float dotProduct(glm::vec2 a,glm::vec2 b){
    return (a.x * b.x + a.y * b.y);
}

@interface EAGLHeadShapeView()
{
    EAGLContext *_context;
    GLuint _vao;
    GLuint _vbo[2];
    GLuint _program;
    GLuint _frameBuffer;
    GLuint _renderBuffer;
    GLuint _textureId;
}

@property(nonatomic, strong) CAEAGLLayer * eaglLayer;

@end

@implementation EAGLHeadShapeView

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        [EAGLContext setCurrentContext:_context];
        
        _eaglLayer = (CAEAGLLayer *)self.layer;
        _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8};
        _eaglLayer.opaque = YES;
        
        [self linkProgram];
        
        [self setUpData];
        
        [self setUpBuffer];
        
        [self draw];
        
        CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkAction:)];
        
        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void)linkAction:(CADisplayLink *)link
{
    [self destoryBuffers];
    [self setUpData];
    [self draw];
}

-(void)linkProgram
{
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"EAGLHeaderVShader" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"EAGLHeaderFShader" shaderType:GL_FRAGMENT_SHADER];
    
    GLuint program = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    _program = program;
}

-(void)setUpData
{
    static int frameIndex = 0;
    frameIndex ++;
    float ratio = (frameIndex % 100) * 1.0f / 100;
    ratio = (frameIndex / 100) % 2 == 1 ? (1 - ratio) : ratio;
    glm::vec2 centerPoint = glm::vec2(keyPoints[16]/kTestImageWidth, keyPoints[17]/kTestImageHeight);
    glm::vec2 keyPointsTextoord[keyPointsCount];
    glm::vec2 keyPointsTextoordCopy[keyPointsCount];

    glm::vec2 keyPointsTextoordInts[keyPointsCount];
    glm::vec2 meshPoints[18];
    glm::vec2 meshPointsCopy[18];
    
    glm::vec2 textoords[trangleCount * 3];
    glm::vec2 textoordsCopy[trangleCount * 3];

    glm::vec3 vertices[trangleCount * 3];
    for (int i = 0; i < keyPointsCount - 1; i ++) {
        glm::vec2 inputPoints = glm::vec2(keyPoints[2 * i]/kTestImageWidth,  keyPoints[2 * i + 1]/kTestImageHeight);
        keyPointsTextoordCopy[i] = inputPoints;
        keyPointsTextoord[i] = [self warpKeyPoint:inputPoints centerPoint:centerPoint level:ratio-0.5f];
        keyPointsTextoordInts[i] = [self caculateIntersectionWithInputPoint:inputPoints centerPoint:centerPoint];
        NSLog(@"i = %d,x = %f,y= %f,",i,keyPointsTextoordCopy[i].x,keyPointsTextoordCopy[i].y);

    }
    keyPointsTextoord[8] = centerPoint;
    keyPointsTextoordInts[8] = centerPoint;
        
    keyPointsTextoordCopy[8] = centerPoint;
    
    //中心
    [self setUpCenterWithTextoords:textoords keyPointsTextoord:keyPointsTextoord];
    [self setUpCenterWithTextoords:textoordsCopy keyPointsTextoord:keyPointsTextoordCopy];
    
    [self setUpMeshPointsWithKeyPointsTextoord:keyPointsTextoord keyPointsTextoordInts:keyPointsTextoordInts meshPoints:meshPoints];
    
    [self setUpMeshPointsWithKeyPointsTextoord:keyPointsTextoordCopy keyPointsTextoordInts:keyPointsTextoordInts meshPoints:meshPointsCopy];
    
    //周围的交点 24开始
    
    [self setUpAroundMeshPointWithTextoords:textoords meshPoints:meshPoints];
    [self setUpAroundMeshPointWithTextoords:textoordsCopy meshPoints:meshPointsCopy];

    
    [self setUpCornerWithTextoords:textoords textoordInts:keyPointsTextoordInts];
    [self setUpCornerWithTextoords:textoordsCopy textoordInts:keyPointsTextoordInts];
    
    for (int i = 0; i < trangleCount * 3; i ++) {
        vertices[i] = glm::vec3(textoords[i].x * 2 - 1,1 - textoords[i].y * 2,0);
    }
    
    GLuint vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);
    _vao = vao;
    
     glGenBuffers(1, &_vbo[0]);
     glBindBuffer(GL_ARRAY_BUFFER, _vbo[0]);
     glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, (void *)0);

    glGenBuffers(1, &_vbo[1]);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(textoordsCopy), textoordsCopy, GL_STATIC_DRAW);

     glEnableVertexAttribArray(1);
     glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 2, (void *)0);
}

-(void)setUpMeshPointsWithKeyPointsTextoord:(glm::vec2 *)keyPointsTextoord keyPointsTextoordInts:(glm::vec2 *)keyPointsTextoordInts meshPoints:(glm::vec2 *)meshPoints
{
    for (int i = 0; i < keyPointsCount - 1; i ++) {
         meshPoints[2 * i] = keyPointsTextoord[i];
         meshPoints[2 * i + 1] = keyPointsTextoordInts[i];
     }
     meshPoints[16] = keyPointsTextoord[0];
     meshPoints[17] = keyPointsTextoordInts[0];
}

-(void)setUpAroundMeshPointWithTextoords:(glm::vec2 *)textoords meshPoints:(glm::vec2 *)meshPoints
{
    for (int i = 2; i < keyPointsCount * 2; i ++) {
          textoords[24 + (i - 2) * 3] = meshPoints[i - 2];
          textoords[24 + (i - 2) * 3 + 1] = meshPoints[i - 1];
          textoords[24 + (i - 2) * 3 + 2] = meshPoints[i];
      }
}

-(void)setUpCenterWithTextoords:(glm::vec2 *)textoords keyPointsTextoord:(glm::vec2 *)keyPointsTextoord
{
    for (int i = 0; i < keyPointsCount - 2; i ++) {
        textoords[3 * i] = keyPointsTextoord[i];
        textoords[3 * i + 1] = keyPointsTextoord[i + 1];
        textoords[3 * i + 2] = keyPointsTextoord[8];
    }
     textoords[21]     = keyPointsTextoord[7];
     textoords[21 + 1] = keyPointsTextoord[0];
     textoords[21 + 2] = keyPointsTextoord[8];
}

//处理四个顶点
-(void)setUpCornerWithTextoords:(glm::vec2 *)textoords textoordInts:(glm::vec2 *)keyPointsTextoordInts
{
    textoords[24 * 3]     = glm::vec2(0,0);
    textoords[24 * 3 + 1] = keyPointsTextoordInts[1];
    textoords[24 * 3 + 2] = keyPointsTextoordInts[2];

    textoords[25 * 3]     = glm::vec2(0,1);
    textoords[25 * 3 + 1] = keyPointsTextoordInts[6];
    textoords[25 * 3 + 2] = keyPointsTextoordInts[7];

    textoords[26 * 3]     = glm::vec2(1,0);
    textoords[26 * 3 + 1] = keyPointsTextoordInts[2];
    textoords[26 * 3 + 2] = keyPointsTextoordInts[3];

    textoords[27 * 3]     = glm::vec2(1,1);
    textoords[27 * 3 + 1] = keyPointsTextoordInts[5];
    textoords[27 * 3 + 2] = keyPointsTextoordInts[6];

//    return textoords;
}

-(void)setUpBuffer
{
    _textureId = [PJUtil getTextureIdFromImage:[UIImage imageNamed:@"test.jpg"]];

    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_context  renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"链接FrameBuffer 失败");
    }
}

-(void)destoryBuffers
{
    glDeleteVertexArrays(1, &_vao);
    glDeleteBuffers(1, &_vbo[0]);
    glDeleteBuffers(1, &_vbo[1]);

}

-(void)draw
{
    glViewport(0,0,self.bounds.size.width, self.bounds.size.height);
    glClearColor(0.4, 0.6, 0.8, 1.0F);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_program);
//    glBindTexture(GL_TEXTURE_2D, _textureId);
    glDrawArrays(GL_TRIANGLES, 0, trangleCount * 3);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    
}

-(glm::vec2)caculateIntersectionWithInputPoint:(glm::vec2)inputPoint centerPoint:(glm::vec2)centerPoint
{
    glm::vec2 outPutPoint;
    //与Y轴平行
    if (inputPoint.x == centerPoint.x) {
        glm::vec2 pointA = glm::vec2(inputPoint.x,0.0f);
        glm::vec2 pointB = glm::vec2(inputPoint.x,1.0f);
        float dA = distance(inputPoint,pointA);
        float dB = distance(inputPoint,pointB);
        outPutPoint = dA > dB ? pointB : pointA;
        return outPutPoint;
    }
    //与X轴平行
      if (inputPoint.y == centerPoint.y) {
          glm::vec2 pointA = glm::vec2(0.0f,inputPoint.y);
          glm::vec2 pointB = glm::vec2(1.0f,inputPoint.y);
        float dA = distance(inputPoint,pointA);
        float dB = distance(inputPoint,pointB);
        outPutPoint = dA > dB ? pointB : pointA;
        return outPutPoint;
    }
    //y = a * x + c
    float a = 0, c = 0;
    a = (inputPoint.y - centerPoint.y)/(inputPoint.x - centerPoint.x);
    c = inputPoint.y - a * inputPoint.x;
    
    //x = 0, x = 1, y = 0, y = 1
    //x = 0
    
    //outPutPoint.y = a * outPutPoint.x + c;
    
    glm::vec2 point_0 = glm::vec2(0,c);
    
    float d0 = dot((centerPoint - inputPoint),(centerPoint - point_0));
    if (c >= 0 && c <= 1 && d0 > 0) {
        outPutPoint = point_0;
        return outPutPoint;
    }
    
    //x = 1
    glm::vec2 point_1 = glm::vec2(1,a + c);
    float d1 = dot((centerPoint - inputPoint),(centerPoint - point_1));
    if ((a + c) >= 0 && (a + c) <= 1 && d1 > 0) {
        outPutPoint = point_1;
        return outPutPoint;
    }
    
    //y = 0
    glm::vec2 point_2 = glm::vec2(-c/a,0);
    float d2 = dot((centerPoint - inputPoint),(centerPoint - point_2));
    if ((-c/a) >= 0 && (-c/a) <= 1 && d2 > 0) {
        outPutPoint = point_2;
        return outPutPoint;
    }
    
    //y = 1
    float x = (1-c)/a;
    glm::vec2 point_3 = glm::vec2(x,1);
     float d3 = dot((centerPoint - inputPoint),(centerPoint - point_3));
     if (x >= 0 && x <= 1 && d3 > 0) {
         outPutPoint = point_3;
         return outPutPoint;
     }
    
    return outPutPoint;
}

-(glm::vec2)warpKeyPoint:(glm::vec2)inputPoint centerPoint:(glm::vec2)centerPoint level:(float)level{
    glm::vec2 distancePoint = centerPoint - inputPoint;
    glm::vec2 outputPoint   = distancePoint * level * 0.3f + inputPoint;
    return outputPoint;
}


@end


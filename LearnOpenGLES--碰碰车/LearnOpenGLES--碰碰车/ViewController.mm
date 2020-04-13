//
//  ViewController.m
//  LearnOpenGLES--碰碰车
//
//  Created by LuckyPan on 2020/4/11.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import "glm.hpp"
#import "type_ptr.hpp"
#import <GLKit/GLKView.h>
#import <OpenGLES/ES3/gl.h>
#import "bumperRink.h"
#import "bumperCar.h"
#import "PJLinkHelper.h"
#import <GLKit/GLKit.h>

typedef struct
{
   glm::vec3 min;
   glm::vec3 max;
}SceneAxisAllignedBoundingBox;

GLfloat SceneScalarSlowLowPassFilter(NSTimeInterval elapsed,
                                     GLfloat target,
                                     GLfloat current)
{
    return current + (4.0 * elapsed * (target - current));
}


@interface ViewController ()<GLKViewDelegate>
{
    EAGLContext *_context;
    GLuint _vao;
    GLuint _carVao;
    GLuint _program;
    GLuint _carProgram;
    glm::vec3 _velocity;
    glm::vec3 _position;
    glm::vec3 _nextPosition;
    GLfloat _yawRadians;
    GLfloat _targetYawRadians;
    SceneAxisAllignedBoundingBox _boundingBox;
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
    
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"RinkVertex" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"RinkFragment" shaderType:GL_FRAGMENT_SHADER];
    _program = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    
    GLuint carVShader = [PJLinkHelper loadWithShaderName:@"CarVertex" shaderType:GL_VERTEX_SHADER];
    GLuint carFShader = [PJLinkHelper loadWithShaderName:@"CarFragment" shaderType:GL_FRAGMENT_SHADER];
    _carProgram = [PJLinkHelper loadWithVShader:carVShader fShader:carFShader];

    [self initData];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [view setNeedsDisplay];
    }];
}

-(void)updateCar
{
    glm::vec3 travelDistance = _velocity * 0.1f;
    _nextPosition = _position + travelDistance;
    
    [self bounceOffWallsWithBoundingBox:_boundingBox];
    
    float dotProduct = glm::dot(glm::normalize(_velocity), glm::vec3(0,0,-1.0f));
    if (_velocity.x < 0.0) {
        _targetYawRadians = acosf(dotProduct);
    }else{
        _targetYawRadians = -acosf(dotProduct);
    }
    
    _yawRadians = SceneScalarSlowLowPassFilter(0.05f, _targetYawRadians, _yawRadians);
    _position = _nextPosition;
}

-(void)initData
{
    GLuint vao = [self pepreDrawWithPositon:bumperRinkVerts positionSize:sizeof(bumperRinkVerts) normal:bumperRinkNormals normalSize:sizeof(bumperRinkNormals)];
    _vao = vao;
    glBindVertexArray(0);
    
    GLuint carVao = [self pepreDrawWithPositon:bumperCarVerts positionSize:sizeof(bumperCarVerts) normal:bumperCarNormals normalSize:sizeof(bumperCarNormals)];
      _carVao = carVao;
      glBindVertexArray(0);
    
    _velocity = glm::vec3(1.0f,0.0f,1.5f);
    _position = glm::vec3(1.0f,0.0f,1.0f);

    [self updateAlignedBoundingBoxForVertices:bumperRinkVerts count:bumperRinkNumVerts];
}

-(GLuint)pepreDrawWithPositon:(const GLvoid *)position
                 positionSize:(GLsizei)positionSize
                       normal:(const GLvoid *)normal
                   normalSize:(GLsizei)normalSize
{
    GLuint vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    GLuint vboVertex,vboNormal;
    glGenBuffers(1,&vboVertex);
    glBindBuffer(GL_ARRAY_BUFFER, vboVertex);
    glBufferData(GL_ARRAY_BUFFER, positionSize, position, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(0);
    glGenBuffers(1,&vboNormal);
    glBindBuffer(GL_ARRAY_BUFFER, vboNormal);
    glBufferData(GL_ARRAY_BUFFER,normalSize , normal, GL_STATIC_DRAW);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE,0,0);
    glEnableVertexAttribArray(1);
    return vao;
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glViewport(0, 0, (int)view.drawableWidth, (int)view.drawableHeight);
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_program);
    glBindVertexArray(_vao);
    
    glm::vec3 lightPos = glm::vec3(11.0f,5.8f,0.0f);
    glm::mat4 model = glm::mat4(1.0f);
    glm::mat4 views = glm::mat4(1.0f);
    glm::mat4 projection = glm::mat4(1.0f);
    views = glm::lookAt(glm::vec3(10.0f,5.0f,0.0f), glm::vec3(0.0f,0.0f,0.0f), glm::vec3(0,1,0));
    const GLfloat  aspectRatio =
    (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    projection = glm::perspective(glm::radians(35.0f), aspectRatio, 0.1f, 25.0f);
    
    glUniformMatrix4fv(glGetUniformLocation(_program, "model"), 1, GL_FALSE, glm::value_ptr(model));
    glUniformMatrix4fv(glGetUniformLocation(_program, "view"), 1, GL_FALSE, glm::value_ptr(views));
    glUniformMatrix4fv(glGetUniformLocation(_program, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    glUniform3fv(glGetUniformLocation(_program, "lightPos"), 1, glm::value_ptr(lightPos));
    glDrawArrays(GL_TRIANGLES, 0, 180);
    glBindVertexArray(0);
    
    [self updateCar];

    glUseProgram(_carProgram);
    glBindVertexArray(_carVao);
    model = glm::translate(model, _position);
    //_yawRadians表示的是角度，glm::roate需要传入的是矩阵，所以先转成弧度
    model = glm::rotate(model,glm::radians(GLKMathRadiansToDegrees(_yawRadians)), glm::vec3(0.0f,1.0f,.0f));
    glUniformMatrix4fv(glGetUniformLocation(_carProgram, "model"), 1, GL_FALSE, glm::value_ptr(model));
    glUniformMatrix4fv(glGetUniformLocation(_carProgram, "view"), 1, GL_FALSE, glm::value_ptr(views));
    glUniformMatrix4fv(glGetUniformLocation(_carProgram, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    glUniform3fv(glGetUniformLocation(_carProgram, "lightPos"), 1, glm::value_ptr(lightPos));

    glUniform3fv(glGetUniformLocation(_carProgram, "objectColor"), 1, glm::value_ptr(glm::vec3(0.5f,0.0f,0.0f)));

    glDrawArrays(GL_TRIANGLES, 0, bumperCarNumVerts);
}
//更新场景坐标，获取X轴min,max，Y轴min，max
- (void)updateAlignedBoundingBoxForVertices:(float *)verts
   count:(unsigned int)aCount;
{
   SceneAxisAllignedBoundingBox result =
      {{0, 0, 0},{0, 0, 0}};
   const glm::vec3 *positions = (const glm::vec3 *)verts;
       
   if(0 < aCount)
   {
      result.min.x = result.max.x = positions[0].x;
      result.min.y = result.max.y = positions[0].y;
      result.min.z = result.max.z = positions[0].z;
   }
   for(int i = 1; i < aCount; i++)
   {
      result.min.x = MIN(result.min.x, positions[i].x);
      result.min.y = MIN(result.min.y, positions[i].y);
      result.min.z = MIN(result.min.z, positions[i].z);
      result.max.x = MAX(result.max.x, positions[i].x);
      result.max.y = MAX(result.max.y, positions[i].y);
      result.max.z = MAX(result.max.z, positions[i].z);
   }
   _boundingBox = result;
}

//检测car和墙的碰撞
- (void)bounceOffWallsWithBoundingBox:(SceneAxisAllignedBoundingBox)rinkBoundingBox
{
    float radius = 0.45;
    if((_boundingBox.min.x + radius) > _nextPosition.x)
    {
        //下一个点超过了x最小的边界
        _nextPosition = glm::vec3((rinkBoundingBox.min.x + radius),
                                  _nextPosition.y, _nextPosition.z);
        //撞墙后x方向 相反
        _velocity = glm::vec3(-_velocity.x, _velocity.y, _velocity.z);
    }
    else if((_boundingBox.max.x - radius) < _nextPosition.x)
    {
        //下一个点超过了x最大的边界
        _nextPosition = glm::vec3((rinkBoundingBox.max.x - radius), _nextPosition.y, _nextPosition.z);
        _velocity = glm::vec3(-_velocity.x,
                                       _velocity.y, _velocity.z);
    }
    
    //z的边界判断
    if((_boundingBox.min.z + radius) > _nextPosition.z)
    {
        _nextPosition = glm::vec3(_nextPosition.x,
                                           _nextPosition.y,
                                           (rinkBoundingBox.min.z + radius));
        _velocity = glm::vec3(_velocity.x,
                                       _velocity.y, -_velocity.z);
    }
    else if((_boundingBox.max.z - radius) <
            _nextPosition.z)
    {
        _nextPosition = glm::vec3(_nextPosition.x,
                                        _nextPosition.y,
                                           (rinkBoundingBox.max.z - radius));
        _velocity = glm::vec3(_velocity.x,
                                       _velocity.y, -_velocity.z);
    }
}
@end



//
//  PJEAGLView.m
//  LearnOpenGLES--VideoOutPut
//
//  Created by LuckyPan on 2020/4/22.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "PJEAGLView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "PJUtil.h"
#import "PJLinkHelper.h"
#import <AVFoundation/AVUtilities.h>

static const GLfloat kColorConversion601[] = {
    1.164,  1.164, 1.164,
    0.0, -0.392, 2.017,
    1.596, -0.813,   0.0,
};

static const GLfloat kColorConversion709[] = {
    1.164,  1.164, 1.164,
    0.0, -0.213, 2.112,
    1.793, -0.533,   0.0,
};

@interface PJEAGLView()
{
    GLint _width;
    GLint _height;
    GLuint _frameBuffer;
    GLuint _colorBuffer;
    GLuint _program;
    
    EAGLContext *_context;
    const float *_preferredConversion;
    CVOpenGLESTextureRef _lumaTexture;
    CVOpenGLESTextureRef _chromaTexture;
    CVOpenGLESTextureCacheRef _videoTextureCache;
}

@end

@implementation PJEAGLView

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        self.layer.contentsScale = scale;
        
        CAEAGLLayer * eagLayer = (CAEAGLLayer *)[self layer];
        eagLayer.opaque = TRUE;
        eagLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking :[NSNumber numberWithBool:NO]};
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        _preferredConversion = kColorConversion709;
        
        [self setupGL];
    }
    return self;
}

-(void)setupGL
{
    [EAGLContext setCurrentContext:_context];
    [self setUpBuffers];
    [self loadShaders];
    
    glUseProgram(_program);
    glUniform1i(glGetUniformLocation(_program, "SamplerY"), 0);
    glUniform1i(glGetUniformLocation(_program, "SamplerUV"), 1);
//    glUniformMatrix3fv(glGetUniformLocation(_program, "colorConversionMatrix"), 1, GL_FALSE, _preferredConversion);
    
    if (!_videoTextureCache) {
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &_videoTextureCache);
        if (err != noErr) {
            NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
            return;
        }
    }
}

-(void)setUpBuffers
{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_colorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBuffer);
    
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_height);

    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBuffer);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }

}

-(void)loadShaders
{
    GLuint vShader = [PJLinkHelper loadWithShaderName:@"VideoOutPutVertex" shaderType:GL_VERTEX_SHADER];
    GLuint fShader = [PJLinkHelper loadWithShaderName:@"VideoOutPutFragment" shaderType:GL_FRAGMENT_SHADER];
    GLuint program = [PJLinkHelper loadWithVShader:vShader fShader:fShader];
    _program = program;
}


-(void)displayPixelBuffers:(CVPixelBufferRef)pixelBuffer
{
    if (pixelBuffer != NULL) {
        if (!_videoTextureCache) {
            return;
        }
        if (_lumaTexture) {
            CFRelease(_lumaTexture);
            _lumaTexture = NULL;
        }
        if (_chromaTexture) {
            CFRelease(_chromaTexture);
            _chromaTexture = NULL;
        }
        CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
        
        CFTypeRef colorAttachment = CVBufferGetAttachment(pixelBuffer, kCVImageBufferYCbCrMatrixKey, NULL);
        if (CFStringCompare(colorAttachment, kCVImageBufferYCbCrMatrix_ITU_R_601_4, 0) == kCFCompareEqualTo) {
            _preferredConversion = kColorConversion601;
        }else{
            _preferredConversion = kColorConversion709;
        }
        
        int width = (int)CVPixelBufferGetWidth(pixelBuffer);
        int height = (int)CVPixelBufferGetHeight(pixelBuffer);
        
        CVReturn err;
        glActiveTexture(GL_TEXTURE0);
        err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                           _videoTextureCache,
                                                           pixelBuffer,
                                                           NULL,
                                                           GL_TEXTURE_2D,
                                                           GL_LUMINANCE,
                                                           width,
                                                           height,
                                                           GL_LUMINANCE,
                                                           GL_UNSIGNED_BYTE,
                                                           0,
                                                           &_lumaTexture);
        if (err) {
              NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
          }
        glBindTexture(CVOpenGLESTextureGetTarget(_lumaTexture), CVOpenGLESTextureGetName(_lumaTexture));
        NSLog(@"id %d", CVOpenGLESTextureGetName(_lumaTexture));

        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glActiveTexture(GL_TEXTURE1);
        err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                           _videoTextureCache,
                                                           pixelBuffer,
                                                           NULL,
                                                           GL_TEXTURE_2D,
                                                           GL_LUMINANCE_ALPHA,
                                                           width/2,
                                                           height/2,
                                                           GL_LUMINANCE_ALPHA,
                                                           GL_UNSIGNED_BYTE,
                                                           1,
                                                           &_chromaTexture);
        if (err) {
              NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
          }
        glBindTexture(CVOpenGLESTextureGetTarget(_chromaTexture), CVOpenGLESTextureGetName(_chromaTexture));
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, _width, _height);
    glClearColor(0.6f, 0.8f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_program);
    glUniformMatrix3fv(glGetUniformLocation(_program, "colorConversionMatrix"), 1, GL_FALSE, _preferredConversion);
    
    CGRect transformRect = AVMakeRectWithAspectRatioInsideRect(self.presentationRect, self.layer.bounds);

    CGSize normaleSize = CGSizeMake(transformRect.size.width / self.layer.bounds.size.width, transformRect.size.height / self.layer.bounds.size.height);

    CGSize scaleSize = CGSizeZero;
    if (normaleSize.width > normaleSize.height) {
        scaleSize.width = 1.0f;
        scaleSize.height = normaleSize.height / normaleSize.width;
    }else{
        scaleSize.width = normaleSize.width / normaleSize.height;
        scaleSize.height = 1.0f;
    }
    GLfloat vertexs[] = {
        -1 *scaleSize.width,-1 * scaleSize.height,
        scaleSize.width,-1 *scaleSize.height,
        -1 *scaleSize.width,scaleSize.height,
        scaleSize.width,scaleSize.height
    };

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, vertexs);
    glEnableVertexAttribArray(0);

         GLfloat textures[] =  {
             0, 1,  // 0,1
             1, 1,  // 1,1
             0, 0,  // 0,0
             1, 0   // 1,0
         };

    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, textures);
    glEnableVertexAttribArray(1);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBuffer);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}


@end

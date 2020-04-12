//
//  PJUtil.m
//  LearnOpenGLES-变换
//
//  Created by LuckyPan on 2020/4/9.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "PJUtil.h"
#import <OpenGLES/ES3/gl.h>

@implementation PJUtil

+(GLuint)getTextureIdFromImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    GLuint width        = (GLuint)CGImageGetWidth(imageRef);
    GLuint height       = (GLuint)CGImageGetHeight(imageRef);
    CGRect rect         = CGRectMake(0, 0, width, height);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    void * imageData = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpaceRef, CGImageGetAlphaInfo(imageRef));
    
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpaceRef);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, imageRef);
    CGContextRelease(context);
    
    GLuint textureId;
    glGenTextures(1, &textureId);
    glBindTexture(GL_TEXTURE_2D, textureId);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    free(imageData);
    return textureId;
}

@end

//
//  PJLinkHelper.h
//  LearnOpenGLES
//
//  Created by LuckyPan on 2020/4/7.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface PJLinkHelper : NSObject

+(GLuint)loadWithShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType;

+(GLuint)loadWithVShader:(GLuint )vShader fShader:(GLuint)fShader;

@end

NS_ASSUME_NONNULL_END

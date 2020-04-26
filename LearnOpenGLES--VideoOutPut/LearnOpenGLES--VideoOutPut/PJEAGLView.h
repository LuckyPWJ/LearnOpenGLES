//
//  PJEAGLView.h
//  LearnOpenGLES--VideoOutPut
//
//  Created by LuckyPan on 2020/4/22.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PJEAGLView : UIView

@property CGSize presentationRect;

-(void)displayPixelBuffers:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END

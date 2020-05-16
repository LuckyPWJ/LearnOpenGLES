//
//  ViewController.m
//  LearnOpenGLES--瘦身大长腿
//
//  Created by LuckyPan on 2020/5/1.
//  Copyright © 2020 潘伟建. All rights reserved.
//

#import "ViewController.h"
#import "EAGLHeadShapeView.h"
#import "EAGLView.h"

@interface ViewController ()
{
    EAGLView *_glview;
    EAGLHeadShapeView *_glHeaderView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view.
//    EAGLView * view = [[EAGLView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
//    _glview = view;

//    UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
//    slider.maximumValue = 1.0f;
//    slider.minimumValue = 0.0f;
//    [self.view addSubview:slider];
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    EAGLHeadShapeView * shapeView = [[EAGLHeadShapeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:shapeView];
    _glHeaderView = shapeView;    
 
}

//-(void)sliderValueChanged:(UISlider *)slider
//{
//    _glview.scaleValue = slider.value;
//}

@end

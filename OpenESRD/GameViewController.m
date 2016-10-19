//
//  GameViewController.m
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "GLWaveFrontGeometry.h"
#import "GLPlaneGeometry.h"
#import "GLWorld.h"

@interface GameViewController () {
    GLuint _program;

    GLKMatrix4 _viewProjection;
    GLKMatrix4 _modelMatrix;
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;

    GLGeometry *wf;
    GLWorld *world;

    CGPoint lastTouchPoint;
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;
    world = [[GLWorld alloc]initWithGLKView:view];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ball2" ofType:@".obj"];
    [world addGeometry:[[GLWaveFrontGeometry alloc]initWithWaveFrontFilePath:filePath]];
    
    
    GLPlaneGeometry *plane = [GLPlaneGeometry new];
    plane.transform.translateY = -5;
    plane.transform.scaleX = 10;
    plane.transform.scaleZ = 10;
    plane.transform.quaternion = GLKQuaternionMakeWithAngleAndAxis(10 / 180.0 * M_PI, 0, 0, 1);
    [world addGeometry:plane];
}

- (void)dealloc {
    [self tearDownGL];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)tearDownGL {
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    [world update:self.timeSinceLastUpdate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    lastTouchPoint = [touches.anyObject locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [touches.anyObject locationInView:self.view];
    CGFloat dx = pt.x - lastTouchPoint.x;
    CGFloat dy = pt.y - lastTouchPoint.y;

    world.angleY += dx / 100.0f;
    world.angleX += dy / 100.0f;

    lastTouchPoint = pt;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [world render:rect];
}

@end

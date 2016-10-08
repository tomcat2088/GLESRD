//
//  GameViewController.m
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "GLGeometry.h"
#import "GLWorld.h"

@interface GameViewController () {
    GLuint _program;

    GLKMatrix4 _viewProjection;
    GLKMatrix4 _modelMatrix;
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;

    GLGeometry *plane;
    GLWorld *world;
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
    plane = [[GLGeometry alloc]initWithWaveFrontFilePath:@""];
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
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);

//
//    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -13.0f);
//    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
//
//    // Compute the model view matrix for the object rendered with GLKit
//    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
//    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
//
//    self.effect.transform.modelviewMatrix = modelViewMatrix;
//
//    // Compute the model view matrix for the object rendered with ES2
//    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
//    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
//
//    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
//
//    _viewProjection = projectionMatrix;
//    _modelMatrix = modelViewMatrix;
//    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
//
//    _rotation += self.timeSinceLastUpdate * 0.5f;
    
    [world update:self.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [world render];
}

@end

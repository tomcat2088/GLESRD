//
//  GLWorld.h
//  OpenESRD
//
//  Created by wang yang on 2016/10/7.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@class GLGeometry;
@class GLLight;

@interface GLWorld : NSObject

@property (strong, nonatomic) EAGLContext *context;
@property (assign, nonatomic) GLKMatrix4 viewProjection;
@property (strong, nonatomic) GLLight *light;
@property (assign, nonatomic) GLKMatrix4 lightViewProjection;
@property (assign, nonatomic) GLuint shadowFramebuffer;
@property (assign, nonatomic) GLuint shadowTexture;

@property (assign, nonatomic) CGFloat angleY;
@property (assign, nonatomic) CGFloat angleX;

- (instancetype)initWithGLKView:(GLKView *)glkView;
- (void)addGeometry:(GLGeometry *)geometry;
- (void)render:(CGRect)rect;
- (void)update:(NSTimeInterval)interval;
@end

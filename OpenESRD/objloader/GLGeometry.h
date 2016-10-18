//
//  Geometry.h
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

#import "GLDefines.h"
#import "GLProgram.h"
#import "GLMaterial.h"
#import "GLPhysicsWorld.h"
#import "GLRigidBody.h"

@class GLWorld;

typedef struct {
    GLuint vertexVBO;
    GLuint indiceVBO;
    GLsizei indiceCount;
    GLuint vertexStride;
    GLuint vertexCount;
    BOOL supportIndiceVBO;
}GLGeometryData;

@interface GLGeometry : NSObject
@property (strong, nonatomic) GLProgram *glProgram;
@property (weak, nonatomic) GLWorld *world;

@property (assign, nonatomic) GLKMatrix4 viewProjection;
@property (assign, nonatomic) GLKMatrix4 lightViewProjection;
@property (assign, nonatomic) GLKMatrix4 modelMatrix;
@property (assign, nonatomic) GLKMatrix3 normalMatrix;
@property (strong, nonatomic) GLMaterial *material;

@property (assign, nonatomic) BOOL renderAsShadow;

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader;
- (void)setupWithData:(GLGeometryData)data;
- (void)draw;
- (void)update:(NSTimeInterval)interval;
- (NSArray *)rigidBodys;
@end

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
@property (assign, nonatomic) GLKMatrix4 viewProjection;
@property (assign, nonatomic) GLKMatrix4 modelMatrix;
@property (assign, nonatomic) GLKMatrix3 normalMatrix;

@property (strong, nonatomic) GLMaterial *material;

- (void)setupWithData:(GLGeometryData)data;
- (void)draw;
- (void)update:(NSTimeInterval)interval;
@end

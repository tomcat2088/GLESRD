//
//  Geometry.h
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import "GeometryDefines.h"

@interface Geometry : NSObject
@property (assign, nonatomic) GLuint vertexVBO;
@property (assign, nonatomic) GLuint indiceVBO;
@property (assign, nonatomic) GLuint vao;

- (instancetype)initWithProgram:(GLuint)program;
- (void)draw;
@end

//
//  ObjLoader.h
//  OpenESRD
//
//  Created by wang yang on 2016/10/6.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import "GLMaterial.h"

@interface GLWaveFrontFile : NSObject
@property (assign, nonatomic) GLuint vertexVBO;
@property (assign, nonatomic) GLuint indiceVBO;
@property (assign, nonatomic) GLsizei vertexStride;
@property (assign, nonatomic) GLsizei vertexCount;
@property (assign, nonatomic) GLsizei indiceCount;

@property (assign, nonatomic) GLsizei uvOffset;
@property (strong, nonatomic) NSArray *materials;

- (instancetype)initWithFilePath:(NSString *)path;
@end

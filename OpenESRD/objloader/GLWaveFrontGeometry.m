//
//  GLOBJGeometry.m
//  OpenESRD
//
//  Created by wangyang on 2016/10/9.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLWaveFrontGeometry.h"
#import "GLWaveFrontFile.h"

@interface GLWaveFrontGeometry ()

@property (strong, nonatomic) GLWaveFrontFile *obj;

@end

@implementation GLWaveFrontGeometry
- (instancetype)initWithWaveFrontFilePath:(NSString *)path {
    self = [super init];
    if (self) {
        self.obj = [[GLWaveFrontFile alloc] initWithFilePath:path];
        GLGeometryData data;
        data.vertexCount = self.obj.vertexCount;
        data.vertexVBO = self.obj.vertexVBO;
        data.vertexStride = self.obj.vertexStride;
        data.supportIndiceVBO = NO;
        [self setupWithData:data];
    }
    return self;
}
@end

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
        self.material = [GLMaterial new];
        NSMutableArray *geometries = [NSMutableArray new];
        for (GLWaveFrontShape *shape in self.obj.shapes) {
            GLGeometry *geometry = [GLGeometry new];
            GLGeometryData data;
            data.vertexCount = shape.vertexCount;
            data.vertexVBO = shape.vertexVBO;
            data.vertexStride = shape.vertexStride;
            data.supportIndiceVBO = NO;
            [geometry setupWithData:data];
            geometry.material = shape.material;
            [geometries addObject:geometry];
        }
        self.geometries = [geometries copy];
    }
    return self;
}

- (void)setWorld:(GLWorld *)world {
    for (GLGeometry *geometry in self.geometries) {
        [geometry setWorld:world];
    }
}

- (void)draw {
    for (GLGeometry *geometry in self.geometries) {
        geometry.viewProjection = self.viewProjection;
        geometry.renderAsShadow = self.renderAsShadow;
        geometry.lightViewProjection = self.lightViewProjection;
//        geometry.material.diffuseMap = self.material.diffuseMap;
        geometry.material.shadowMap = self.material.shadowMap;
        [geometry draw];
    }
}

- (void)update:(NSTimeInterval)interval {
    for (GLGeometry *geometry in self.geometries) {
        [geometry update:interval];
    }
}

@end

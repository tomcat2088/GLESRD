//
//  GLMaterial.m
//  OpenESRD
//
//  Created by wang yang on 2016/10/12.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLMaterial.h"

@implementation GLMaterial

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ambient = GLKVector4Make(0.0, 0.0, 0.1, 1.0);
        self.diffuse = GLKVector4Make(0.6, 0.6, 0.6, 1.0);
        self.specular = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    }
    return self;
}

@end

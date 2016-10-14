//
//  GLLight.m
//  OpenESRD
//
//  Created by wangyang on 2016/10/13.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLLight.h"

@implementation GLLight

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.color = GLKVector4Make(1, 1, 1, 1);
        self.brightness = 0.3; //0 ~ 1
        self.position = GLKVector3Make(0, 8,8);
    }
    return self;
}

- (void)update:(NSTimeInterval)interval {
//    GLKQuaternion quaternion = GLKQuaternionMakeWithAngleAndAxis(-M_PI * interval / 10, 0, 1, 0);
//    self.position = GLKQuaternionRotateVector3(quaternion, self.position);
}

@end

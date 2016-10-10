//
//  GLTransform.m
//  OpenESRD
//
//  Created by wangyang on 2016/10/8.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLTransform.h"

#import <GLKit/GLKit.h>

@implementation GLTransform

- (GLKMatrix4)matrix {
    GLKMatrix4 matrix = GLKMatrix4Identity;
    matrix = GLKMatrix4Scale(matrix, self.scaleX, self.scaleY, self.scaleZ);
    matrix = GLKMatrix4Rotate(matrix, self.rotateX, 1.0 , 0.0 , 0.0);
    matrix = GLKMatrix4Rotate(matrix, self.rotateX, 1.0 , 0.0 , 0.0);
    matrix = GLKMatrix4Rotate(matrix, self.rotateX, 1.0 , 0.0 , 0.0);
    matrix = GLKMatrix4Translate(matrix,self.translateX, self.translateY, self.translateZ);
    return matrix;
}

@end

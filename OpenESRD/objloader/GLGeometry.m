//
//  Geometry.m
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLGeometry.h"
#import "UIImage+GL.h"
#import "GLWaveFrontFile.h"
#import "GLDefines.h"

@interface GLGeometry () {
    GLfloat rotation;
    GLuint currentTexture;
    float elapsedTime;
}

@property (strong, nonatomic) NSArray *textures;
@property (assign, nonatomic) GLuint vao;
@property (assign, nonatomic) GLGeometryData data;

@end

@implementation GLGeometry

- (void)setupWithData:(GLGeometryData)data {
    self.data = data;
    self.glProgram = [[GLProgram alloc]initWithVertexShaderFileName:@"Shader" fragmentShaderFileName:@"Shader"];
    [self createTexture];
    [self setupVAO];
}

- (void)setupVAO {
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(self.vao);

    glBindBuffer(GL_ARRAY_BUFFER, self.data.vertexVBO);

    GLuint positionLocation = glGetAttribLocation(self.glProgram.value, "position");
    glEnableVertexAttribArray(positionLocation);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, self.data.vertexStride, 0);

    GLuint normalLocation = glGetAttribLocation(self.glProgram.value, "normal");
    glEnableVertexAttribArray(normalLocation);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, self.data.vertexStride, BUFFER_OFFSET(3 * sizeof(GLfloat)));

    GLuint uvLocation = glGetAttribLocation(self.glProgram.value, "uv");
    glEnableVertexAttribArray(uvLocation);
    glVertexAttribPointer(uvLocation, 2, GL_FLOAT, GL_FALSE, self.data.vertexStride, BUFFER_OFFSET(6 * sizeof(GLfloat)));

    if (self.data.indiceVBO) {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.data.indiceVBO);
    }

    glBindVertexArrayOES(0);
}

- (void)createTexture {
    self.textures = [UIImage texturesFromGif:@"demo"];
    currentTexture = 0;
}

- (void)draw {
    glUseProgram(self.glProgram.value);

    glUniformMatrix4fv([self.glProgram uniform:UNIFORM_VIEWPROJECTION], 1, 0, self.viewProjection.m);
    glUniformMatrix4fv([self.glProgram uniform:UNIFORM_MODEL_MATRIX], 1, 0, self.modelMatrix.m);
    glUniformMatrix3fv([self.glProgram uniform:UNIFORM_NORMAL_MATRIX], 1, 0, self.normalMatrix.m);

    glBindTexture(GL_TEXTURE_2D, (GLuint)[self.textures[currentTexture] unsignedIntegerValue]);

    glBindVertexArrayOES(self.vao);
    if (self.data.supportIndiceVBO) {
        glDrawElements(GL_TRIANGLES, self.data.indiceCount, GL_UNSIGNED_INT, 0);
    } else {
        glDrawArrays(GL_TRIANGLES, 0, self.data.vertexCount);
    }
    glBindVertexArrayOES(0);
}

- (void)update:(NSTimeInterval)interval {
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    baseModelViewMatrix = GLKMatrix4Scale(baseModelViewMatrix, 1.0f, 1.0f, 1.0f);

    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, rotation, 0.0f, 1.0f, 0.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);

    GLKMatrix4 mvp =  GLKMatrix4Multiply(self.viewProjection, modelViewMatrix);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);

    self.normalMatrix = normalMatrix;
    self.modelMatrix = modelViewMatrix;

    //rotation += interval * 0.8f;

    elapsedTime += interval;
    if (elapsedTime >= 1 / 30.0f) {
        currentTexture++;
        if (currentTexture > self.textures.count - 1) {
            currentTexture = 0;
            elapsedTime = 0;
        }
    }

}

@end

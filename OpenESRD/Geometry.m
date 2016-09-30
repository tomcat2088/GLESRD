//
//  Geometry.m
//  OpenESRD
//
//  Created by wangyang on 2016/9/30.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "Geometry.h"
#import "UIImage+GL.h"

@interface Geometry()

@property (assign, nonatomic) GLuint program;
@property (assign, nonatomic) GLsizei indiceCount;
@property (assign, nonatomic) GLsizei vertexStride;

@property (assign, nonatomic) GLuint texture;
@end

@implementation Geometry
- (instancetype)initWithProgram:(GLuint)program
{
    self = [super init];
    if (self) {
        self.program = program;
        [self createTexture];
        [self setupVBO];
        [self setupVAO];
    }
    return self;
}

- (void)setupVBO {
    const GLfloat vertex[4][9] = {
        {-0.5f,-0.5f,0.0f,  0.9f,0.0f,0.0f,1.0f,  0,0},
        {-0.5f,0.5f,0.0f,  0.0f,0.9f,0.0f,1.0f,  0,1},
        {0.5f,0.5f,0.0f,  0.0f,0.0f,0.9f,1.0f,  1,1},
        {0.5f,-0.5f,0.0f,  0.4f,0.4f,0.4f,1.0f,  1,0}
    };
    glGenBuffers(1, &_vertexVBO);
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex), vertex, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    const GLuint indice[2][3] = {
        0,1,2,
        2,3,0
    };
    glGenBuffers(1, &_indiceVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.indiceVBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indice), indice, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    self.indiceCount = sizeof(indice) / sizeof(GLuint);
    self.vertexStride = sizeof(vertex[0]);
}

- (void)setupVAO {
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(self.vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexVBO);
    
    GLuint positionLocation = glGetAttribLocation(self.program, "position");
    glEnableVertexAttribArray(positionLocation);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, self.vertexStride, 0);
    
    GLuint colorLocation = glGetAttribLocation(self.program, "color");
    glEnableVertexAttribArray(colorLocation);
    glVertexAttribPointer(colorLocation, 4, GL_FLOAT, GL_FALSE, self.vertexStride, BUFFER_OFFSET(3 * sizeof(GLfloat)));
    
    GLuint uvLocation = glGetAttribLocation(self.program, "uv");
    glEnableVertexAttribArray(uvLocation);
    glVertexAttribPointer(uvLocation, 2, GL_FLOAT, GL_FALSE, self.vertexStride, BUFFER_OFFSET(7 * sizeof(GLfloat)));
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.indiceVBO);
    
    glBindTexture(GL_TEXTURE_2D, self.texture);
    
    glBindVertexArrayOES(0);
}

- (void)createTexture {
    GLsizei width,height;
    GLubyte *textureData = [UIImage dataFromImage:@"texture.png" width:&width height:&height];
    
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glBindTexture(GL_TEXTURE_2D,0);
}

- (void)draw {
    glBindVertexArrayOES(self.vao);
    glDrawElements(GL_TRIANGLES, self.indiceCount,GL_UNSIGNED_INT, 0);
    glBindVertexArrayOES(0);
}

@end

//
//  GLWorld.m
//  OpenESRD
//
//  Created by wang yang on 2016/10/7.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLWorld.h"
#import "GLGeometry.h"
#import "GLLight.h"
#import "GLPlaneGeometry.h"

@interface GLWorld ()

@property (strong, nonatomic) NSMutableArray *geometrys;
@property (assign, nonatomic) GLKMatrix4 originViewProjection;
@property (weak, nonatomic) GLKView *glkView;

@property (strong, nonatomic) GLPlaneGeometry *projector;

@end

@implementation GLWorld

- (instancetype)initWithGLKView:(GLKView *)glkView {
    self = [super init];
    if (self) {

        self.glkView = glkView;

        CGSize size = glkView.bounds.size;

        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

        if (!self.context) {
            NSLog(@"Failed to create ES context");
        }

        glkView.context = self.context;
        glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;

        [EAGLContext setCurrentContext:self.context];
        glEnable(GL_DEPTH_TEST);

        float aspect = fabs(size.width / size.height);
        self.viewProjection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);

        self.viewProjection = GLKMatrix4Translate(self.viewProjection, 0, 0, -10.0f);
        self.originViewProjection = self.viewProjection;

        self.light = [GLLight new];
        self.lightViewProjection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
        self.lightViewProjection = GLKMatrix4Translate(self.lightViewProjection, self.light.position.x, self.light.position.y, self.light.position.z);
        [self createShadowFrameBuffer];

        self.geometrys = [NSMutableArray new];

        self.projector = [GLPlaneGeometry new];
        self.projector.world = self;
    }
    return self;
}

- (void)createShadowFrameBuffer {
    // create framebuffer
    GLuint framebuffer;
    GLuint renderbuffer;
    GLuint shadowTexture;

    glGenFramebuffers(1, &framebuffer);
    glGenRenderbuffers(1, &renderbuffer);
    glGenTextures(1, &shadowTexture);

    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, 1024, 1024);

    glBindTexture(GL_TEXTURE_2D, shadowTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 1024, 1024, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);

    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, shadowTexture, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, renderbuffer);

    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    self.shadowFramebuffer = framebuffer;
    self.shadowTexture = shadowTexture;
}

- (void)addGeometry:(GLGeometry *)geometry {
    geometry.world = self;
    [self.geometrys addObject:geometry];
}

- (void)render:(CGRect)rect {
    GLKMatrix4 projection = GLKMatrix4RotateX(self.originViewProjection, self.angleX);
    projection = GLKMatrix4RotateY(projection, self.angleY);
    self.viewProjection = projection;

    glBindFramebuffer(GL_FRAMEBUFFER, self.shadowFramebuffer);
    glClearColor(0.95f, 0.95f, 0.95f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    for (GLGeometry *geometry in self.geometrys) {
        geometry.viewProjection = self.viewProjection;
        geometry.lightViewProjection = self.lightViewProjection;
        geometry.renderAsShadow = YES;
        [geometry draw];
    }

    [self.glkView bindDrawable];
    glClearColor(0.95f, 0.95f, 0.95f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    for (GLGeometry *geometry in self.geometrys) {
        geometry.viewProjection = self.viewProjection;
        geometry.lightViewProjection = self.lightViewProjection;
        geometry.renderAsShadow = NO;
        geometry.material.shadowMap = self.shadowTexture;
        [geometry draw];
    }

    self.projector.viewProjection = GLKMatrix4MakeOrtho(-rect.size.width / 2, rect.size.width / 2, -rect.size.height / 2, rect.size.height / 2, -1.0, 100.0f);
    self.projector.viewProjection = GLKMatrix4Translate(self.projector.viewProjection, -rect.size.width / 2 + 50, rect.size.height / 2 - 50, 1);
    self.projector.viewProjection = GLKMatrix4Scale(self.projector.viewProjection, 100, 100, 1);
    self.projector.material.diffuseMap = self.shadowTexture;
    [self.projector draw];
}

- (void)update:(NSTimeInterval)interval {
    [self.light update:interval];
    for (GLGeometry *geometry in self.geometrys) {
        [geometry update:interval];
    }
    [self.projector update:interval];
}

@end

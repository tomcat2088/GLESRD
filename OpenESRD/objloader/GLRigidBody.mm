//
//  GLRigidBody.m
//  OpenESRD
//
//  Created by wangyang on 2016/10/18.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLRigidBody.h"
#import "btBulletDynamicsCommon.h"
#import "btBulletCollisionCommon.h"

@interface GLRigidBody () {
    btRigidBody *rigidBody;
}
@end

@implementation GLRigidBody
- (instancetype)initAsSphere:(float)radius mass:(float)mass geometry:(GLGeometry *)geometry
{
    self = [super init];
    if (self) {
        btCollisionShape *shape = new btSphereShape(1.0);
        shape->setUserPointer((__bridge void *)self);
        btDefaultMotionState *motionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,12,0)));
        btVector3 fallInertia(0,0,0);
        shape->calculateLocalInertia(mass, fallInertia);
        
        rigidBody = new btRigidBody(mass,motionState,shape,fallInertia);
        rigidBody->setRestitution(.4);
        self.geometry = geometry;
    }
    return self;
}

- (instancetype)initAsStaticPlane:(float)size geometry:(GLGeometry *)geometry
{
    self = [super init];
    if (self) {
        btCollisionShape *shape = new btStaticPlaneShape(btVector3(0,1,0),1);
        shape->setUserPointer((__bridge void *)self);
        btDefaultMotionState *motionState = new btDefaultMotionState(btTransform(btQuaternion(btVector3(1,0,0),0.0 *M_PI / 180.0),btVector3(0,-1,0)));
        rigidBody = new btRigidBody(0,motionState,shape,btVector3(0,0,0));
        rigidBody->setRestitution(1);
        self.geometry = geometry;
    }
    return self;
}

- (btRigidBody *)rigidBody {
    return rigidBody;
}
@end

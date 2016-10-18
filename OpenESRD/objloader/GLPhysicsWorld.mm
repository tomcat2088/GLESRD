//
//  GLPhysicsWorld.m
//  OpenESRD
//
//  Created by wangyang on 2016/10/18.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "GLPhysicsWorld.h"
#import "btBulletDynamicsCommon.h"
#import "btBulletCollisionCommon.h"

#import "GLGeometry.h"

@interface GLPhysicsWorld () {
    btDiscreteDynamicsWorld *world;
    btCollisionConfiguration *configration;
    btCollisionDispatcher *dispatcher;
    btSequentialImpulseConstraintSolver *solver;
    btBroadphaseInterface *broadphase;
}

@end

@implementation GLPhysicsWorld

- (instancetype)init
{
    self = [super init];
    if (self) {
        configration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(configration);
        solver = new btSequentialImpulseConstraintSolver();
        broadphase = new btDbvtBroadphase();
        
        world = new btDiscreteDynamicsWorld(dispatcher,broadphase,solver,configration);
        
        world->setGravity(btVector3(0,-1,0));
        world->addRigidBody([self createRigidbody:1]);
    }
    return self;
}

- (btRigidBody *)createRigidbody:(btScalar)mass {
    btCollisionShape *shape = new btSphereShape(2.0);
    btDefaultMotionState *motionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,0,0)));
    btVector3 fallInertia(0,0,0);
    shape->calculateLocalInertia(mass, fallInertia);
    
    btRigidBody *rigidBody = new btRigidBody(mass,motionState,shape,fallInertia);
    return rigidBody;
}

- (void)update:(NSTimeInterval)interval {
    world->stepSimulation(interval);
}

@end

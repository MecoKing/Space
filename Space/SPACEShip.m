//
//  SPACEShip.m
//  Space
//
//  Created by [pixelmonster] on 2/3/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEShip.h"
#import "SPACEFunction.h"
#import "SPACEMyScene.h"
#import "SPACEProjectile.h"

@implementation SPACEShip

-(instancetype)initWithImageNamed:(NSString *)name {
    if ((self = [super initWithImageNamed:name])) {
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
        self.physicsBody.friction = 0;
        self.physicsBody.angularDamping = 0;
        self.physicsBody.mass = 100;
        self.texture.filteringMode = SKTextureFilteringNearest;
        self.angularMagnitude = 10;
        self.linearMagnitude = 10000;
        self.allegiance = SPACERandomIntegerInInterval(1, 5);
        
//        [self activateThrusters];
        //Eventually Have the spaceship texture based on allegiance
    }
    return self;
}

+(instancetype) shipWithImageNamed: (NSString*)imageName {
    return [[self alloc] initWithImageNamed:imageName];
}


@dynamic scene;


-(void) releaseDirectionalThrusters {
    self.physicsBody.angularVelocity = 0;
}

-(void) activateDirectionalThrustersRight {
    [self.physicsBody applyTorque:-self.angularMagnitude];
}

-(void) activateDirectionalThrustersLeft {
    [self.physicsBody applyTorque:self.angularMagnitude];
}

-(void) activateThrusters {
    CGVector force = (CGVector){
        .dx = -sin(self.zRotation) * self.linearMagnitude,
        .dy = cos(self.zRotation) * self.linearMagnitude,
    };
    [self.physicsBody applyForce:force];
}

-(void) fireLaser {
	SPACEProjectile *laser = [SPACEProjectile laserOriginatingFromNode:self];
    [self.scene.laserManager addChild:laser];
    [laser.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = self.zRotation, .r = self.linearMagnitude })];
}

-(void) fireMissileAtPoint: (CGPoint)destination {
	CGPoint relativePoint = SPACESubtractPoint(destination, self.position);
    CGFloat firingAngle = SPACEPolarPointWithPoint(relativePoint).phi - M_PI_2;
	
	SPACEProjectile *missile = [SPACEProjectile missileOriginatingFromNode:self];
	[self.scene.laserManager addChild:missile];
	missile.zRotation = firingAngle;
	[missile.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = firingAngle, .r = self.linearMagnitude })];
}


-(void) runAutoPilot {
    [self releaseDirectionalThrusters];
    
    SPACEMyScene *scene = (SPACEMyScene*)self.scene;
    if (true) {
        [self huntShip:scene.playerShip];
    }
}

-(void) huntShip: (SPACEShip*) ship {
    [self goToPoint:ship.position];
    if (self.currentAngle > (self.angleToFace - 0.1) && self.currentAngle < (self.angleToFace + 0.1)) {
        [self fireLaser];
    }
    if (SPACERandomIntegerInInterval(1, 1000) == 1) {
        [self fireMissileAtPoint:ship.position];
    }
}

-(void) goToPoint: (CGPoint) destination {
    self.relativePoint = SPACESubtractPoint(destination, self.position);
    self.angleToFace = SPACEPolarPointWithPoint(self.relativePoint).phi;
    self.currentAngle = self.zRotation + M_PI_2;
    if (self.currentAngle < (self.angleToFace - 0.2)) {
        [self activateDirectionalThrustersLeft];
    }
    else if (self.currentAngle > (self.angleToFace + 0.2)) {
        [self activateDirectionalThrustersRight];
    }
    else {
        [self activateThrusters];
    }
}

@end

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
    SKSpriteNode *laser = [SKSpriteNode spriteNodeWithImageNamed:@"Laser"];
    laser.position = self.position;//Just in front of the spaceship
    laser.zRotation = self.zRotation;
    SPACEMyScene *scene = (SPACEMyScene*)self.scene;
    [scene.laserManager addChild:laser];
    laser.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:0.1];
    laser.physicsBody.mass = 1;
    CGVector force = (CGVector){
        .dx = -sin(laser.zRotation) * self.linearMagnitude,
        .dy = cos(laser.zRotation) * self.linearMagnitude,
    };
    [laser.physicsBody applyForce:force];
}
-(void) fireMissileAtPoint: (CGPoint)destination {
    CGPoint relativePoint = SPACESubtractPoint(destination, self.position);
    CGFloat firingAngle = SPACEPolarPointWithPoint(relativePoint).phi;
    
    SKSpriteNode *missile = [SKSpriteNode spriteNodeWithImageNamed:@"Missile"];
    missile.position = self.position;//Just in front of the spaceship
    missile.zRotation = firingAngle;
    SPACEMyScene *scene = (SPACEMyScene*)self.scene;
    [scene.laserManager addChild:missile];
    missile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:0.1];
    missile.physicsBody.mass = 10;
    CGVector force = (CGVector){
        .dx = -sin(missile.zRotation) * self.linearMagnitude,
        .dy = cos(missile.zRotation) * self.linearMagnitude,
    };
    [missile.physicsBody applyForce:force];
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

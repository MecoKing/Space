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
    laser.position = self.position;
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


-(void) runAutoPilot {
    NSUInteger action = SPACERandomIntegerInInterval(1, 100);
    if (action <= 30) {
        [self activateDirectionalThrustersRight];
    }
    else if (action <= 60) {
        [self activateDirectionalThrustersLeft];
    }
    else if (action <= 90) {
        [self activateThrusters];
        [self releaseDirectionalThrusters];
    }
    else {
        [self fireLaser];
        [self releaseDirectionalThrusters];
    }
}

-(void) chaseShip: (SPACEShip*) ship {
    //if (!facing ship)
    //    if (left of ship)
    //        [self activateDirectionalThrustersLeft];
    //    if (right of ship)
    //        [self activateDirectionalThrustersLeft];
    //else
    //    [self activateThrusters];
    //    [self releaseDirectionalThrusters];
    //    if (close to ship)
    //        [self fireLaser];
}

@end

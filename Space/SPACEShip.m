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
        self.angularMagnitude = 10;
        self.linearMagnitude = 10000;
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

//Ships should do different things based on type
//Allied Fighter - patrol area, attack Enemy fighters
//Neutral Fighter - Stalk Allied fighters, If no Allies around attack Neutral fighters
//Rogue Fighters - Stalk Enemy fighters, Defend against anyship that attacks
//
//Should Also
//Hide behind Planets, Stars, etc. when weak
//Team up with other ships of its type
//
//W key - Move forward based on direction
//A key - Rotate left
//S key - Move backward based on direction
//D key - Rotate right
//SPACE - Fire turrets based on mouse location
//SHIFT - Enter stealth mode
//LEFTMOUSE - Fire cannons from front of ship
//RIGHTMOUSE - Fire missiles from front of ship, arc towards mouse location

@end

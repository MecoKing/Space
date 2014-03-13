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

-(instancetype)init {
    if ((self = [super init])) {
        _node = [SKSpriteNode spriteNodeWithImageNamed:@"RebelFighter"];
        _node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
        _node.physicsBody.friction = 0;
        _node.physicsBody.angularDamping = 0;
        _node.physicsBody.mass = 100;
        self.angularMagnitude = 10;
        self.linearMagnitude = 10000;
    }
    return self;
}

+(instancetype) shipWithImageNamed: (NSString*)imageName {
    SPACEShip *ship = [SPACEShip new];
    //Check SPACEShip.h for more information
    //ship.node = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    return ship;
}


-(void) activateDirectionalThrustersRight {
    [self.node.physicsBody applyTorque:-self.angularMagnitude];
}
-(void) activateDirectionalThrustersLeft {
    [self.node.physicsBody applyTorque:self.angularMagnitude];
}
-(void) activateThrusters {
    CGVector force = (CGVector){
        .dx = -sin(self.node.zRotation) * self.linearMagnitude,
        .dy = cos(self.node.zRotation) * self.linearMagnitude,
    };
    [self.node.physicsBody applyForce:force];
}
-(void) fireLaser {
    SKSpriteNode *laser = [SKSpriteNode spriteNodeWithImageNamed:@"Laser"];
    laser.position = self.node.position;
    laser.zRotation = self.node.zRotation;
    SPACEMyScene *scene = (SPACEMyScene*)self.node.scene;
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
    if (action <= 20) {
        [self activateDirectionalThrustersRight];
    }
    else if (action <= 40) {
        [self activateDirectionalThrustersLeft];
    }
    else if (action <= 90) {
        [self activateThrusters];
        self.angularMagnitude = 0;
    }
    else {
        [self fireLaser];
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

//
//  SPACEShip.m
//  Space
//
//  Created by [pixelmonster] on 2/3/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEShip.h"
#import "SPACEFunction.h"

@implementation SPACEShip

-(instancetype)init {
    if ((self = [super init])) {
        _node = [SKSpriteNode spriteNodeWithImageNamed:@"RazorFighter"];
        _node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
        _node.physicsBody.friction = 0;
        _node.physicsBody.angularDamping = 0;
        _node.physicsBody.mass = 100;
    }
    return self;
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

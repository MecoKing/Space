//
//  SPACEShip.m
//  Space
//
//  Created by [pixelmonster] on 2/3/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEShip.h"

static inline CGFloat SPACERandomInInterval(CGFloat from, CGFloat to) {
    CGFloat value = ((CGFloat)random()) / (CGFloat)RAND_MAX;
    return value * fabs(to - from) + from;
}

@implementation SPACEShip

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

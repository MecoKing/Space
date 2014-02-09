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
//Human Fighter - patrol area, attack alien and rogue fighters
//Alien Fighter - Stalk Human Fighters, If no humans around attack Rogue Fighters
//Rogue Fighters - Stalk Human Fighters, If no humans around attack Alien Fighters
//
//Should Also
//Hide behind Planets, Stars, etc. when weak
//Team up with other ships of its type
//
//W key - Move forward based on direction
//A key - Rotate left
//S key - Move backward based on direction
//D key - Rotate right
//SPACE - Fire lasers based on mouse location
//SHIFT - Enter stealth mode

@end

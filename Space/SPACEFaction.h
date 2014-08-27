//
//  SPACEFaction.h
//  Space
//
//  Created by [pixelmonster] on 2014-05-31.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEShip;

@interface SPACEFaction : SKNode

@property SPACEShip *fighterShip;
@property SKColor *shipColour;
@property NSString *wingSpriteName;
@property NSString *hullSpriteName;
@property NSString *thrusterSpriteName;
@property NSString *priority;
@property NSArray *ships;

+(instancetype) randomFaction;
@end

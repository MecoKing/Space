//
//  SPACEFaction.h
//  Space
//
//  Created by [pixelmonster] on 2014-05-31.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEShip;
@class SPACEShipPart;

@interface SPACEFaction : SKNode

@property SPACEShip *fighterShip;
@property SKColor *shipColour;
@property SPACEShipPart *wingPart;
@property SPACEShipPart *hullPart;
@property SPACEShipPart *thrusterPart;
@property NSString *priority;
@property NSArray *ships;

+(instancetype) randomFaction;
@end

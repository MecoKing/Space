//
//  SPACEStat.h
//  Space
//
//  Created by [pixelmonster] on 2014-08-22.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEShip;
@class SPACEPlanet;

@interface SPACEStat : SKNode

@property SKLabelNode *title;
@property SKLabelNode *info;
@property SKSpriteNode *healthBar;

@property SPACEShip *shipObject;
@property SPACEPlanet *planetObject; //To be used in the future...


+(instancetype) statsForShip:(SPACEShip*)ship;
-(void) updateAllShipStats;

@end

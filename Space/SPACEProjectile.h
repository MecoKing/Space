//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import <SpriteKit/SpriteKit.h>
#import "SPACEDefines.h"

@class SPACEFaction;
@class SPACEMyScene;
@class SPACEShip;

@interface SPACEProjectile : SKSpriteNode

+(instancetype)missileOriginatingFromShip:(SPACEShip *)ship;
+(instancetype)laserOriginatingFromShip:(SPACEShip *)ship;

@property (nonatomic, readonly) SPACEMyScene *scene;
@property SPACEFaction* faction;

@end

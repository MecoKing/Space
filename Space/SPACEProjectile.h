//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import <SpriteKit/SpriteKit.h>
#import "SPACEDefines.h"

@class SPACEFaction;

@interface SPACEProjectile : SKSpriteNode

+(instancetype)missileOriginatingFromNode:(SKNode *)node;
+(instancetype)laserOriginatingFromNode:(SKNode *)node;

@property SPACEFaction* faction;

@end

//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import <SpriteKit/SpriteKit.h>
#import "SPACEDefines.h"

@class SPACEFaction;
@class SPACEMyScene;

@interface SPACEProjectile : SKSpriteNode

+(instancetype)missileOriginatingFromNode:(SKNode *)node withFaction:(SPACEFaction*)faction;
+(instancetype)laserOriginatingFromNode:(SKNode *)node withFaction:(SPACEFaction*)faction;

@property (nonatomic, readonly) SPACEMyScene *scene;
@property SPACEFaction* faction;

@end

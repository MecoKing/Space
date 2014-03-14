//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import <SpriteKit/SpriteKit.h>

@interface SPACEProjectile : SKSpriteNode

+(instancetype)missileOriginatingFromNode:(SKNode *)node;
+(instancetype)laserOriginatingFromNode:(SKNode *)node;

@end

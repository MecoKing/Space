//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEStellarBody.h"

@class SPACESystem;

@interface SPACEPlanet : SPACEStellarBody

+(instancetype)randomMoon;
+(instancetype)randomTerrestrialPlanet;
+(instancetype)randomMoltenPlanet;
+(instancetype)randomGasGiant;

@property SKSpriteNode *shadow;
@property (readonly) SKTexture *texture;

@end

//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEStellarBody.h"

@class SPACESystem;
@class SPACEMyScene;

@interface SPACEPlanet : SPACEStellarBody

+(instancetype)randomMoon;
+(instancetype)randomTerrestrialPlanet;
+(instancetype)randomMoltenPlanet;
+(instancetype)randomGasGiant;

@property (readonly) SPACEMyScene *myScene;
@property SKSpriteNode *shadow;
@property (readonly) SKTexture *texture;

@end

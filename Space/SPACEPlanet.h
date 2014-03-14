//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEStellarBody.h"

@interface SPACEPlanet : SPACEStellarBody

+(instancetype)randomMoon;
+(instancetype)randomTerrestrialPlanet;
+(instancetype)randomGasGiant;

@property (readonly) SKTexture *texture;

@end

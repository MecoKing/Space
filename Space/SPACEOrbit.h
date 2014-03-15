//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEFunction.h"

@interface SPACEOrbit : NSObject

+(instancetype)orbitWithRadius:(CGFloat)radius azimuth:(CGFloat)azimuth period:(CFTimeInterval)period;

@property (readonly) CFTimeInterval period;

@property (readonly) SPACEPolarPoint currentPosition;

@property (readonly) CGFloat rate;

-(SPACEPolarPoint)updatePositionOverInterval:(CFTimeInterval)time;

@end

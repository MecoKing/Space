//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEOrbit.h"

@implementation SPACEOrbit

+(instancetype)orbitWithRadius:(CGFloat)radius azimuth:(CGFloat)azimuth period:(CFTimeInterval)period {
	return [[self alloc] initWithRadius:radius azimuth:azimuth period:period];
}

-(instancetype)initWithRadius:(CGFloat)radius azimuth:(CGFloat)azimuth period:(CFTimeInterval)period {
	if ((self = [super init])) {
		_period = period;
		
		_currentPosition = (SPACEPolarPoint){ .r = radius, .phi = azimuth };
	}
	return self;
}


-(CGFloat)rate {
	return (2 * M_PI) / self.period;
}

-(SPACEPolarPoint)updatePositionOverInterval:(CFTimeInterval)time {
	_currentPosition.phi = remainder(_currentPosition.phi + self.rate * time, 2 * M_PI);
	
	return self.currentPosition;
}

@end

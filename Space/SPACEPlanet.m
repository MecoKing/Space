//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEPlanet.h"
#import "SPACEFunction.h"

@implementation SPACEPlanet

+(instancetype)randomMoon {
	SPACEPlanet *planet = [self bodyWithRadius:SPACERandomInInterval(5, 15) mass:SPACERandomInInterval(1e15, 1e23) colour:SPACEAverageDarkColour() haloWidthRatio:0];
	planet.name = @"Moon";
	return planet;
}

+(instancetype)randomTerrestrialPlanet {
	SPACEPlanet *planet = [self bodyWithRadius:SPACERandomInInterval(20, 50) mass:SPACERandomInInterval(2e23, 2e25) colour:SPACEAverageDarkColour() haloWidthRatio:SPACERandomInInterval(0, 0.15)];
	planet.name = @"Terrestrial";
	return planet;
}

+(instancetype)randomGasGiant {
	SPACEPlanet *planet = [self bodyWithRadius:SPACERandomInInterval(50, 100) mass:SPACERandomInInterval(1e25, 1e27) colour:SPACEAverageDarkColour() haloWidthRatio:SPACERandomInInterval(0, 0.2)];
	planet.name = @"Gas Giant";
	return planet;
}



@synthesize haloColour = _haloColour;

-(NSColor *)haloColour {
	return _haloColour ?: (_haloColour = [[self.colour blendedColorWithFraction:0.75 ofColor:[SKColor colorWithRed:0.73 green:0.81 blue:1 alpha:1]] colorWithAlphaComponent:0.25]);
}

@end

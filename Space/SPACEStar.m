//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEStar.h"
#import "SPACEFunction.h"

@implementation SPACEStar

+(CGFloat)haloWidthRatio {
	return SPACERandomInInterval(0.3, 0.45);
}

+(instancetype)randomSuperGiant {
	SPACEStar *star = [self bodyWithRadius:SPACERandomInInterval(400, 600) mass:SPACERandomInInterval(1.5e31, 2.2e31) colour:[SKColor colorWithRed:SPACERandomInInterval(0.75, 1) green:SPACERandomInInterval(0.45, 0.55) blue:0.2 alpha:1] haloWidthRatio:self.haloWidthRatio];
	star.name = @"Supergiant";
	return star;
}

+(instancetype)randomRedGiant {
	SPACEStar *star = [self bodyWithRadius:SPACERandomInInterval(250, 400) mass:SPACERandomInInterval(2.4e30, 3e30) colour:[SKColor colorWithRed:SPACERandomInInterval(0.5, 1) green:SPACERandomInInterval(0, 0.1) blue:SPACERandomInInterval(0, 0.1) alpha:1] haloWidthRatio:self.haloWidthRatio];
	star.name = @"Red Giant";
	return star;
}

+(instancetype)randomWhiteDwarf {
	SPACEStar *star = [self bodyWithRadius:SPACERandomInInterval(150, 250) mass:SPACERandomInInterval(2e30, 2.1e30) colour:[SKColor colorWithRed:SPACERandomInInterval(0.8, 1) green:SPACERandomInInterval(0.8, 1) blue:SPACERandomInInterval(0.8, 1) alpha:1] haloWidthRatio:self.haloWidthRatio];
	star.name = @"White Dwarf";
	return star;
}


@synthesize haloColour = _haloColour;

-(SKColor *)haloColour {
	return _haloColour ?: (_haloColour = [[self.colour blendedColorWithFraction:0.25 ofColor:[SKColor whiteColor]] colorWithAlphaComponent:0.75]);
}

@end

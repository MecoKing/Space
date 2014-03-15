//
//  SPACESystem.h
//  Space
//
//  Created by [pixelmonster] on 2/19/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEBarycentre.h"

@class SPACEOrbit;

@interface SPACESystem : SKNode <SPACEBarycentre>

+(instancetype)systemWithBarycentre:(SKNode<SPACEBarycentre> *)barycentre satellites:(NSArray *)satellites;

+(instancetype)randomSystem;

@property (readonly) SKNode<SPACEBarycentre> *barycentre; // the gravitational hub of the system. for a planetary system this will be the planet that the moons orbit; for a star system it would be the star(s) that the planets orbit
@property (readonly) NSArray *satellites; // systems which are satellites of this system

@property SPACEOrbit *orbit;

@end


// - star system (of various sizes/kinds)
	// - planetary systems orbiting them
// - binary star system

// - gas giant w/teensy moons

//
//  SPACESystem.h
//  Space
//
//  Created by [pixelmonster] on 2/19/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEStellarBody;

@interface SPACESystem : SKNode

+(instancetype)systemWithBarycentre:(SPACESystem *)barycentre satellites:(NSArray *)satellites;
+(instancetype)systemWithStellarBody:(SPACEStellarBody *)barycentre satellites:(NSArray *)satellites;

+(instancetype)randomSystem;

@property (readonly) SPACESystem *barycentre; // the gravitational hub of the system. for a planetary system this will be the planet that the moons orbit; for a star system it would be the star(s) that the planets orbit
@property (readonly) NSArray *satellites; // systems which are satellites of this system

@property (readonly) CGFloat barycentreRadius;
@property (readonly) CGFloat radius;

@end

// - star system (of various sizes/kinds)
    // - planetary systems orbiting them
// - binary star system

// - gas giant w/teensy moons

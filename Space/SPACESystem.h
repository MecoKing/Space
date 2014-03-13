//
//  SPACESystem.h
//  Space
//
//  Created by [pixelmonster] on 2/19/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPACESystem : SKNode

+(instancetype)randomSystem;

@end


@class SPACEStar;
@class SPACEPlanet;

@interface SPACEPlanetSystem : SPACESystem

-(instancetype)initWithPlanet:(SPACEPlanet *)planet moon:(SPACEPlanet *)moon;

@property (readonly) SPACEPlanet *planet;

@property (readonly) SPACEPlanet *moon;

@end



@interface SPACEStarSystem : SPACESystem

-(instancetype)initWithStar:(SPACEStar *)star planetSystem:(SPACEPlanetSystem *)planetSystem;

@property (readonly) SPACEStar *star;

@property (readonly) SPACEPlanetSystem *planetSystem;

@end

// - star system (of various sizes/kinds)
    // - planetary systems orbiting them
// - binary star system

// - gas giant w/teensy moons

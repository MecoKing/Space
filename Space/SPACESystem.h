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


@class SPACEStellarBody;

@interface SPACEPlanetSystem : SPACESystem

-(instancetype)initWithPlanet:(SPACEStellarBody *)planet moon:(SPACEStellarBody *)moon;

@property (readonly) SPACEStellarBody *planet;

@property (readonly) SPACEStellarBody *moon;

@end



@interface SPACEStarSystem : SPACESystem

-(instancetype)initWithStar:(SPACEStellarBody *)star planet:(SPACEPlanetSystem *)planet;

@property (readonly) SPACEStellarBody *star;

@property (readonly) SPACEPlanetSystem *planet;

@end

// - star system (of various sizes/kinds)
    // - planetary systems orbiting them
// - binary star system

// - gas giant w/teensy moons

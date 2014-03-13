//
//  SPACESystem.m
//  Space
//
//  Created by [pixelmonster] on 2/19/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEFunction.h"
#import "SPACESystem.h"
#import "SPACEStar.h"
#import "SPACEPlanet.h"
#import "SPACEMyScene.h"

@implementation SPACESystem

+(instancetype)randomSystem {
    return [SPACEStarSystem randomSystem];
}

@end

    
/*
SKLabelNode *planetCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
SKLabelNode *starCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
planetCountLabel.position = CGPointMake(self.frame.origin.x + 50, self.frame.origin.y + 20);
starCountLabel.position = CGPointMake(self.frame.origin.x + 50, self.frame.origin.y + 50);
planetCountLabel.fontColor = SPACEInverseOfColour(self.backgroundColor);
starCountLabel.fontColor = SPACEInverseOfColour(self.backgroundColor);
planetCountLabel.fontSize = 14;
starCountLabel.fontSize = 14;
planetCountLabel.text = [NSString stringWithFormat:@"Planets: %lu", (unsigned long)planetCount];
starCountLabel.text = [NSString stringWithFormat:@"Stars: %lu", (unsigned long)starCount];
[self addChild:planetCountLabel];
[self addChild:starCountLabel];
*/


@implementation SPACEStarSystem

+(instancetype)randomSystem {
    SEL selectors[] = {
        @selector(randomSuperGiant),
        @selector(randomRedGiant),
        @selector(randomWhiteDwarf),
    };
    SEL selector = selectors[SPACERandomIntegerInInterval(0, sizeof selectors / sizeof *selectors - 1)];
    
    return [[self alloc] initWithStar:[SPACEStar performSelector:selector withObject:nil] planetSystem:[SPACEPlanetSystem randomSystem]];
}

-(instancetype)initWithStar:(SPACEStar *)star planetSystem:(SPACEPlanetSystem *)planetSystem {
    if ((self = [super init])) {
        _star = star;
        _planetSystem = planetSystem;
        
//        self.anchorPoint = (CGPoint){ 0.5, 0.5 };
        star.position = (CGPoint){0};
        [self addChild:star];
        
        [self addChild:planetSystem];
    }
    return self;
}

@end

@implementation SPACEPlanetSystem

+(instancetype)randomSystem {
    SEL selectors[] = {
        @selector(randomGasGiant),
        @selector(randomTerrestrialPlanet),
    };
    SEL selector = selectors[SPACERandomIntegerInInterval(0, sizeof selectors / sizeof *selectors - 1)];
    
    return [[self alloc] initWithPlanet:[SPACEPlanet performSelector:selector withObject:nil] moon:[SPACEPlanet randomMoon]];
}

-(instancetype)initWithPlanet:(SPACEPlanet *)planet moon:(SPACEPlanet *)moon {
    if ((self = [super init])) {
        _planet = planet;
        _moon = moon;
        
//        self.anchorPoint = (CGPoint){ 0.5, 0.5 };
        planet.position = (CGPoint){0};
        [self addChild:planet];
        
        [self addChild:moon];
    }
    return self;
}

@end

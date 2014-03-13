//
//  SPACESystem.m
//  Space
//
//  Created by [pixelmonster] on 2/19/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEFunction.h"
#import "SPACESystem.h"
#import "SPACEStellarBody.h"
#import "SPACEMyScene.h"

@implementation SPACESystem

+(instancetype)randomSystem {
    return [SPACEStarSystem randomSystem];
}


-(void) generateSolarSystem {
    //    return;
    
    NSUInteger starCount = SPACERandomIntegerInInterval(1, 3);
    for (int i = 0; i < starCount; i++)
    {
        NSUInteger starType = SPACERandomIntegerInInterval(0, 4);
        if (starType == 0-1)
        {
            //system.addAWhiteDwarf
            //RandomPlanetCount(1-9)
            //for planetCount
            //  RandomPlanetType
            //  if 1-2
            //      star.addATerra
            //      RandomMoonCount(1-3)
            //      for moonCount
            //          terra.addAMoon
            //  if 3
            //      star.addAGasGiant
            //      RandomMoonCount(3-10)
            //      for moonCount
            //          RandomMoonType
            //          if 1-2
            //              gasGiant.addAMoon
            //          if 3
            //              gasGiant.addATerra
            //              RandomMoonCount(1-3)
            //              for moonCount
            //                  terra.addAMoon
        }
        else if (starType == 2)
        {
            //system.addARedGiant
            //RandomPlanetCount(4-12)
            //for planetCount
            //  RandomPlanetType
            //  if 1
            //      star.addATerra
            //      RandomMoonCount(1-3)
            //      for moonCount
            //          terra.addAMoon
            //  if 2
            //      star.addAGasGiant
            //      RandomMoonCount(3-10)
            //      for moonCount
            //          RandomMoonType
            //          if 1-2
            //              gasGiant.addAMoon
            //          if 3
            //              gasGiant.addATerra
            //              RandomMoonCount(1-3)
            //              for moonCount
            //                  terra.addAMoon
        }
        else if (starType == 3)
        {
            //system.addASupernova
            //RandomPlanetCount(8-16)
            //for planetCount
            //  RandomPlanetType
            //  if 1
            //      star.addATerra
            //      RandomMoonCount(1-3)
            //      for moonCount
            //          terra.addAMoon
            //  if 2-3
            //      star.addAGasGiant
            //      RandomMoonCount(3-10)
            //      for moonCount
            //          RandomMoonType
            //          if 1-2
            //              gasGiant.addAMoon
            //          if 3
            //              gasGiant.addATerra
            //              RandomMoonCount(1-3)
            //              for moonCount
            //                  terra.addAMoon
        }
    }
    
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
}


@end


@implementation SPACEStarSystem

+(instancetype)randomSystem {
    SEL selectors[] = {
        @selector(supernovaWithSize:),
        @selector(redGiantWithSize:),
        @selector(whiteDwarfWithSize:),
    };
    SEL selector = selectors[SPACERandomIntegerInInterval(0, sizeof selectors / sizeof *selectors - 1)];
    
    return [[self alloc] initWithStar:[SPACEStellarBody performSelector:selector withObject:nil] planet:[SPACEPlanetSystem randomSystem]];
}

-(instancetype)initWithStar:(SPACEStellarBody *)star planet:(SPACEPlanetSystem *)planet {
    if ((self = [super init])) {
        _star = star;
        _planet = planet;
        
//        self.anchorPoint = (CGPoint){ 0.5, 0.5 };
        star.position = (CGPoint){0};
        [self addChild:star.shape];
        
        [self addChild:planet];
    }
    return self;
}

@end

@implementation SPACEPlanetSystem

+(instancetype)randomSystem {
    CGSize fakeSize = (CGSize){ 1000, 1000 };
    SEL selectors[] = {
        @selector(gasPlanetWithSize:),
        @selector(terraPlanetWithSize:),
    };
    SEL selector = selectors[SPACERandomIntegerInInterval(0, sizeof selectors / sizeof *selectors - 1)];
    
    return [[self alloc] initWithPlanet:[SPACEStellarBody performSelector:selector withObject:nil] moon:[SPACEStellarBody moonWithSize:fakeSize]];
}

-(instancetype)initWithPlanet:(SPACEStellarBody *)planet moon:(SPACEStellarBody *)moon {
    if ((self = [super init])) {
        _planet = planet;
        _moon = moon;
        
//        self.anchorPoint = (CGPoint){ 0.5, 0.5 };
        planet.position = (CGPoint){0};
        [self addChild:planet.shape];
        
        [self addChild:moon.shape];
    }
    return self;
}

@end

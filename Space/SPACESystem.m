//
//  SPACESystem.m
//  Space
//
//  Created by [pixelmonster] on 2/19/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACESystem.h"
#import "SPACEStellarBody.h"
#import "SPACEMyScene.h"


static inline CGFloat SPACERandomInInterval(CGFloat from, CGFloat to) {
    CGFloat value = ((CGFloat)random()) / (CGFloat)RAND_MAX;
    return value * fabs(to - from) + from;
}

static inline NSUInteger SPACERandomIntegerInInterval(NSUInteger from, NSUInteger to) {
    return random() % (to - from + 1) + from;
}

static inline SKColor *SPACERandomColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0, 1) green:SPACERandomInInterval(0, 1) blue:SPACERandomInInterval(0, 1) alpha:1];
}

static inline SKColor *SPACERandomDarkColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0, 0.5) green:SPACERandomInInterval(0, 0.5) blue:SPACERandomInInterval(0, 0.5) alpha:1];
}

static inline SKColor *SPACEInverseOfColour(SKColor *colour) {
    return [SKColor colorWithRed: 1 - colour.redComponent green: 1 - colour.greenComponent blue: 1 - colour.blueComponent alpha:1];
}

static inline CGFloat SPACEFloatCloseToAverage (CGFloat baseColourComponent, CGFloat averageColourComponent){
    CGFloat baseAfterAveraging;
    if (baseColourComponent > averageColourComponent + 0.1)
        baseAfterAveraging = averageColourComponent + 0.1;
    else if (baseColourComponent < averageColourComponent - 0.1)
        baseAfterAveraging = averageColourComponent - 0.1;
    else
        baseAfterAveraging = baseColourComponent;
    
    return baseAfterAveraging;
}

static inline SKColor *SPACEAverageDarkColour () {
    SKColor *baseColour = SPACERandomDarkColour();
    CGFloat averageColour = (baseColour.redComponent + baseColour.blueComponent + baseColour.greenComponent) / 3;
    
    return [SKColor colorWithRed:SPACEFloatCloseToAverage(baseColour.redComponent, averageColour) green:SPACEFloatCloseToAverage(baseColour.greenComponent, averageColour) blue:SPACEFloatCloseToAverage(baseColour.blueComponent, averageColour) alpha:1];
}


@implementation SPACESystem

-(id)init {
    
    return  nil;
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

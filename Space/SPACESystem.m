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

+(instancetype)systemWithBarycentre:(SKNode<SPACEBarycentre> *)barycentre satellites:(NSArray *)satellites {
	return [[self alloc] initWithBarycentre:barycentre satellites:satellites];
}

-(instancetype)initWithBarycentre:(SKNode<SPACEBarycentre> *)barycentre satellites:(NSArray *)satellites {
	if ((self = [super init])) {
		if (barycentre) {
			_barycentre = barycentre;
			[self addChild:barycentre];
		}
		
		_satellites = [satellites copy];
		for (SPACESystem *satellite in satellites) {
			[self addChild:satellite];
			
			CGFloat min = self.barycentre.radius + satellite.radius * 2;
			SPACEPolarPoint polarPoint = (SPACEPolarPoint){
				.r = SPACERandomInInterval(min, min * 2),
				.phi = SPACERandomInInterval(0, 2 * M_PI),
			};
			satellite.position = SPACEPointWithPolarPoint(polarPoint);
            satellite.zRotation = SPACERandomInInterval(0, 2 * M_PI);
		}
		
		self.name = [self.barycentre.name stringByAppendingString:@" System"];
	}
	return self;
}

+(instancetype)smallPlanetarySystem {
	SEL selectors[] = {
        @selector(randomTerrestrialPlanet),
        @selector(randomMoltenPlanet),
    };
    SEL selector = selectors[SPACERandomIntegerInInterval(0, sizeof selectors / sizeof *selectors - 1)];
    
	NSMutableArray *moons = [NSMutableArray new];
	NSUInteger moonCount = SPACERandomIntegerInInterval(0, 3);
	for (NSUInteger i = 0; i < moonCount; i++) {
        [moons addObject:[self systemWithBarycentre:[SPACEPlanet randomMoon] satellites:@[]]];
	}
	
	return [self systemWithBarycentre:[SPACEPlanet performSelector:selector withObject:nil] satellites:moons];
}

+(instancetype)largePlanetarySystem {
	NSMutableArray *moons = [NSMutableArray new];
	NSUInteger moonCount = SPACERandomIntegerInInterval(2, 6);
	for (NSUInteger i = 0; i < moonCount; i++) {
        NSUInteger moonType = SPACERandomIntegerInInterval(0, 1);
        if (moonType == 0) {
            [moons addObject:[self smallPlanetarySystem]];
        }
        else {
            [moons addObject:[self systemWithBarycentre:[SPACEPlanet randomMoon] satellites:@[]]];
        }
    }
	
	return [self systemWithBarycentre:[SPACEPlanet randomGasGiant] satellites:moons];
}

+(instancetype)randomPlanetarySystem {
    NSUInteger planetarySystemType = SPACERandomIntegerInInterval(0, 1);
    if (planetarySystemType == 0) {
        return [self largePlanetarySystem];
    }
    else {
        return [self smallPlanetarySystem];
    }
}
    
+(instancetype)randomStarSystem {
	SEL selectors[] = {
        @selector(randomSuperGiant),
        @selector(randomRedGiant),
        @selector(randomWhiteDwarf),
    };
    SEL selector = selectors[SPACERandomIntegerInInterval(0, sizeof selectors / sizeof *selectors - 1)];
    
	NSMutableArray *planets = [NSMutableArray new];
	NSUInteger planetCount = SPACERandomIntegerInInterval(0, 5);
	for (NSUInteger i = 0; i < planetCount; i++) {
		[planets addObject:[self randomPlanetarySystem]];
	}
	
	return [self systemWithBarycentre:[SPACEStar performSelector:selector withObject:nil] satellites:planets];
}

+(instancetype)randomSystem {
    return [self randomStarSystem];
}


-(CGFloat)radius {
	CGFloat radius = self.barycentre.radius;
	for (SPACESystem *satellite in self.satellites) {
		radius = MAX(radius, SPACEMagnitudeOfPoint(satellite.position));
	}
	return radius;
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

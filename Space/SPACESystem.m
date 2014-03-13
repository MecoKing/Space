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

@interface SPACEBarycentreSystem : SPACESystem

-(instancetype)initWithStellarBody:(SPACEStellarBody *)body satellites:(NSArray *)satellites;

@end


@implementation SPACESystem

+(instancetype)systemWithBarycentre:(SPACESystem *)barycentre satellites:(NSArray *)satellites {
	return [[self alloc] initWithBarycentre:barycentre satellites:satellites];
}

+(instancetype)systemWithStellarBody:(SPACEStellarBody *)barycentre satellites:(NSArray *)satellites {
	return [[SPACEBarycentreSystem alloc] initWithStellarBody:barycentre satellites:satellites];
}

-(instancetype)initWithBarycentre:(SPACESystem *)barycentre satellites:(NSArray *)satellites {
	if ((self = [super init])) {
		if (barycentre) {
			_barycentre = barycentre;
			[self addChild:barycentre];
		}
		
		_satellites = [satellites copy];
		for (SPACESystem *satellite in satellites) {
			[self addChild:satellite];
			
			CGFloat min = satellite.radius + self.barycentreRadius;
			satellite.position = SPACEPointWithPolarPoint((SPACEPolarPoint){
				.r = SPACERandomInInterval(min, min * 2),
				.phi = SPACERandomInInterval(0, 2 * M_PI),
			});
		}
		
		self.name = [self.barycentre.name stringByAppendingString:@" System"];
	}
	return self;
}


+(instancetype)randomPlanetarySystem {
	SEL selectors[] = {
        @selector(randomGasGiant),
        @selector(randomTerrestrialPlanet),
    };
    SEL selector = selectors[SPACERandomIntegerInInterval(0, sizeof selectors / sizeof *selectors - 1)];
    
	NSMutableArray *moons = [NSMutableArray new];
	NSUInteger moonCount = SPACERandomIntegerInInterval(0, 5);
	for (NSUInteger i = 0; i < moonCount; i++) {
		[moons addObject:[self systemWithStellarBody:[SPACEPlanet randomMoon] satellites:@[]]];
	}
	
	return [self systemWithStellarBody:[SPACEPlanet performSelector:selector withObject:nil] satellites:moons];
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
	
	return [self systemWithStellarBody:[SPACEStar performSelector:selector withObject:nil] satellites:planets];
}

+(instancetype)randomSystem {
    return [self randomStarSystem];
}


-(CGFloat)barycentreRadius {
	return self.barycentre.radius;
}

-(CGFloat)radius {
	CGFloat radius = self.barycentreRadius;
	for (SPACESystem *satellite in self.satellites) {
		radius = MAX(radius, SPACEMagnitudeOfPoint(satellite.position));
	}
	return radius;
}

@end


@implementation SPACEBarycentreSystem {
	SPACEStellarBody *_body;
}

-(instancetype)initWithStellarBody:(SPACEStellarBody *)body satellites:(NSArray *)satellites {
	if ((self = [super initWithBarycentre:nil satellites:satellites])) {
		_body = body;
		[self addChild:body];
	}
	return self;
}


-(CGFloat)barycentreRadius {
	return _body.radius;
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

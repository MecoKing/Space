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
#import "SPACEOrbit.h"
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
			
			_barycentre.physicsBody.angularVelocity = SPACERandomInInterval(0.01, 0.3) * 2 * M_PI;
			
			[self addChild:barycentre];
		}
		
		_satellites = [satellites copy];
		for (SPACESystem *satellite in satellites) {
			[self addChild:satellite];
			
			CGFloat min = self.barycentre.radius + satellite.radius * 2;
			CGFloat radius = SPACERandomInInterval(min, min * 2);
			SPACEOrbit *orbit = [SPACEOrbit orbitWithRadius:radius azimuth:SPACERandomInInterval(0, 2 * M_PI) period:SPACERandomInInterval(1.0/5.0, 1.0/20.0) * radius];
			satellite.orbit = orbit;
			satellite.position = SPACEPointWithPolarPoint(orbit.currentPosition);
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
		NSUInteger moonType = SPACERandomIntegerInInterval(1, 4);
		if (moonType == 1) {
			[moons addObject:[self smallPlanetarySystem]];
		}
		else {
			[moons addObject:[self systemWithBarycentre:[SPACEPlanet randomMoon] satellites:@[]]];
		}
	}
	
	SPACESystem *system = [self systemWithBarycentre:[SPACEPlanet randomGasGiant] satellites:moons];
	system.barycentre.physicsBody.angularVelocity = 0; // gas giants oughtn’t rotate
	return system;
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
	NSUInteger planetCount = SPACERandomIntegerInInterval(1, 12);
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


#pragma mark SKBarycentre

-(void)updateWithSystem:(SPACESystem *)origin overInterval:(CFTimeInterval)time {
	[self.barycentre updateWithSystem:origin overInterval:time];
	
	self.position = SPACEPointWithPolarPoint([self.orbit updatePositionOverInterval:time]);
	
	for (SPACESystem *system in self.satellites) {
		[system updateWithSystem:origin overInterval:time];
	}
}

@end

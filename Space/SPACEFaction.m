//
//  SPACEFaction.m
//  Space
//
//  Created by [pixelmonster] on 2014-05-31.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEFaction.h"
#import "SPACEShip.h"
#import "SPACEShipPart.h"
#import "SPACEFunction.h"

@implementation SPACEFaction

+(instancetype) randomFaction {
	SPACEFaction *faction = [SPACEFaction new];
//	faction.fighterShip = [SPACEShip randomFighterWithColour:SPACERandomDarkColour()];
	faction.shipColour = SPACERandomColour();
	faction.name = [faction generateName];
	
	faction.wingPart = [SPACEShipPart randomWingPart];
	faction.hullPart = [SPACEShipPart randomHullPart];
	faction.thrusterPart = [SPACEShipPart randomThrusterPart];
	
	NSArray *possiblePriorities = @[
									@"Closest",
									@"Value",
									@"Rank",
									@"Health",
									];
	faction.priority = possiblePriorities[SPACERandomIntegerInInterval(0, possiblePriorities.count - 1)];
	
	return faction;
}

-(NSString*) generateName {
	NSArray *name1 = @[@"Nova",@"Alpha",@"Hydro",@"Solar",@"Aero",@"Astro",@"Delta"];
	NSArray *name2 = @[@"Plant",@"Branch",@"Core",@"Tech",@"Corp.",@"Base",@"Wing"];
	NSArray *jobType = @[@"Mining",@"Trade",@"Security",@"Privateer",@"Engineering",@"Research",@"Colonial"];
	NSArray *class = @[@"Federation",@"Corporation",@"District",@"Company",@"Alliance",@"Division",@"Systems"];
	return [NSString stringWithFormat:@"%@%@ %@ %@",
			name1[SPACERandomIntegerInInterval(0, 6)],
			name2[SPACERandomIntegerInInterval(0, 6)],
			jobType[SPACERandomIntegerInInterval(0, 6)],
			class[SPACERandomIntegerInInterval(0, 6)]];
}

-(void) generateShips {
	for (int i = 0; i < SPACERandomIntegerInInterval(4, 8); i++) {
		[self.ships arrayByAddingObject:[SPACEShip randomFighterOfFaction:self]];
	}
}

@end

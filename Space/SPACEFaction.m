//
//  SPACEFaction.m
//  Space
//
//  Created by [pixelmonster] on 2014-05-31.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEFaction.h"
#import "SPACEShip.h"
#import "SPACEFunction.h"

@implementation SPACEFaction

+(instancetype) randomFaction {
	SPACEFaction *faction = [SPACEFaction new];
//	faction.fighterShip = [SPACEShip randomFighterWithColour:SPACERandomDarkColour()];
	faction.shipColour = SPACERandomColour();
	faction.name = [faction generateName];

	NSArray *hullImages = @[@"SingleHull",@"NeedleHull",@"SplitHull",@"MantaHull",@"CoPilotHull",];
	NSArray *wingImages = @[@"HawkWings",@"SlicerWings",@"ZipperWings",@"DualWings",@"RocketWings",];
	NSArray *thrustImages = @[@"IonThruster",@"TwinIonThruster",@"TwinFusionThruster",@"TriFusionThruster",@"TwinElectronThruster",];
	//Eventually different parts will have different stats (Weight, Speed, Durability, Value)
	
	faction.wingSpriteName = wingImages[SPACERandomIntegerInInterval(0, 4)];
	faction.hullSpriteName = hullImages[SPACERandomIntegerInInterval(0, 4)];
	faction.thrusterSpriteName = thrustImages[SPACERandomIntegerInInterval(0, 4)];
	
	NSArray *possiblePriorities = @[
									@"Closest",
									@"Value",
									@"Rank",
									@"Nothing",
									];
	faction.priority = possiblePriorities[SPACERandomIntegerInInterval(0, possiblePriorities.count - 1)];
	
	return faction;
}

-(NSString*) generateName {
	NSArray *name1 = @[@"Nova",@"Alpha",@"Hydro",@"Solar",@"Aero",@"Astro"];
	NSArray *name2 = @[@"plant",@"branch",@"core",@"tech",@"corp.",@"base"];
	NSArray *jobType = @[@"Mining",@"Trade",@"Security",@"Privateer",@"Engineering",@"Research"];
	NSArray *class = @[@"Federation",@"Corporation",@"District",@"Company",@"Alliance",@"Division"];
	return [NSString stringWithFormat:@"%@%@ %@ %@",
			name1[SPACERandomIntegerInInterval(0, 5)],
			name2[SPACERandomIntegerInInterval(0, 5)],
			jobType[SPACERandomIntegerInInterval(0, 5)],
			class[SPACERandomIntegerInInterval(0, 5)]];
}

-(void) generateShips {
	for (int i = 0; i < SPACERandomIntegerInInterval(4, 8); i++) {
		[self.ships arrayByAddingObject:[SPACEShip randomFighterOfFaction:self]];
	}
}

@end

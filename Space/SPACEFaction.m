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
	
	NSArray *hullImages = @[
		@"SingleHull",
		@"NeedleHull",
		@"SplitHull",
		@"MantaHull",
		@"CoPilotHull",
	];
	NSArray *wingImages = @[
		@"HawkWings",
		@"SlicerWings",
		@"ZipperWings",
		@"DualWings",
		@"RocketWings",
	];
	NSArray *thrustImages = @[
		@"IonThruster",
		@"TwinIonThruster",
		@"TwinFusionThruster",
		@"TriFusionThruster",
		@"TwinElectronThruster",
	];
	//Eventually different parts will have different stats (Weight, Speed, Durability, Value)
	
	faction.wingSpriteName = wingImages[SPACERandomIntegerInInterval(0, 4)];
	faction.hullSpriteName = hullImages[SPACERandomIntegerInInterval(0, 4)];
	faction.thrusterSpriteName = thrustImages[SPACERandomIntegerInInterval(0, 4)];
	
	
	return faction;
}

@end

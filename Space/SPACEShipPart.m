//
//  SPACEShipPart.m
//  Space
//
//  Created by [pixelmonster] on 2014-12-18.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEShipPart.h"
#import "SPACEFunction.h"

@implementation SPACEShipPart

+(instancetype) randomWingPart {
	SPACEShipPart *wingPart = [SPACEShipPart new];
	NSArray *wingImages = @[@"HawkWings",@"SlicerWings",@"ZipperWings",@"DualWings",@"RocketWings",];
	wingPart.spriteName = wingImages [SPACERandomIntegerInInterval(0, 4)];
	wingPart.name = [wingPart generateNameForPart:@"Wings"];
	wingPart.value = SPACERandomIntegerInInterval(10, 100);
	return wingPart;
}

+(instancetype) randomHullPart {
	SPACEShipPart *hullPart = [SPACEShipPart new];
	NSArray *hullImages = @[@"SingleHull",@"NeedleHull",@"SplitHull",@"MantaHull",@"CoPilotHull",];
	hullPart.spriteName = hullImages [SPACERandomIntegerInInterval(0, 4)];
	hullPart.name = [hullPart generateNameForPart:@"Hull"];
	hullPart.value = SPACERandomIntegerInInterval(10, 100);
	return hullPart;
}

+(instancetype) randomThrusterPart {
	SPACEShipPart *thrusterPart = [SPACEShipPart new];
	NSArray *thrusterImages = @[@"IonThruster",@"TwinIonThruster",@"TwinFusionThruster",@"TriFusionThruster",@"TwinElectronThruster",];
	thrusterPart.spriteName = thrusterImages [SPACERandomIntegerInInterval(0, 4)];
	thrusterPart.name = [thrusterPart generateNameForPart:@"Thruster"];
	thrusterPart.value = SPACERandomIntegerInInterval(10, 100);
	return thrusterPart;
}

-(NSString*) generateNameForPart: (NSString*)part {
	NSArray *inventor = @[@"Ptolemy",@"Galilean",@"Kepler",@"Newtonian",@"Goddard's",@"Hubble",@"Kapteyn"];
	NSArray *hullAtrib = @[@"Nano",@"Carbon",@"Exo",@"Stealth",@"Lunar",@"Astro",@"Mega"];
	NSArray *hullModel = @[@"Shuttle",@"Tube",@"Capsule",@"Shell",@"Tank",@"Carrier",@"Rig"];
	NSArray *wingAtrib = @[@"Ultralight ",@"Reinforced ",@"Stealth",@"Aero",@"Astro",@"Dactyl",@"Hydro"];
	NSArray *wingModel = @[@"Falcon",@"Eagle",@"Hawk",@"Jet",@"Strike",@"Splitter",@"Cutter"];
	NSArray *thrusterAtrib = @[@"Light",@"Hyper",@"Ion",@"Plasma",@"Nucleo",@"UV ",@"Electron"];
	NSArray *thrusterModel = @[@"Drive",@"Engine",@"Rocket",@"Repulsor",@"Pulsar",@"Reactor",@"Emitter"];
	
	if ([part isEqual: @"Hull"]) {
		return [NSString stringWithFormat:(@"%@ %@%@"),
				inventor [SPACERandomIntegerInInterval(0, 6)],
				hullAtrib [SPACERandomIntegerInInterval(0, 6)],
				hullModel [SPACERandomIntegerInInterval(0, 6)]
				];
	}
	else if ([part isEqual: @"Wings"]) {
		return [NSString stringWithFormat:(@"%@ %@%@ Wings"),
				inventor [SPACERandomIntegerInInterval(0, 6)],
				wingAtrib [SPACERandomIntegerInInterval(0, 6)],
				wingModel [SPACERandomIntegerInInterval(0, 6)]
				];
	}
	else if ([part isEqual: @"Thruster"]) {
		return [NSString stringWithFormat:(@"%@ %@%@"),
				inventor [SPACERandomIntegerInInterval(0, 6)],
				thrusterAtrib [SPACERandomIntegerInInterval(0, 6)],
				thrusterModel [SPACERandomIntegerInInterval(0, 6)]
				];
	}
	else {
		return @"UNKNOWN MYSTERY PART";
	}
}

@end

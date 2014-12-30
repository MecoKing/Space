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
	wingPart.name = [wingPart generateNameForPart:@"Wings"];
	wingPart.value = SPACERandomIntegerInInterval(10, 100);
	CGPathRef wingPath = [wingPart newGeneratedWings];
	wingPart.shape = wingPath;
	CGPathRelease(wingPath);
	return wingPart;
}

+(instancetype) randomHullPart {
	SPACEShipPart *hullPart = [SPACEShipPart new];
	hullPart.name = [hullPart generateNameForPart:@"Hull"];
	hullPart.value = SPACERandomIntegerInInterval(10, 100);
	CGPathRef hullPath = [hullPart newGeneratedHull];
	hullPart.shape = hullPath;
	CGPathRelease(hullPath);
	return hullPart;
}

+(instancetype) randomThrusterPart {
	SPACEShipPart *thrusterPart = [SPACEShipPart new];
	thrusterPart.name = [thrusterPart generateNameForPart:@"Thruster"];
	thrusterPart.value = SPACERandomIntegerInInterval(10, 100);
	CGPathRef thrusterPath = [thrusterPart newGeneratedThruster];
	thrusterPart.shape = thrusterPath;
	CGPathRelease(thrusterPath);
	return thrusterPart;
}

-(CGPathRef) newGeneratedHull {
	CGPoint PointA = CGPointMake(0, SPACERandomInInterval(5, 10));
	CGPoint PointB = CGPointMake(SPACERandomInInterval(0, 12), SPACERandomInInterval(0, PointA.y));
	CGPoint PointC = CGPointMake(SPACERandomInInterval(0, 14), SPACERandomInInterval(-5, PointB.y));
	CGPoint PointD = CGPointMake(0, SPACERandomInInterval(-10, PointC.y));
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, PointA.x, PointA.y);
	CGPathAddLineToPoint(path, NULL, PointB.x, PointB.y);
	CGPathAddLineToPoint(path, NULL, PointC.x, PointC.y);
	CGPathAddLineToPoint(path, NULL, PointD.x, PointD.y);
	CGPathAddLineToPoint(path, NULL, -PointC.x, PointC.y);
	CGPathAddLineToPoint(path, NULL, -PointB.x, PointB.y);
	CGPathAddLineToPoint(path, NULL, PointA.x, PointA.y);
	
	return path;
}

-(CGPathRef) newGeneratedWings {
	CGPoint PointA = CGPointMake(0, SPACERandomInInterval(12, 16));
	CGPoint PointB = CGPointMake(SPACERandomInInterval(0, 16), SPACERandomInInterval(8, PointA.y));
	CGPoint PointC = CGPointMake(SPACERandomInInterval(0, 18), SPACERandomInInterval(0, PointB.y));
	CGPoint PointD = CGPointMake(SPACERandomInInterval(0, 20), SPACERandomInInterval(-8, PointC.y));
	CGPoint PointE = CGPointMake(0, SPACERandomInInterval(-16, PointD.y));
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, PointA.x, PointA.y);
	CGPathAddLineToPoint(path, NULL, PointB.x, PointB.y);
	CGPathAddLineToPoint(path, NULL, PointC.x, PointC.y);
	CGPathAddLineToPoint(path, NULL, PointD.x, PointD.y);
	CGPathAddLineToPoint(path, NULL, PointE.x, PointE.y);
	CGPathAddLineToPoint(path, NULL, -PointD.x, PointD.y);
	CGPathAddLineToPoint(path, NULL, -PointC.x, PointC.y);
	CGPathAddLineToPoint(path, NULL, -PointB.x, PointB.y);
	CGPathAddLineToPoint(path, NULL, PointA.x, PointA.y);
	
	return path;
}

-(CGPathRef) newGeneratedThruster {
	CGSize thrusterSize = CGSizeMake(SPACERandomInInterval(4, 6), SPACERandomInInterval(8, 12));
	CGRect thrusterRect = CGRectMake(-(thrusterSize.width / 2), SPACERandomInInterval(-16, -20), thrusterSize.width, thrusterSize.height);
	CGPathRef path = CGPathCreateWithRect(thrusterRect, NULL);
	CGMutablePathRef mutablePath = CGPathCreateMutableCopy(path);
	return mutablePath;
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

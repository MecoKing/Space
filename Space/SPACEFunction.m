//
//  SPACEFunction.m
//  Space
//
//  Created by [pixelmonster] on 2/21/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEFunction.h"

#pragma mark NSString

NSString* SPACERandomName () {
	NSArray *CONSONANTS = @[@"B", @"C", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N", @"P", @"Q", @"R", @"S", @"T", @"V", @"W", @"X", @"Z"];
	NSArray *consonants = @[@"b", @"c", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"m", @"n", @"p", @"q", @"r", @"s", @"t", @"v", @"w", @"x", @"z"];
	NSArray *vowels = @[@"a", @"e", @"i", @"o", @"u", @"y"];
	return [NSString stringWithFormat:(@"%@%@%@"),
			CONSONANTS[SPACERandomIntegerInInterval(0, 19)],
			vowels[SPACERandomIntegerInInterval(0, 5)],
			consonants[SPACERandomIntegerInInterval(0, 19)]
	];
}

NSString* SPACERandomDoubleName () {
	return [NSString stringWithFormat:(@"%@%@"), SPACERandomName (), SPACERandomName()];
}

#pragma mark CGFloat

CGFloat SPACERandomInInterval(CGFloat from, CGFloat to) {
	CGFloat value = ((CGFloat)random()) / (CGFloat)RAND_MAX;
	return value * fabs(to - from) + from;
}

CGFloat SPACEFloatCloseToAverage (CGFloat baseColourComponent, CGFloat averageColourComponent) {
	CGFloat baseAfterAveraging;
	if (baseColourComponent > averageColourComponent + 0.1)
		baseAfterAveraging = averageColourComponent + 0.1;
	else if (baseColourComponent < averageColourComponent - 0.1)
		baseAfterAveraging = averageColourComponent - 0.1;
	else
		baseAfterAveraging = baseColourComponent;
	
	return baseAfterAveraging;
}


#pragma mark NSUInteger

NSUInteger SPACERandomIntegerInInterval(NSUInteger from, NSUInteger to) {
	return random() % (to - from + 1) + from;
}


#pragma mark SKColor

SKColor *SPACERandomColour() {
	return [SKColor colorWithRed:SPACERandomInInterval(0, 1) green:SPACERandomInInterval(0, 1) blue:SPACERandomInInterval(0, 1) alpha:1];
}

SKColor *SPACEColourCloseToColour(SKColor *colour) {
	return [SKColor colorWithRed:colour.redComponent + SPACERandomInInterval(-0.1, 0.1)
						   green:colour.greenComponent + SPACERandomInInterval(-0.1, 0.1)
							blue:colour.blueComponent + SPACERandomInInterval(-0.1, 0.1)
						   alpha:1];
}

SKColor *SPACERandomDarkColour() {
	return [SKColor colorWithRed:SPACERandomInInterval(0, 0.5) green:SPACERandomInInterval(0, 0.5) blue:SPACERandomInInterval(0, 0.5) alpha:1];
}

SKColor *SPACERandomLightColour() {
	return [SKColor colorWithRed:SPACERandomInInterval(0.5, 1) green:SPACERandomInInterval(0.5, 1) blue:SPACERandomInInterval(0.5, 1) alpha:1];
}

SKColor *SPACEInverseOfColour(SKColor *colour) {
	return [SKColor colorWithRed: 1 - colour.redComponent green: 1 - colour.greenComponent blue: 1 - colour.blueComponent alpha:1];
}

SKColor *SPACEAverageDarkColour () {
	SKColor *baseColour = SPACERandomDarkColour();
	CGFloat averageColour = (baseColour.redComponent + baseColour.blueComponent + baseColour.greenComponent) / 3;
	
	return [SKColor colorWithRed:SPACEFloatCloseToAverage(baseColour.redComponent, averageColour) green:SPACEFloatCloseToAverage(baseColour.greenComponent, averageColour) blue:SPACEFloatCloseToAverage(baseColour.blueComponent, averageColour) alpha:1];
}


#pragma mark CGPoint

CGPoint SPACEPointWithVector(CGVector v) {
	return (CGPoint){ .x = v.dx, .y = v.dy };
}


CGPoint SPACESubtractPoint(CGPoint a, CGPoint b) {
	return (CGPoint){
		.x = a.x - b.x,
		.y = a.y - b.y,
	};
}

CGFloat SPACEMagnitudeOfPoint(CGPoint a) {
	return sqrt(a.x * a.x + a.y * a.y);
}

CGFloat SPACEDistanceBetweenPoints(CGPoint a, CGPoint b) {
	return SPACEMagnitudeOfPoint(SPACESubtractPoint(a, b));
}

CGPoint SPACEMultiplyPoint(CGPoint a, CGPoint b) {
	return (CGPoint){
		.x = a.x * b.x,
		.y = a.y * b.y,
	};
}

CGPoint SPACEMultiplyPointByScalar(CGPoint a, CGFloat s) {
	return (CGPoint){
		.x = a.x * s,
		.y = a.y * s,
	};
}

CGPoint SPACEDividePointByScalar(CGPoint a, CGFloat s) {
	return (CGPoint){
		.x = a.x / s,
		.y = a.y / s,
	};
}

CGPoint SPACENormalizePoint(CGPoint a) {
	CGFloat magnitude = SPACEMagnitudeOfPoint(a);
	return SPACEDividePointByScalar(a, magnitude);
}

CGPoint SPACERandomInSize(CGSize size) {
	return (CGPoint){
		.x = SPACERandomInInterval(0, size.width),
		.y = SPACERandomInInterval(0, size.height),
	};
}


#pragma mark CGVector

CGVector SPACEVectorWithPoint(CGPoint p) {
	return (CGVector){ .dx = p.x, .dy = p.y };
}


CGVector SPACEMultiplyVectorByScalar(CGVector v, CGFloat s) {
	return (CGVector){ .dx = v.dx * s, .dy = v.dy * s };
}


#pragma mark Polar coordinates

CGPoint SPACEPointWithPolarPoint(SPACEPolarPoint p) {
	return (CGPoint){
		.x = p.r * -sin(p.phi),
		.y = p.r * cos(p.phi),
	};
}

SPACEPolarPoint SPACEPolarPointWithPoint(CGPoint p) {
	return (SPACEPolarPoint){
		.r = SPACEMagnitudeOfPoint(p),
		.phi = atan2(p.y, p.x) - M_PI_2,
	};
}


CGVector SPACEVectorWithPolarPoint(SPACEPolarPoint p) {
	return SPACEVectorWithPoint(SPACEPointWithPolarPoint(p));
}

SPACEPolarPoint SPACEPolarPointWithVector(CGVector v) {
	return SPACEPolarPointWithPoint(SPACEPointWithVector(v));
}

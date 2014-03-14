//
//  SPACEFunction.h
//  Space
//
//  Created by [pixelmonster] on 2/21/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

CGFloat SPACERandomInInterval(CGFloat from, CGFloat to);
CGFloat SPACEFloatCloseToAverage (CGFloat baseColourComponent, CGFloat averageColourComponent);

NSUInteger SPACERandomIntegerInInterval(NSUInteger from, NSUInteger to);

SKColor *SPACERandomColour();
SKColor *SPACERandomDarkColour();
SKColor *SPACERandomLightColour();
SKColor *SPACEInverseOfColour(SKColor *colour);
SKColor *SPACEAverageDarkColour ();

CGPoint SPACESubtractPoint(CGPoint a, CGPoint b);
CGFloat SPACEMagnitudeOfPoint(CGPoint a);
CGFloat SPACEDistanceBetweenPoints(CGPoint a, CGPoint b);
CGPoint SPACEMultiplyPoint(CGPoint a, CGPoint b);
CGPoint SPACEMultiplyPointByScalar(CGPoint a, CGFloat s);
CGPoint SPACEDividePointByScalar(CGPoint a, CGFloat s);
CGPoint SPACENormalizePoint(CGPoint a);
CGPoint SPACERandomInSize(CGSize size);

typedef struct {
	CGFloat r; // radius
	CGFloat phi; // angle in radians
} SPACEPolarPoint;

CGPoint SPACEPointWithPolarPoint(SPACEPolarPoint polar);
SPACEPolarPoint SPACEPolarPointWithPoint(CGPoint point);

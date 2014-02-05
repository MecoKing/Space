//
//  SPACEStellarBody.m
//  Space
//
//  Created by [pixelmonster] on 2/5/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEStellarBody.h"


static inline CGFloat SPACERandomInInterval(CGFloat from, CGFloat to) {
    CGFloat value = ((CGFloat)random()) / (CGFloat)RAND_MAX;
    return value * fabs(to - from) + from;
}

static inline SKColor *SPACERandomColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0, 1) green:SPACERandomInInterval(0, 1) blue:SPACERandomInInterval(0, 1) alpha:1];
}

static inline SKColor *SPACERandomLightColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0.5, 1) green:SPACERandomInInterval(0.5, 1) blue:SPACERandomInInterval(0.5, 1) alpha:1];
}

static inline SKColor *SPACERandomDarkColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0, 0.5) green:SPACERandomInInterval(0, 0.5) blue:SPACERandomInInterval(0, 0.5) alpha:1];
}

static inline CGFloat SPACEFloatCloseToAverage (CGFloat baseColourComponent, CGFloat averageColourComponent){
    CGFloat baseAfterAveraging;
    if (baseColourComponent > averageColourComponent + 0.1)
        baseAfterAveraging = averageColourComponent + 0.1;
    else if (baseColourComponent < averageColourComponent - 0.1)
        baseAfterAveraging = averageColourComponent - 0.1;
    else
        baseAfterAveraging = baseColourComponent;
    
    return baseAfterAveraging;
}

static inline SKColor *SPACEAverageDarkColour () {
    SKColor *baseColour = SPACERandomDarkColour();
    CGFloat averageColour = (baseColour.redComponent + baseColour.blueComponent + baseColour.greenComponent) / 3;
    
    return [SKColor colorWithRed:SPACEFloatCloseToAverage(baseColour.redComponent, averageColour) green:SPACEFloatCloseToAverage(baseColour.greenComponent, averageColour) blue:SPACEFloatCloseToAverage(baseColour.blueComponent, averageColour) alpha:1];
}

static inline CGPoint SPACERandomInSize(CGSize size) {
    return (CGPoint){
        .x = SPACERandomInInterval(0, size.width),
        .y = SPACERandomInInterval(0, size.height),
    };
}


@implementation SPACEStellarBody

+(instancetype)randomStarWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(20, 100);
    body.mass = SPACERandomInInterval(20, 100) * body.radius;
    body.position = SPACERandomInSize(size);
    body.colour = SPACERandomLightColour();
    body.glowColour = [[body.colour blendedColorWithFraction:0.25 ofColor:[SKColor whiteColor]] colorWithAlphaComponent:0.5];
    body.glowRatio = 0.5;
    return body;
}

+(instancetype)redGiantWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(200, 500);
    body.mass = SPACERandomInInterval(200, 500) * body.radius;
    body.position = SPACERandomInSize(size);
    body.colour = [SKColor colorWithRed:SPACERandomInInterval(0.5, 1) green:SPACERandomInInterval(0, 0.1) blue:SPACERandomInInterval(0, 0.1) alpha:1];
    body.glowColour = [[body.colour blendedColorWithFraction:0.25 ofColor:[SKColor whiteColor]] colorWithAlphaComponent:0.75];
    body.glowRatio = 0.4;
    return body;
}

+(instancetype)randomPlanetWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(5, 50);
    body.mass = SPACERandomInInterval(5, 50) * body.radius;
    body.position = SPACERandomInSize(size);
    body.colour = SPACEAverageDarkColour();
    body.glowColour = [[body.colour blendedColorWithFraction:0.75 ofColor:[SKColor colorWithRed:0.73 green:0.81 blue:1 alpha:1]] colorWithAlphaComponent:0.25];
    body.glowRatio = SPACERandomInInterval(0, 0.15);
    return body;
}


-(SKShapeNode *)shape {
    SKShapeNode *shape = [SKShapeNode node];
    
    CGRect bounds = {
        .origin.x = -self.radius,
        .origin.y = -self.radius,
        .size.width = self.radius * 2,
        .size.height = self.radius * 2,
    };
    CGPathRef path = CGPathCreateWithEllipseInRect(bounds, NULL);
    shape.path = path;
    CGPathRelease(path);
    
    shape.fillColor = self.colour;
    shape.strokeColor = self.glowColour;
    shape.glowWidth = self.radius * self.glowRatio;
    shape.position = self.position;
    
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.radius];
    CGFloat area = M_PI * self.radius * self.radius;
    physicsBody.mass = self.mass;
    physicsBody.density = self.mass / area;
    
    physicsBody.velocity = CGVectorMake(SPACERandomInInterval(-20, 20), SPACERandomInInterval(-20, 20));
    physicsBody.friction = 0;
    
    CGFloat oneRotationPerSecond = M_PI * 2;
    physicsBody.angularVelocity = SPACERandomInInterval(oneRotationPerSecond * 10, oneRotationPerSecond * 100);
    physicsBody.angularDamping = 0;
    
    shape.physicsBody = physicsBody;
    
    return shape;
}

@end

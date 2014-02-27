//
//  SPACEStellarBody.m
//  Space
//
//  Created by [pixelmonster] on 2/5/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEStellarBody.h"
#import "SPACEFunction.h"


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


#pragma mark
#pragma mark Non-Random Stellar Bodies

+(instancetype)supernovaWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(400, 600);
    body.mass = SPACERandomInInterval(1.5e31, 2.2e31);
    body.position = SPACERandomInSize(size);
    body.colour = [SKColor colorWithRed:SPACERandomInInterval(0.75, 1) green:SPACERandomInInterval(0.45, 0.55) blue:0.2 alpha:1];
    body.glowColour = [[body.colour blendedColorWithFraction:0.25 ofColor:[SKColor whiteColor]] colorWithAlphaComponent:0.75];
    body.glowRatio = SPACERandomInInterval(0.3, 0.45);
    return body;
}

+(instancetype)redGiantWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(250, 400);
    body.mass = SPACERandomInInterval(2.4e30, 3e30);
    body.position = SPACERandomInSize(size);
    body.colour = [SKColor colorWithRed:SPACERandomInInterval(0.5, 1) green:SPACERandomInInterval(0, 0.1) blue:SPACERandomInInterval(0, 0.1) alpha:1];
    body.glowColour = [[body.colour blendedColorWithFraction:0.25 ofColor:[SKColor whiteColor]] colorWithAlphaComponent:0.75];
    body.glowRatio = SPACERandomInInterval(0.3, 0.45);
    return body;
}

+(instancetype)whiteDwarfWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(150, 250);
    body.mass = SPACERandomInInterval(2e30, 2.1e30);
    body.position = SPACERandomInSize(size);
    body.colour = [SKColor colorWithRed:SPACERandomInInterval(0.8, 1) green:SPACERandomInInterval(0.8, 1) blue:SPACERandomInInterval(0.8, 1) alpha:1];
    body.glowColour = [[body.colour blendedColorWithFraction:0.25 ofColor:[SKColor whiteColor]] colorWithAlphaComponent:0.75];
    body.glowRatio = SPACERandomInInterval(0.3, 0.45);
    return body;
}

+(instancetype)moonWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(5, 15);
    body.mass = SPACERandomInInterval(1e15, 1e23);
    body.position = SPACERandomInSize(size);
    body.colour = SPACEAverageDarkColour();
    body.glowColour = [[body.colour blendedColorWithFraction:0.75 ofColor:[SKColor colorWithRed:0.73 green:0.81 blue:1 alpha:1]] colorWithAlphaComponent:0.25];
    body.glowRatio = 0;
    return body;
}

+(instancetype)terraPlanetWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(20, 50);
    body.mass = SPACERandomInInterval(2e23, 2e25);
    body.position = SPACERandomInSize(size);
    body.colour = SPACEAverageDarkColour();
    body.glowColour = [[body.colour blendedColorWithFraction:0.75 ofColor:[SKColor colorWithRed:0.73 green:0.81 blue:1 alpha:1]] colorWithAlphaComponent:0.25];
    body.glowRatio = SPACERandomInInterval(0, 0.15);
    return body;
}

+(instancetype)gasPlanetWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(50, 100);
    body.mass = SPACERandomInInterval(1e25, 1e27);
    body.position = SPACERandomInSize(size);
    body.colour = SPACEAverageDarkColour();
    body.glowColour = [[body.colour blendedColorWithFraction:0.75 ofColor:[SKColor colorWithRed:0.73 green:0.81 blue:1 alpha:1]] colorWithAlphaComponent:0.25];
    body.glowRatio = SPACERandomInInterval(0, 0.2);
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

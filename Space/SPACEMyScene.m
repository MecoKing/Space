//
//  SPACEMyScene.m
//  Space
//
//  Created by [pixelmonster] on 1/29/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEMyScene.h"
#import "SPACEShip.h"
#import "SPACEStellarBody.h"

#pragma mark Stuff!
static inline CGFloat SPACERandomInInterval(CGFloat from, CGFloat to) {
    CGFloat value = ((CGFloat)random()) / (CGFloat)RAND_MAX;
    return value * fabs(to - from) + from;
}

static inline NSUInteger SPACERandomIntegerInInterval(NSUInteger from, NSUInteger to) {
    return random() % (to - from + 1) + from;
}

static inline SKColor *SPACERandomColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0, 1) green:SPACERandomInInterval(0, 1) blue:SPACERandomInInterval(0, 1) alpha:1];
}

static inline SKColor *SPACERandomDarkColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0, 0.5) green:SPACERandomInInterval(0, 0.5) blue:SPACERandomInInterval(0, 0.5) alpha:1];
}

static inline SKColor *SPACEInverseOfColour(SKColor *colour) {
    return [SKColor colorWithRed: 1 - colour.redComponent green: 1 - colour.greenComponent blue: 1 - colour.blueComponent alpha:1];
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

static inline CGPoint SPACESubtractPoint(CGPoint a, CGPoint b) {
    return (CGPoint){
        .x = a.x - b.x,
        .y = a.y - b.y,
    };
}

static inline CGFloat SPACEMagnitudeOfPoint(CGPoint a) {
    return sqrt(a.x * a.x + a.y * a.y);
}

static inline CGFloat SPACEDistanceBetweenPoints(CGPoint a, CGPoint b) {
    return SPACEMagnitudeOfPoint(SPACESubtractPoint(a, b));
}

static inline CGPoint SPACEMultiplyPoint(CGPoint a, CGPoint b) {
    return (CGPoint){
    	.x = a.x * b.x,
        .y = a.y * b.y,
    };
}

static inline CGPoint SPACEMultiplyPointByScalar(CGPoint a, CGFloat s) {
    return (CGPoint){
    	.x = a.x * s,
        .y = a.y * s,
    };
}

static inline CGPoint SPACEDividePointByScalar(CGPoint a, CGFloat s) {
    return (CGPoint){
    	.x = a.x / s,
        .y = a.y / s,
    };
}

static inline CGPoint SPACENormalizePoint(CGPoint a) {
    CGFloat magnitude = SPACEMagnitudeOfPoint(a);
    return SPACEDividePointByScalar(a, magnitude);
}


#pragma mark
#pragma mark Scene

@interface SPACEMyScene ()

@property NSTimeInterval previousTime;

@property SPACEShip *playerShip;

@end

@implementation SPACEMyScene

+(void)initialize {
    srandomdev();
}

-(instancetype)initWithSize:(CGSize)size {
    if ((self = [super initWithSize:size])) {
        /* Setup your scene here */
        
        //Should be decided based on:
        //average star colour ± SPACERandoomInInterval(-0.2, 0.2);
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        [self addPlayerShip];
        [self generateNebula];
        [self generateSolarSystem];
    }
    return self;
}

-(void)addPlayerShip {
    self.playerShip = [SPACEShip new];
    SKNode *node = self.playerShip.node;
    node.position = (CGPoint){ CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) };
    [self addChild:node];
}



#pragma mark Player controls

-(void)keyDown:(NSEvent *)event {
    unichar key = [event.charactersIgnoringModifiers characterAtIndex:0];
    
    if (key == 'd' || key == NSRightArrowFunctionKey)
        self.playerShip.angle = self.playerShip.angle - 0.05 * M_PI;
    else if (key == 'a' || key == NSLeftArrowFunctionKey)
        self.playerShip.angle = self.playerShip.angle + 0.05 * M_PI;
    else if (key == 'w' || key == NSUpArrowFunctionKey) {
        CGFloat magnitude = 0.05;
        CGVector force = (CGVector){
            .dx = -sin(self.playerShip.angle) * magnitude,
            .dy = cos(self.playerShip.angle) * magnitude,
        };
        [self.playerShip.node.physicsBody applyForce:force];
    }
}


#pragma mark Procedural generation

-(void) generateSolarSystem {
//    return;
    self.backgroundColor = SPACEAverageDarkColour();
    
    NSUInteger starCount = SPACERandomIntegerInInterval(1, 3);
    NSUInteger planetCount = [self planetCountBasedOnStars:starCount];
    for (NSUInteger i = 0; i < planetCount; i++) {
        CGFloat planetType = SPACERandomInInterval(1, 100);
        if (planetType >= 66)
            [self addChild:[SPACEStellarBody moonWithSize:self.size].shape];
        else if (planetType >= 33)
            [self addChild:[SPACEStellarBody terraPlanetWithSize:self.size].shape];
        else
            [self addChild:[SPACEStellarBody gasPlanetWithSize:self.size].shape];
    }
    for (NSUInteger i = 0; i < starCount; i++) {
        CGFloat starType = SPACERandomInInterval(1, 1000);
        if (starType >= 975)//2.5% chance
            [self addChild:[SPACEStellarBody supernovaWithSize:self.size].shape];
        else if (starType >= 950)//2.5% chance
            [self addChild:[SPACEStellarBody redGiantWithSize:self.size].shape];
        else
            [self addChild:[SPACEStellarBody whiteDwarfWithSize:self.size].shape];
    }
    
    SKLabelNode *planetCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
    SKLabelNode *starCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
    planetCountLabel.position = CGPointMake(50, 20);
    starCountLabel.position = CGPointMake(50, 50);
    planetCountLabel.fontColor = SPACEInverseOfColour(self.backgroundColor);
    starCountLabel.fontColor = SPACEInverseOfColour(self.backgroundColor);
    planetCountLabel.fontSize = 14;
    starCountLabel.fontSize = 14;
    planetCountLabel.text = [NSString stringWithFormat:@"Planets: %lu", (unsigned long)planetCount];
    starCountLabel.text = [NSString stringWithFormat:@"Stars: %lu", (unsigned long)starCount];
    [self addChild:planetCountLabel];
    [self addChild:starCountLabel];
}


-(void) generateNebula {
//    return;
    int numberOfClouds = ((self.size.width + self.size.height) / 2) / 2;

    for (int i = 0; i < numberOfClouds; i++) {
        
        SKShapeNode *cloud = [SKShapeNode node];
        int cloudSize = SPACERandomInInterval(50, 200);
        
        CGRect bounds = {
            .origin.x = SPACERandomInInterval(cloudSize / -2, self.size.width),
            .origin.y = SPACERandomInInterval(cloudSize / -2, self.size.height),
            .size.width = cloudSize * 2,
            .size.height = cloudSize * 2,
        };
   
        cloud.path = CGPathCreateWithEllipseInRect(bounds, NULL);
        
        cloud.strokeColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:0.01];
        cloud.glowWidth = cloudSize * SPACERandomInInterval(0.25, 0.75);
   
        [self addChild:cloud];
    }
}


-(NSUInteger) planetCountBasedOnStars: (NSUInteger)starCount {
    int planetCount = SPACERandomInInterval(1, 9);//Always at least one planet per system
    for (int i = 0; i < starCount - 1; i++) {
        planetCount += SPACERandomInInterval(0, 9);//possible to have one planet for 3 stars
    }
    return planetCount;
}

-(void) mouseDown:(NSEvent *)theEvent {
    [self removeAllChildren];
    [self generateNebula];
    [self addPlayerShip];
    [self generateSolarSystem];
}

-(void)update:(CFTimeInterval)currentTime {
//    return;
    if (self.previousTime == 0) self.previousTime = currentTime;
    const CGFloat gravitationalConstant = 6e-19;
    CFTimeInterval interval = currentTime - self.previousTime;
    for (SKNode *a in self.children) {
        CGPoint centreOfGravity = a.position;
        CGFloat mass = a.physicsBody.mass;
        
        for (SKNode *b in self.children) {
            if (a == b) continue;
            CGPoint position = b.position;
            CGFloat distance = SPACEDistanceBetweenPoints(centreOfGravity, position);
            if (distance == 0) continue;
            
            CGFloat magnitude = gravitationalConstant * ((mass * b.physicsBody.mass) / (distance * distance));
            CGPoint direction = SPACENormalizePoint(SPACESubtractPoint(centreOfGravity, position));
            
            [b.physicsBody applyForce:(CGVector){
                .dx = direction.x * magnitude * interval,
                .dy = direction.y * magnitude * interval,
            }];
//            f = g * (m1 * m2 / r^2)
        }
    }
    self.previousTime = currentTime;
}

@end

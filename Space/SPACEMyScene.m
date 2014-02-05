//
//  SPACEMyScene.m
//  Space
//
//  Created by [pixelmonster] on 1/29/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEMyScene.h"

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

static inline SKColor *SPACERandomLightColour() {
    return [SKColor colorWithRed:SPACERandomInInterval(0.5, 1) green:SPACERandomInInterval(0.5, 1) blue:SPACERandomInInterval(0.5, 1) alpha:1];
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

static inline SKColor *SPACEAverageLightColour () {
    SKColor *baseColour = SPACERandomLightColour();
    CGFloat averageColourComponent = (baseColour.redComponent + baseColour.blueComponent + baseColour.greenComponent) / 3;
    
    return [SKColor colorWithRed:SPACEFloatCloseToAverage(baseColour.redComponent, averageColourComponent) green:SPACEFloatCloseToAverage(baseColour.greenComponent, averageColourComponent) blue:SPACEFloatCloseToAverage(baseColour.blueComponent, averageColourComponent ) alpha:1];
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
#pragma mark Stellar Bodies!

@interface SPACEStellarBody : NSObject

+(instancetype)randomStarWithSize:(CGSize)size;

@property CGFloat radius;
@property CGFloat mass;
@property CGPoint position;
@property SKColor *colour;
@property SKColor *glowColour;
@property CGFloat glowRatio;

@property (readonly) SKShapeNode *shape;

@end

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

+(instancetype)randomPlanetInSceneWithSize:(CGSize)size {
    SPACEStellarBody *body = [self new];
    body.radius = SPACERandomInInterval(5, 50);
    body.mass = SPACERandomInInterval(5, 50) * body.radius;
    body.position = SPACERandomInSize(size);
    body.colour = SPACEAverageDarkColour();
    body.glowColour = [[body.colour blendedColorWithFraction:0.5 ofColor:[SKColor cyanColor]] colorWithAlphaComponent:0.25];
    body.glowRatio = 0.1;
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


#pragma mark
#pragma mark Scene

@interface SPACEMyScene ()
@property NSTimeInterval previousTime;
@end

@implementation SPACEMyScene

+(void)initialize {
    srandomdev();
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //Should be decided based on:
        //average star colour ± SPACERandoomInInterval(-0.2, 0.2);
        self.backgroundColor = SPACEAverageDarkColour();
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        SKColor *textColor = SPACEInverseOfColour(self.backgroundColor);
        SKLabelNode *planetCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
        SKLabelNode *starCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
        planetCountLabel.position = CGPointMake(50, 20);
        starCountLabel.position = CGPointMake(50, 50);
        planetCountLabel.color = textColor;
        starCountLabel.color = textColor;
        planetCountLabel.fontSize = 12;
        starCountLabel.fontSize = 12;

        
        
        NSUInteger starCount = SPACERandomIntegerInInterval(1, 3);
//        Test with more stars
//        starCount = 100;
        for (NSUInteger i = 0; i < starCount; i++) {
            [self addChild:[SPACEStellarBody randomStarWithSize:size].shape];
        }
        
        NSUInteger planetCount = [self planetCountBasedOnStars:starCount];
//        Test with more planets
//        planetCount = 100;
        for (NSUInteger i = 0; i < planetCount; i++) {
            [self addChild:[SPACEStellarBody randomPlanetInSceneWithSize:size].shape];
        }
        

        planetCountLabel.text = [NSString stringWithFormat:@"Planets: %lu", (unsigned long)planetCount];
        starCountLabel.text = [NSString stringWithFormat:@"Stars: %lu", (unsigned long)starCount];
        
        [self addChild:planetCountLabel];
        [self addChild:starCountLabel];
    }
    return self;
}

-(NSUInteger) planetCountBasedOnStars: (NSUInteger)starCount {
    int planetCount = 0;
    for (int i = 0; i < starCount; i++) {
        planetCount += SPACERandomIntegerInInterval(1, 9);
    }
    return planetCount;
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    SKSpriteNode *sprite;
    
    NSUInteger shipChoice = SPACERandomInInterval(1, 4);//<- This is being stupid
    if (shipChoice == 1)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"HumanFighter"];
    else if (shipChoice == 2)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"RogueFighter"];
    else if (shipChoice == 3)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"AlienFighter"];
    
    sprite.position = location;
    
    [self addChild:sprite];
}

// multiply by currentTime
-(void)update:(CFTimeInterval)currentTime {
    for (SKNode *a in self.children) {
        CGPoint centreOfGravity = a.position;
        CGFloat mass = a.physicsBody.mass;
        
        for (SKNode *b in self.children) {
            if (a == b) continue;
            CGPoint position = b.position;
            CGFloat distance = SPACEDistanceBetweenPoints(centreOfGravity, position);
            if (distance == 0) continue;
            
            CGFloat magnitude = (mass * b.physicsBody.mass) / (distance * distance);
            CGPoint direction = SPACENormalizePoint(SPACESubtractPoint(centreOfGravity, position));
            
            [b.physicsBody applyForce:(CGVector){
                .dx = direction.x * magnitude,
                .dy = direction.y * magnitude,
            }];
//            f = g * (m1 * m2 / r^2)
        }
    }
}

@end

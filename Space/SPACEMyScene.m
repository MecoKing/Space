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
    
    physicsBody.velocity = CGVectorMake(SPACERandomInInterval(10, 20), SPACERandomInInterval(10, 20));
    
    CGFloat oneRotationPerSecond = M_PI * 2;
    physicsBody.angularVelocity = SPACERandomInInterval(oneRotationPerSecond * 10, oneRotationPerSecond * 100);
    
    shape.physicsBody = physicsBody;
    
    return shape;
}

@end


#pragma mark
#pragma mark DrawingToScreen!

@implementation SPACEMyScene

+(void)initialize {
    srandomdev();
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //Should be decided based on:
        //average star colour ± SPACERandoomInInterval(-0.2, 0.2);
        self.backgroundColor = SPACEAverageDarkColour();
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        NSUInteger starCount = SPACERandomIntegerInInterval(1, 3);
//        Test with more stars
//        starCount = 100;
        for (NSUInteger i = 0; i < starCount; i++) {
            [self addChild:[SPACEStellarBody randomStarWithSize:size].shape];
        }
        
        NSUInteger planetCount = SPACERandomIntegerInInterval(1, 10);
//        Test with more planets
//        planetCount = 100;
        for (NSUInteger i = 0; i < planetCount; i++) {
            [self addChild:[SPACEStellarBody randomPlanetInSceneWithSize:size].shape];
        }
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    SKSpriteNode *sprite;
    
    NSUInteger shipChoice = SPACERandomInInterval(1, 4);
    if (shipChoice == 1)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"HumanFighter"];
    else if (shipChoice == 2)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"RogueFighter"];
    else if (shipChoice == 3)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"AlienFighter"];
    
    sprite.position = location;
    
    [self addChild:sprite];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

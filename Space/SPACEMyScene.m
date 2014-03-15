//
//  SPACEMyScene.m
//  Space
//
//  Created by [pixelmonster] on 1/29/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEFunction.h"
#import "SPACEMyScene.h"
#import "SPACEShip.h"
#import "SPACEStellarBody.h"
#import "SPACESystem.h"
#import "SPACEPlanet.h"


#pragma mark
#pragma mark Scene

@implementation SPACEMyScene

+(void)initialize {
    srandomdev();
}

-(instancetype)initWithSize:(CGSize)size {
    if ((self = [super initWithSize:size])) {
        /* Setup your scene here */

        
        self.anchorPoint = (CGPoint){ 0.5, 0.5 };
        //Should be decided based on:
        //average star colour ± SPACERandoomInInterval(-0.2, 0.2);
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        [self generateNebula];
        self.universe = [SKNode node];
        self.laserManager = [SKNode node];
        [self addChild:self.universe];
        [self.universe addChild:self.laserManager];
        [self addPlayerShip];
        [self addStarShips];
        [self generateSolarSystem];
    }
    return self;
}

-(void)addPlayerShip {
    self.playerShip = [SPACEShip shipWithImageNamed:@"HumanFighter"];
	self.playerShip.faction = SPACEPlayerFaction;
    [self.universe addChild:self.playerShip];
}

-(void) addStarShips {
    SPACEShip *alien = [SPACEShip shipWithImageNamed:@"AlienFighter"];
    SPACEShip *rogue = [SPACEShip shipWithImageNamed:@"RogueFighter"];
    SPACEShip *rebel = [SPACEShip shipWithImageNamed:@"RebelFighter"];
    SPACEShip *razor = [SPACEShip shipWithImageNamed:@"RazorFighter"];
    self.AIShips = @[
        alien,
        rogue,
        rebel,
        razor
    ];
    for (SPACEShip *ship in self.AIShips) {
		ship.faction = SPACEEnemyFaction;
        [self.universe addChild:ship];
    }
}

#pragma mark
#pragma mark Player controls

-(void)keyDown:(NSEvent *)event {
    unichar key = [event.charactersIgnoringModifiers characterAtIndex:0];
    
    if ((key == 'd' || key == NSRightArrowFunctionKey) && !event.isARepeat)
        [self.playerShip activateDirectionalThrustersRight];
    else if ((key == 'a' || key == NSLeftArrowFunctionKey) && !event.isARepeat)
        [self.playerShip activateDirectionalThrustersLeft];
    else if (key == 'w' || key == NSUpArrowFunctionKey) {
        [self.playerShip activateThrusters];
    }
    if (key == ' ') {
        [self.playerShip fireLaser];
    }
    if (key == 'r') {
        [self refreshSolarSystem];
    }
}

-(void)keyUp:(NSEvent *)event {
    unichar key = [event.charactersIgnoringModifiers characterAtIndex:0];
    
    if (key == 'd' || key == NSRightArrowFunctionKey || key == 'a' || key == NSLeftArrowFunctionKey)
        [self.playerShip releaseDirectionalThrusters];
}

-(void) mouseDown:(NSEvent *)click {
    CGPoint locationInViewCoordinates = [self.scene.view convertPoint:click.locationInWindow fromView:nil];
	CGPoint locationInSceneCoordinates = [self.scene.view convertPoint:locationInViewCoordinates toScene:self.scene];
	CGPoint locationInUniverseCoordinates = [self.universe convertPoint:locationInSceneCoordinates fromNode:self.scene];
    [self.playerShip fireMissileAtPoint:locationInUniverseCoordinates];
}


#pragma mark
#pragma mark Procedural generation

-(void) generateSolarSystem {
    self.system = [SPACESystem randomSystem];
    [self.universe addChild:self.system];
}


-(void) generateNebula {
//    return;
    self.backgroundColor = SPACEAverageDarkColour();
    int numberOfClouds = ((self.size.width + self.size.height) / 2) / 2;

    for (int i = 0; i < numberOfClouds; i++) {
        
        SKShapeNode *cloud = [SKShapeNode node];
        int cloudSize = SPACERandomInInterval(50, 200);
        
        CGRect bounds = {
            .origin.x = SPACERandomInInterval((cloudSize / -2) - (self.size.width / 2), self.size.width),
            .origin.y = SPACERandomInInterval((cloudSize / -2) - (self.size.height / 2), self.size.height),
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

-(void) refreshSolarSystem {
    [self.laserManager removeAllChildren];
    [self.universe removeAllChildren];
    [self removeAllChildren];
    [self generateNebula];
    [self addChild:self.universe];
    [self.universe addChild:self.laserManager];
    [self addPlayerShip];
    [self addStarShips];
    [self generateSolarSystem];
}

-(void)update:(CFTimeInterval)currentTime {
//    return;
    if (self.previousTime == 0) self.previousTime = currentTime;
    const CGFloat gravitationalConstant = 6e-19;
    CFTimeInterval interval = currentTime - self.previousTime;
    for (SKNode *a in self.universe.children) {
        CGPoint centreOfGravity = a.position;
        CGFloat mass = a.physicsBody.mass;
        
        for (SKNode *b in self.universe.children) {
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
    self.universe.position = SPACEMultiplyPointByScalar(self.playerShip.position, -1);
    
	
	for (SPACEShip *ship in self.AIShips) {
		[ship runAutoPilot];
	}
    
    
	[self.system updateWithSystem:self.system];
    
	
    for (SKNode *projectile in self.laserManager.children) {
        //if the laser is off screen remove it...
        CGRect windowRect = CGRectMake(
            self.playerShip.position.x - (self.view.window.frame.size.width / 2),
            self.playerShip.position.y - (self.view.window.frame.size.height / 2),
            self.view.window.frame.size.width,
            self.view.window.frame.size.height
        );
        if (!CGRectContainsPoint(windowRect, projectile.position))
        {
            [projectile removeFromParent];
        }
    }

	self.previousTime = currentTime;
}

@end

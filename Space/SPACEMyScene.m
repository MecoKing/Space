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
#import "SPACEHUD.h"
#import "SPACEPlanet.h"
#import "SPACEFaction.h"


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
		self.playerEnginePower = 0;
		[self generateNebula];
		[self generateFactions];
		self.universe = [SKNode node];
		self.laserManager = [SKNode node];
		[self addChild:self.universe];
		[self.universe addChild:self.laserManager];
		[self addPlayerShip];
		[self addStarShips];
		[self generateSolarSystem];
		[self drawHUD];
	}
	return self;
}

-(void)addPlayerShip {
	self.playerShip = [SPACEShip randomFighterOfFaction:self.factions[0]];
	[self.universe addChild:self.playerShip];
}

-(void) addStarShips {
//	return;
	for (SPACEFaction *faction in self.factions) {
		for (int i = 0; i < SPACERandomIntegerInInterval(4, 8); i++) {
			SPACEShip *ship = [SPACEShip randomFighterOfFaction:faction];
			self.AIShips = [NSArray arrayWithArray:[self.AIShips arrayByAddingObject:ship]];
			[self.universe addChild:ship];
		}
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
		self.playerEnginePower+=10;
		if (self.playerEnginePower > 100) self.playerEnginePower = 100;
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

-(void) drawHUD {
	self.compassHUD = [SPACEHUD compassHUDWithColour:SPACEInverseOfColour(self.backgroundColor) atPosition:CGPointMake(-150, -150)];
	[self addChild:self.compassHUD];
	self.engineHUD = [SPACEHUD engineHUDWithColour:SPACEInverseOfColour(self.backgroundColor) atPosition:CGPointMake(0, -200)];
	[self addChild:self.engineHUD];
}

-(void) generateFactions {
	NSUInteger numberOfFactions = SPACERandomIntegerInInterval(4, 8);
	for (int i = 0; i < numberOfFactions; i++) {
		self.factions = [NSArray arrayWithArray:[self.factions arrayByAddingObject:[SPACEFaction randomFaction]]];
	}
}


-(void) generateNebula {
	self.backgroundColor = SPACEAverageDarkColour();
	return;
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
		cloud.strokeColor = [SKColor colorWithWhite:1 alpha:0.01];
		cloud.glowWidth = cloudSize * SPACERandomInInterval(0.25, 0.75);
		[self addChild:cloud];
		
		SKShapeNode *star = [SKShapeNode node];
		int starSize = SPACERandomInInterval(1, 3);
		CGRect starBounds = {
			.origin.x = SPACERandomInInterval((starSize / -2) - (self.size.width / 2), self.size.width),
			.origin.y = SPACERandomInInterval((starSize / -2) - (self.size.height / 2), self.size.height),
			.size.width = starSize * 2,
			.size.height = starSize * 2,
		};
		star.path = CGPathCreateWithEllipseInRect(starBounds, NULL);
		star.strokeColor = [SKColor  colorWithWhite:1 alpha:0.2];
		star.fillColor = [SKColor whiteColor];
		star.glowWidth = starSize * SPACERandomInInterval(0.25, 0.75);
		[self addChild:star];
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
	self.playerEnginePower = 0;
	[self.laserManager removeAllChildren];
	[self.universe removeAllChildren];
	self.factions = nil;
	self.AIShips = nil;
	[self removeAllChildren];
	[self generateNebula];
	[self generateFactions];
	[self addChild:self.universe];
	[self.universe addChild:self.laserManager];
	[self addPlayerShip];
	[self addStarShips];
	[self generateSolarSystem];
	[self drawHUD];
}

-(void)update:(CFTimeInterval)currentTime {
//	return;
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
//			f = g * (m1 * m2 / r^2)
		}
	}
	self.universe.position = SPACEMultiplyPointByScalar(self.playerShip.position, -1);
	
	
	for (SPACEShip *ship in self.AIShips) {
		[ship runAutoPilot];
		ship.info.zRotation = 0 - ship.zRotation;
	}
	self.playerShip.info.zRotation = 0 - self.playerShip.zRotation;
	if (self.playerEnginePower > 0) self.playerEnginePower--;
	
	
	[self.compassHUD updateDotsOnCompass];
	[self.engineHUD updateEngineHUD];


	[self.system updateWithSystem:self.system overInterval:interval];
	   
	
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

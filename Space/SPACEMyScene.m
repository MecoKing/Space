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
#import "SPACEStat.h"
#import "SPACEProjectile.h"


#pragma mark
#pragma mark Scene

@implementation SPACEMyScene

#pragma mark
#pragma mark Startup

+(void)initialize {
	srandomdev();
}

-(instancetype)initWithSize:(CGSize)size {
	if ((self = [super initWithSize:size])) {
		/* Setup your scene here */
		self.anchorPoint = (CGPoint){ 0.5, 0.5 };
		self.physicsWorld.gravity = CGVectorMake(0, 0);
		
		self.physicsWorld.contactDelegate = self;
		
		self.universe = [SKNode node];
		self.laserManager = [SKNode node];
		[self refreshSolarSystem];
	}
	return self;
}

-(void) refreshSolarSystem {
	self.playerIsDead = false;
	self.playerEnginePower = 0;
	[self.laserManager removeAllChildren];
	[self.universe removeAllChildren];
	[self removeAllChildren];
	self.factions = nil;
	self.ships = nil;
	self.shipStats = nil;
	//-----------------------------------------
	[self addChild:self.universe];
	[self.universe addChild:self.laserManager];
	[self generateNebula];
	[self generateFactions];
	[self addStarShips];
	[self generateSolarSystem];
	[self drawHUD];
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
	if (!self.playerIsDead) {
		if (key == ' ') {
			[self.playerShip fireLaser];
		}
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
	if (!self.playerIsDead) [self.playerShip fireMissileAtPoint:locationInUniverseCoordinates];
}

#pragma mark
#pragma mark Procedural generation

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

-(void) generateFactions {
	NSUInteger numberOfFactions = SPACERandomIntegerInInterval(4, 8);
	for (int i = 0; i < numberOfFactions; i++) {
		self.factions = [NSArray arrayWithArray:[self.factions arrayByAddingObject:[SPACEFaction randomFaction]]];
	}
}

-(void) addStarShips {
//	return;
	self.ships = [NSMutableArray array];
	self.shipStats = [NSMutableArray array];
	for (SPACEFaction *faction in self.factions) {
		NSUInteger count = SPACERandomIntegerInInterval(4, 8);
//		count = 2;
		for (int i = 0; i < count; i++) {
			SPACEShip *ship = [SPACEShip randomFighterOfFaction:faction];
			[self.ships addObject:ship];
			[self.universe addChild:ship];
			
			SPACEStat *stat = [SPACEStat statsForShip:ship];
			[self.shipStats addObject:stat];
			[self addChild:stat];
		}
	}
	self.playerShip = self.ships[0];
}

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

#pragma mark
#pragma mark Update

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
	
	for (SPACEShip *ship in self.ships) {
		if (ship != self.playerShip) {
			[ship runAutoPilot];
		}
	}
	for (SPACEStat *stat in self.shipStats) {
		[stat updateAllShipStats];
	}
	
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
	
	if (self.playerShip.health <= 0) {
		SKLabelNode *GameOver = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
		GameOver.fontColor = [SKColor redColor];
		GameOver.fontSize = 24;
		GameOver.text = @"GAME OVER - Hit 'r' for new game!";
		[self addChild:GameOver];
		self.playerIsDead = true;
	}
	
	self.previousTime = currentTime;
}

-(void) didBeginContact:(SKPhysicsContact *)contact {
	SKPhysicsBody *firstBody, *secondBody;
	
	if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
		firstBody = contact.bodyA;
		secondBody = contact.bodyB;
	}
	else {
		firstBody = contact.bodyB;
		secondBody = contact.bodyA;
	}
	
	if ((firstBody.categoryBitMask & projectileCategory) != 0) {
		SPACEProjectile *missile = [self projectileFromNode:firstBody.node inArray:self.laserManager.children];
		
		if ((secondBody.categoryBitMask & shipCategory) != 0) {
			SPACEShip *ship = [self shipFromNode:secondBody.node inArray:self.ships];
			SPACEStat *stat = [self statBelongingToShip:ship inArray:self.shipStats];
			if (missile.faction != ship.faction) {
				if (ship.health == 0 & ship != self.playerShip) {
					[stat removeFromParent];
					[self.shipStats removeObject:stat];
					[ship removeFromParent];
					[self.ships removeObject:ship];
				}
				else {
					ship.health -= 1;
				}
			}
			if (missile.faction != ship.faction) {
				[missile removeFromParent];
			}
		}
	}
}

-(SPACEStat*) statBelongingToShip:(SPACEShip*)ship inArray:(NSArray*)array {
	for (SPACEStat *stat in array) {
		if (stat.shipObject == ship) {
			return stat;
		}
	}
	return nil;
}
-(SPACEShip*) shipFromNode:(SKNode*)node inArray:(NSArray*)array {
	for (SPACEShip *ship in array) {
		if (ship == node) {
			return ship;
		}
	}
	return nil;
}
-(SPACEProjectile*) projectileFromNode:(SKNode*)node inArray:(NSArray*)array {
	for (SPACEProjectile *projectile in array) {
		if (projectile == node) {
			return projectile;
		}
	}
	return nil;
}

@end

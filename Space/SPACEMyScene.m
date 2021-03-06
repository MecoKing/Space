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
		
		self.difficulty = 1;
		self.universe = [SKNode node];
		self.laserManager = [SKNode node];
		self.nebula = [SKNode node];
		[self refreshSolarSystem];
	}
	return self;
}

-(void) refreshSolarSystem {
	self.playerIsDead = false;
	self.playerEnginePower = 0;
	[self.laserManager removeAllChildren];
	[self.universe removeAllChildren];
	[self.nebula removeAllChildren];
	[self removeAllChildren];
	self.factions = nil;
	self.ships = nil;
	self.shipStats = nil;
	//-----------------------------------------
	[self addChild:self.nebula];
	[self addChild:self.universe];
	[self.universe addChild:self.laserManager];
	for (int i = 0; i < SPACERandomIntegerInInterval(2, 5); i++) {
		[self generateNebula];
	}
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
	
	if (key == '1') self.difficulty = 1;
	if (key == '2') self.difficulty = 2;
	if (key == '3') self.difficulty = 3;
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
//	return;
	int cloudPoints = 25;
	
	CGMutablePathRef path = CGPathCreateMutable(); // I think?
	CGPathMoveToPoint(path, NULL, SPACERandomInInterval(-self.size.width, self.size.width), SPACERandomInInterval(-self.size.height, self.size.height));
	for (int i = 0; i < cloudPoints; i++) {
		CGPathAddLineToPoint(path, NULL, SPACERandomInInterval(-self.size.width, self.size.width), SPACERandomInInterval(-self.size.height, self.size.height));
	}
	SKShapeNode *cloud = [SKShapeNode node];
	cloud.path = path;
	CGPathRelease(path);
	cloud.strokeColor = SPACEColourCloseToColour(self.backgroundColor);
	cloud.strokeColor = [SKColor colorWithRed:cloud.strokeColor.redComponent
										green:cloud.strokeColor.greenComponent
										blue:cloud.strokeColor.blueComponent
										alpha:0.5
						 ];
	cloud.glowWidth = 200;
	[self.nebula addChild:cloud];
}

-(void) generateFactions {
	NSUInteger numberOfFactions = SPACERandomIntegerInInterval(4, 8);
//	numberOfFactions = 1;
	self.factions = [NSMutableArray array];
	for (int i = 0; i < numberOfFactions; i++) {
		[self.factions addObject:[SPACEFaction randomFaction]];
	}
}

-(void) addStarShips {
//	return;
	self.ships = [NSMutableArray array];
	self.shipStats = [NSMutableArray array];
	for (SPACEFaction *faction in self.factions) {
		NSUInteger count = SPACERandomIntegerInInterval(4, 8);
		count = self.difficulty * 2;
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
	self.factionHUD = [SPACEHUD factionHUDWithColour:SPACEInverseOfColour(self.backgroundColor) forFaction:self.factions [0] atPosition:CGPointMake(0, -130)];
	[self addChild:self.factionHUD];
}

#pragma mark
#pragma mark Update

-(void)update:(CFTimeInterval)currentTime {
	for (SPACEStat *stat in self.shipStats) {
		[stat updateAllShipStats];
	}
	if (self.playerIsDead) {
		for (SPACEShip *ship in self.ships) {
			[ship releaseDirectionalThrusters];
			ship.linearMagnitude = 0;
			if (ship.linearMagnitude != 0) {
				[ship removeAllActions];
			}
		}
		return;
	}
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
	
	if (self.playerEnginePower > 0) self.playerEnginePower--;
	[self.compassHUD updateDotsOnCompass];
	[self.engineHUD updateEngineHUD];
	[self.factionHUD updateFactionHUD];
	[self.system updateWithSystem:self.system overInterval:interval];
	
	for (SPACEProjectile *projectile in self.laserManager.children) {
		//if the projectile is too far from a ship remove it...
		if ([projectile distanceFromClosestShip] >= self.size.width) [projectile removeFromParent];
	}
	
	if (self.factions.count == 1 && !self.playerIsDead) {
		SKLabelNode *Win = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
		SKLabelNode *reset = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
		Win.fontColor = [SKColor greenColor];
		reset.fontColor = [SKColor greenColor];
		Win.fontSize = 24;
		reset.fontSize = 16;
		Win.position = CGPointMake(0, 12);
		reset.position = CGPointMake(0, -8);
		Win.text = [NSString stringWithFormat:@"%@ Wins!", self.playerShip.faction.name];
		reset.text = @"Hit 'r' For A New Game!";
		[self addChild:Win];
		[self addChild:reset];
		self.playerIsDead = true;
	}
	else if (self.playerShip.health <= 0 && !self.playerIsDead) {
		SKLabelNode *GameOver = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
		SKLabelNode *reset = [SKLabelNode labelNodeWithFontNamed:@"Arial Black"];
		GameOver.fontColor = [SKColor redColor];
		reset.fontColor = [SKColor redColor];
		GameOver.fontSize = 24;
		reset.fontSize = 16;
		GameOver.position = CGPointMake(0, 12);
		reset.position = CGPointMake(0, -8);
		GameOver.text = @"GAME OVER";
		reset.text = @"Hit 'r' For A New Game!";
		[self addChild:GameOver];
		[self addChild:reset];
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
				if (ship.health <= 1 & ship != self.playerShip) {
					[stat removeFromParent];
					[self.shipStats removeObject:stat];
					[ship removeFromParent];
					[self.ships removeObject:ship];
					if ([self shipsOfFaction:ship.faction] == 0) [self.factions removeObject:ship.faction];
				}
				else {
					ship.health -= 1;
				}
			}
			if (missile.owner != ship) {
				[missile removeFromParent];
			}
		}
		if (secondBody.categoryBitMask != shipCategory) [missile removeFromParent];
	}
}

-(NSInteger*) shipsOfFaction:(SPACEFaction*)faction {
	NSInteger *count = 0;
	for (SPACEShip *ship in self.ships) {
		if (ship.faction == faction) count++;
	}
	return count;
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

//
//  SPACEShip.m
//  Space
//
//  Created by [pixelmonster] on 2/3/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEShip.h"
#import "SPACEFunction.h"
#import "SPACEMyScene.h"
#import "SPACEProjectile.h"
#import "SPACEFaction.h"

@implementation SPACEShip

-(instancetype)initWithImageNamed:(NSString *)name {
	if ((self = [super initWithImageNamed:name])) {
		self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
		self.physicsBody.friction = 0;
		self.physicsBody.angularDamping = 0;
		self.physicsBody.mass = 100;
		self.texture.filteringMode = SKTextureFilteringNearest;
		self.angularMagnitude = 10;
		self.linearMagnitude = 10000;
	}
	return self;
}

+(instancetype) randomFighterOfFaction: (SPACEFaction*)faction {
	SPACEShip *ship = [SPACEShip new];
	
	while (!((ship.position.x < -500 || ship.position.x > 500) && (ship.position.y < -500 || ship.position.y > 500))) {
		ship.position = CGPointMake(SPACERandomInInterval(-1000, 1000), SPACERandomInInterval(-1000, 1000));
	}
	
	ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
	ship.physicsBody.friction = 0;
	ship.physicsBody.angularDamping = 0;
	ship.physicsBody.mass = 100;
	ship.angularMagnitude = 10;
	ship.linearMagnitude = 10000;
	
	ship.faction = faction;
	
	//Switch faction's parts too NSString, derive the image name from the faction and declare the sprites here!!!
	
	ship.wings = [SKSpriteNode spriteNodeWithImageNamed:faction.wingSpriteName];
	ship.wings.texture.filteringMode = SKTextureFilteringNearest;
	ship.wings.colorBlendFactor = 1;
	ship.wings.color = [SKColor colorWithRed:(faction.shipColour.redComponent - 0.1) green:(faction.shipColour.greenComponent - 0.1) blue:(faction.shipColour.blueComponent - 0.1) alpha:1];
	
	ship.hull = [SKSpriteNode spriteNodeWithImageNamed:faction.hullSpriteName];
	ship.hull.texture.filteringMode = SKTextureFilteringNearest;
	ship.hull.colorBlendFactor = 1;
	ship.hull.color = faction.shipColour;
	
	ship.thruster = [SKSpriteNode spriteNodeWithImageNamed:faction.thrusterSpriteName];
	ship.thruster.texture.filteringMode = SKTextureFilteringNearest;

	[ship addChild: ship.wings];
	[ship addChild: ship.thruster];
	[ship addChild: ship.hull];
	
	return ship;
}

+(instancetype) randomFighterWithColour: (SKColor*)shipColour {
	SPACEShip *ship = [SPACEShip new];
	//Eventually this will be done in a factions class, and then handed to all ships in said faction.
	
	while (!((ship.position.x < -500 || ship.position.x > 500) && (ship.position.y < -500 || ship.position.y > 500))) {
		ship.position = CGPointMake(SPACERandomInInterval(-1000, 1000), SPACERandomInInterval(-1000, 1000));
	}
	
	ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
	ship.physicsBody.friction = 0;
	ship.physicsBody.angularDamping = 0;
	ship.physicsBody.mass = 100;
	ship.angularMagnitude = 10;
	ship.linearMagnitude = 10000;
	ship.allegiance = SPACERandomIntegerInInterval(1, 3);
	
	
	
	
	
	[ship addChild: ship.wings];
	[ship addChild: ship.thruster];
	[ship addChild: ship.hull];
	
	return ship;
}


@dynamic scene;


-(void) releaseDirectionalThrusters {
	self.physicsBody.angularVelocity = 0;
}

-(void) activateDirectionalThrustersRight {
	[self.physicsBody applyTorque:-self.angularMagnitude];
}

-(void) activateDirectionalThrustersLeft {
	[self.physicsBody applyTorque:self.angularMagnitude];
}

-(void) activateThrusters {
	CGVector force = (CGVector){
		.dx = -sin(self.zRotation) * self.linearMagnitude,
		.dy = cos(self.zRotation) * self.linearMagnitude,
	};
	[self.physicsBody applyForce:force];
}

-(void) fireLaser {
	SPACEProjectile *laser = [SPACEProjectile laserOriginatingFromNode:self];
	laser.faction = self.faction;
	[self.scene.laserManager addChild:laser];
	laser.physicsBody.velocity = self.physicsBody.velocity;
	[laser.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = self.zRotation, .r = self.linearMagnitude })];
}

-(void) fireMissileAtPoint: (CGPoint)destination {
	CGPoint relativePoint = SPACESubtractPoint(destination, self.position);
	CGFloat firingAngle = SPACEPolarPointWithPoint(relativePoint).phi;
	
	SPACEProjectile *missile = [SPACEProjectile missileOriginatingFromNode:self];
	missile.faction = self.faction;
	
	[self.scene.laserManager addChild:missile];
	missile.physicsBody.velocity = self.physicsBody.velocity;
	missile.zRotation = firingAngle;
	[missile.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = firingAngle, .r = self.linearMagnitude })];
}


-(void) runAutoPilot {
	[self releaseDirectionalThrusters];
	
	
	SPACEShip *closestEnemy = NULL;
	for (SPACEShip *ship in self.scene.AIShips) {
		
			if (ship.faction != self.faction) {
				if (closestEnemy == NULL) {
					closestEnemy = ship;
				}
				else if (SPACEDistanceBetweenPoints(ship.position, self.position) < SPACEDistanceBetweenPoints(closestEnemy.position, self.position)) {
					closestEnemy = ship;
				}
			}
		
	}
	
	if (closestEnemy != NULL) {
		[self huntShip:closestEnemy];
	}
	else {
		[self wander];
	}
}

-(void) huntShip: (SPACEShip*) ship {
	[self goToPoint:ship.position];
	if (self.currentAngle > (self.angleToFace - 0.1) && self.currentAngle < (self.angleToFace + 0.1)) {
		[self fireLaser];
	}
	if (SPACERandomIntegerInInterval(1, 1000) == 1) {
		[self fireMissileAtPoint:ship.position];
	}
}

-(void) wander {
	NSUInteger action = SPACERandomIntegerInInterval(1, 100);
	if (action <= 35) {
		[self activateDirectionalThrustersLeft];
	}
	else if (action <= 70) {
		[self activateDirectionalThrustersRight];
	}
	else {
		[self activateThrusters];
	}
}

-(void) goToPoint: (CGPoint) destination {
	self.relativePoint = SPACESubtractPoint(destination, self.position);
	self.angleToFace = SPACEPolarPointWithPoint(self.relativePoint).phi;
	self.currentAngle = self.zRotation;
	if (self.currentAngle < (self.angleToFace - 0.2)) {
		[self activateDirectionalThrustersLeft];
	}
	else if (self.currentAngle > (self.angleToFace + 0.2)) {
		[self activateDirectionalThrustersRight];
	}
	else {
		[self activateThrusters];
	}
}



//WIP AI rework
-(SPACEShip*) target:(bool) useSuperior {
	SPACEShip *targetShip = NULL;
	
	for (SPACEShip *ship in self.scene.AIShips) {
		
		if (ship.faction != self.faction) {
			if (targetShip == NULL) {
				targetShip = ship;
			}
			else {
				NSString *priority = (useSuperior) ? self.superiorPriority : self.targetPriority;
				if ([priority  isEqual: @"Closest"]) {
					if (SPACEDistanceBetweenPoints(ship.position, self.position) < SPACEDistanceBetweenPoints(targetShip.position, self.position)) {
						targetShip = ship;
					}
				}
				else if ([priority isEqual: @"Value"]) {
					
				}
			}
		}
	}
	return targetShip;
}

@end

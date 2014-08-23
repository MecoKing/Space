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
#import "SPACEStat.h"

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
	
	ship.name = @"Bob";
	
	while (!((ship.position.x < -500 || ship.position.x > 500) && (ship.position.y < -500 || ship.position.y > 500))) {
		ship.position = CGPointMake(SPACERandomInInterval(-1000, 1000), SPACERandomInInterval(-1000, 1000));
	}
	
	ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
	ship.physicsBody.friction = 0;
	ship.physicsBody.angularDamping = 0;
	ship.physicsBody.mass = 100;
	ship.angularMagnitude = 10;
	ship.linearMagnitude = 10000;
	
	ship.health = SPACERandomInInterval(1, 4);
	ship.rank = SPACERandomIntegerInInterval(1, 10);
	ship.value = SPACERandomIntegerInInterval(50, 100);
	
	ship.faction = faction;
	
	NSArray *possiblePriorities = @[
		@"Closest",
		@"Value",
		@"Rank",
		@"Nothing",
		];
	ship.targetPriority = possiblePriorities[SPACERandomIntegerInInterval(0, possiblePriorities.count - 1)];
	
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
	
	ship.statDisplay = [SPACEStat statsForShip:ship];
//	[ship addChild:ship.statDisplay];
	
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
	SPACEProjectile *laser = [SPACEProjectile laserOriginatingFromNode:self withFaction:self.faction];
	laser.faction = self.faction;
	[self.scene.laserManager addChild:laser];
	laser.physicsBody.velocity = self.physicsBody.velocity;
	[laser.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = self.zRotation, .r = self.linearMagnitude })];
}

-(void) fireMissileAtPoint: (CGPoint)destination {
	CGPoint relativePoint = SPACESubtractPoint(destination, self.position);
	CGFloat firingAngle = SPACEPolarPointWithPoint(relativePoint).phi;
	
	SPACEProjectile *missile = [SPACEProjectile missileOriginatingFromNode:self withFaction:self.faction];
	missile.faction = self.faction;
	
	[self.scene.laserManager addChild:missile];
	missile.physicsBody.velocity = self.physicsBody.velocity;
	missile.zRotation = firingAngle;
	[missile.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = firingAngle, .r = self.linearMagnitude })];
}

-(void) runAutoPilot {
	[self releaseDirectionalThrusters];
	
	
	SPACEShip *target = [self targetShipByPriority:self.targetPriority];
	
	
	if (target != NULL) {
		[self huntShip:target];
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

-(void) updateShipStats {
	[self.statDisplay updateAllShipStats];
}


//WIP AI rework
-(SPACEShip*) targetShipByPriority:(NSString*)priority {
	SPACEShip *targetShip = NULL;
	
	for (SPACEShip *ship in self.scene.ships) {
		
		if (ship.faction != self.faction) {
			if (targetShip == NULL) {
				targetShip = ship;
			}
			else {
				
				/*
				 Closest
				 Value
				 Speed
				 Rank
				 Health
				 Shields
				 Weapons
				 Energy
				*/
				if ([priority  isEqual: @"Closest"]) {
					if (SPACEDistanceBetweenPoints(ship.position, self.position) < SPACEDistanceBetweenPoints(targetShip.position, self.position)) {
						targetShip = ship;
					}
				}
				else if ([priority isEqual: @"Value"]) {
					if (ship.value > targetShip.value) {
						targetShip = ship;
					}
					//In case of ties...
					//should eventually check the captain's priority and break ties with the ship's priority...
					else if (ship.value == targetShip.value) {
						if (SPACEDistanceBetweenPoints(ship.position, self.position) < SPACEDistanceBetweenPoints(targetShip.position, self.position)) {
							targetShip = ship;
						}
					}
				}
				else if ([priority isEqual: @"Rank"]) {
					if (ship.rank > targetShip.rank) {
						targetShip = ship;
					}
					//In case of ties...
					//should eventually check the captain's priority and break ties with the ship's priority...
					else if (ship.rank == targetShip.rank) {
						if (SPACEDistanceBetweenPoints(ship.position, self.position) < SPACEDistanceBetweenPoints(targetShip.position, self.position)) {
							targetShip = ship;
						}
					}
				}
				else {
					return NULL;
				}
			}
		}
	}
	return targetShip;
}

@end

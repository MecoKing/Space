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
#import "SPACEShipPart.h"

@implementation SPACEShip

@dynamic scene;

#pragma mark Instance Methods

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
	
	ship.name = [NSString stringWithFormat:(@"%@%lu"), SPACERandomName(), (unsigned long)SPACERandomIntegerInInterval(0, 999)];
	
	while (!((ship.position.x < -500 || ship.position.x > 500) && (ship.position.y < -500 || ship.position.y > 500))) {
		ship.position = CGPointMake(SPACERandomInInterval(-2000, 2000), SPACERandomInInterval(-2000, 2000));
	}
	
	ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
	ship.physicsBody.friction = 0;
	ship.physicsBody.angularDamping = 0;
	ship.physicsBody.mass = 100;
	ship.angularMagnitude = 10;
	ship.linearMagnitude = 10000;
	
	ship.physicsBody.categoryBitMask = shipCategory;
	ship.physicsBody.contactTestBitMask = shipCategory | stellarBodyCategory;
	ship.physicsBody.collisionBitMask = shipCategory | stellarBodyCategory;
	
	ship.faction = faction;
	
	ship.health = 3;
	ship.rank = SPACERandomIntegerInInterval(1, 10);
	ship.value = SPACERandomIntegerInInterval(0, 50) + faction.wingPart.value + faction.hullPart.value + faction.thrusterPart.value;
	
	ship.priority = ship.faction.priority;
	NSArray *possiblePriorities = @[
		@"Closest",
		@"Value",
		@"Rank",
		@"Health",
		@"Nothing",
		];
	while (ship.priority == ship.faction.priority) {
		ship.priority = possiblePriorities[SPACERandomIntegerInInterval(0, possiblePriorities.count - 1)];
	}
	
	ship.wings = [SKShapeNode shapeNodeWithPath:faction.wingPart.shape];
	ship.wings.fillColor = [SKColor colorWithRed:(faction.shipColour.redComponent - 0.1) green:(faction.shipColour.greenComponent - 0.1) blue:(faction.shipColour.blueComponent - 0.1) alpha:1];
	ship.wings.strokeColor = ship.wings.fillColor;
	
	ship.hull = [SKShapeNode shapeNodeWithPath:faction.hullPart.shape];
	ship.hull.fillColor = faction.shipColour;
	ship.hull.strokeColor = faction.shipColour;
	
	CGFloat grayScale = SPACERandomInInterval(0.2, 0.8);
	ship.thruster = [SKShapeNode shapeNodeWithPath:faction.thrusterPart.shape];
	ship.thruster.fillColor = [SKColor colorWithRed:grayScale green:grayScale blue:grayScale alpha:1.0];
	ship.thruster.strokeColor = ship.thruster.fillColor;
	
	[ship addChild: ship.wings];
	[ship addChild: ship.thruster];
	[ship addChild: ship.hull];
	return ship;
}

#pragma mark
#pragma mark Actions
#pragma mark -General
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
	SPACEProjectile *laser = [SPACEProjectile laserOriginatingFromShip:self];
	[self.myScene.laserManager addChild:laser];
	laser.physicsBody.velocity = self.physicsBody.velocity;
	[laser.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = self.zRotation, .r = self.linearMagnitude })];
}

-(void) fireMissileAtPoint: (CGPoint)destination {
	CGPoint relativePoint = SPACESubtractPoint(destination, self.position);
	CGFloat firingAngle = SPACEPolarPointWithPoint(relativePoint).phi;
	
	SPACEProjectile *missile = [SPACEProjectile missileOriginatingFromShip:self];
	
	[self.myScene.laserManager addChild:missile];
	missile.physicsBody.velocity = self.physicsBody.velocity;
	missile.zRotation = firingAngle;
	[missile.physicsBody applyForce:SPACEVectorWithPolarPoint((SPACEPolarPoint){ .phi = firingAngle, .r = self.linearMagnitude })];
}

#pragma mark -AI

-(void) huntShip: (SPACEShip*) ship {
	[self goToPoint:ship.position];
	if (self.currentAngle > (self.angleToFace - 0.1) && self.currentAngle < (self.angleToFace + 0.1)) {
		if (SPACEDistanceBetweenPoints(self.position, ship.position) <= self.scene.size.width) [self fireLaser];
	}
	if (SPACERandomIntegerInInterval(1, 1000) == 1) {
		if (SPACEDistanceBetweenPoints(self.position, ship.position) <= self.scene.size.width) [self fireMissileAtPoint:ship.position];
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

#pragma mark
#pragma mark AI

-(void) runAutoPilot {
	[self releaseDirectionalThrusters];
	
	if ([self target] != nil) {
		[self huntShip:[self target]];
	}
	else {
		[self wander];
	}
}

-(SPACEShip*) target {
	SPACEShip *targetShip = NULL;
	
	for (SPACEShip *ship in self.myScene.ships) {
		if (ship.faction != self.faction) {
			if (targetShip == NULL) {
				targetShip = ship;
			}
			else {
				/*
				 Closest [x]
				 Value   [x]
				 Speed   [ ]
				 Rank    [x]
				 Health  [x]
				 Shields [ ]
				 Weapons [ ]
				 Energy  [ ]
				*/
				targetShip = [self testShip:ship againstShip:targetShip withPriority:self.faction.priority];
				if (targetShip == nil) {
					targetShip = [self testShip:ship againstShip:targetShip withPriority:self.priority];
				}

			}
		}
	}
	return targetShip;
}

-(SPACEShip*) testShip:(SPACEShip*)shipA againstShip:(SPACEShip*)shipB withPriority:(NSString*)priority {
	if ([priority isEqual:@"Closest"]) {
		if (SPACEDistanceBetweenPoints(shipA.position, self.position) == SPACEDistanceBetweenPoints(shipB.position, self.position)) return nil;
		else if (SPACEDistanceBetweenPoints(shipA.position, self.position) < SPACEDistanceBetweenPoints(shipB.position, self.position)) return shipA;
	}
	else if ([priority isEqual:@"Value"]) {
		if (shipA.value == shipB.value) return nil;
		else if (shipA.value > shipB.value) return shipA;
	}
	else if ([priority isEqual:@"Rank"]) {
		if (shipA.rank == shipB.rank) return nil;
		else if (shipA.rank > shipB.rank) return shipA;
	}
	else if ([priority isEqual:@"Health"]) {
		if (shipA.health == shipB.health) return nil;
		else if (shipA.health > shipB.health) return shipA;
	}
	return shipB;
}

@end

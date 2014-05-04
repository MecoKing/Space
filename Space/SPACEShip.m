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
		self.allegiance = SPACERandomIntegerInInterval(1, 3);
	}
	return self;
}

+(instancetype) shipWithImageNamed: (NSString*)imageName {
	return [[self alloc] initWithImageNamed:imageName];
}

+(instancetype) randomShip {
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
	
	
	ship.hullImages = @[
		@"SingleHull",
		@"NeedleHull",
		@"SplitHull"
	];
	ship.wingImages = @[
		@"HawkWings",
		@"SlicerWings",
		@"ZipperWings"
	];
	ship.thrustImages = @[
		@"IonThruster",
		@"TwinIonThruster",
		@"TriFusionThruster"
	];
	//Eventually different parts will have different stats (Weight, Speed, Durability)
	
	SKColor *shipColour = SPACERandomDarkColour();
	ship.sprite = [SKSpriteNode spriteNodeWithImageNamed:ship.wingImages[SPACERandomIntegerInInterval(0, 2)]];
	ship.sprite.texture.filteringMode = SKTextureFilteringNearest;
	ship.sprite.colorBlendFactor = 1;
	ship.sprite.color = [SKColor colorWithRed:(shipColour.redComponent - 0.1) green:(shipColour.greenComponent - 0.1) blue:(shipColour.blueComponent - 0.1) alpha:1];
	
	SKSpriteNode *hull = [SKSpriteNode spriteNodeWithImageNamed:ship.hullImages[SPACERandomIntegerInInterval(0, 2)]];
	hull.texture.filteringMode = SKTextureFilteringNearest;
	hull.colorBlendFactor = 1;
	hull.color = shipColour;
	
	SKSpriteNode *thruster = [SKSpriteNode spriteNodeWithImageNamed:ship.thrustImages[SPACERandomIntegerInInterval(0, 2)]];
	thruster.texture.filteringMode = SKTextureFilteringNearest;
	
	
	[ship addChild: ship.sprite];
	[ship addChild: thruster];
	[ship addChild: hull];
	
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
		if (self.allegiance == 1) {
			if (ship.allegiance == 3) {
				if (closestEnemy == NULL) {
					closestEnemy = ship;
				}
				else if (SPACEDistanceBetweenPoints(ship.position, self.position) < SPACEDistanceBetweenPoints(closestEnemy.position, self.position)) {
					closestEnemy = ship;
				}
			}
		}
		else if (self.allegiance == 3) {
			if (ship.allegiance == 1) {
				if (closestEnemy == NULL) {
					closestEnemy = ship;
				}
				else if (SPACEDistanceBetweenPoints(ship.position, self.position) < SPACEDistanceBetweenPoints(closestEnemy.position, self.position)) {
					closestEnemy = ship;
				}
			}
		}
	}
	
	if (self.allegiance == 3) {
		if (closestEnemy == NULL) {
			closestEnemy = self.scene.playerShip;
		}
		else if (SPACEDistanceBetweenPoints(self.scene.playerShip.position, self.position) < SPACEDistanceBetweenPoints(closestEnemy.position, self.position)) {
			closestEnemy = self.scene.playerShip;
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

@end

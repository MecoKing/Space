//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEProjectile.h"
#import "SPACEFunction.h"
#import "SPACEMyScene.h"
#import "SPACEShip.h"

@implementation SPACEProjectile

+(instancetype)missileOriginatingFromShip:(SPACEShip *)ship {
	SPACEProjectile *missile = [self spriteNodeWithImageNamed:@"Missile"];
	missile.position = ship.position;
	missile.physicsBody.mass = 10;
	missile.physicsBody.categoryBitMask = projectileCategory;
	missile.physicsBody.contactTestBitMask = shipCategory | stellarBodyCategory;
	missile.faction = ship.faction;
	missile.owner = ship;
	return missile;
}

+(instancetype)laserOriginatingFromShip:(SPACEShip *)ship {
	SPACEProjectile *laser = [self spriteNodeWithImageNamed:@"Laser"];
	laser.position = ship.position;
	laser.zRotation = ship.zRotation;
	laser.physicsBody.mass = 1;
	laser.physicsBody.categoryBitMask = projectileCategory;
	laser.physicsBody.contactTestBitMask = shipCategory | stellarBodyCategory;
	laser.faction = ship.faction;
	laser.owner = ship;
	return laser;
}


-(instancetype)initWithTexture:(SKTexture *)texture color:(NSColor *)color size:(CGSize)size {
	if ((self = [super initWithTexture:texture color:color size:size])) {
		self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
		self.physicsBody.friction = 0;
		self.physicsBody.angularDamping = 1;
	}
	return self;
}

-(CGFloat) distanceFromClosestShip {
	CGFloat topDistance = 1000000;
	for (SPACEShip *ship in self.scene.ships) {
		if (topDistance == 1000000) topDistance = SPACEDistanceBetweenPoints(self.position, ship.position);
		else if (SPACEDistanceBetweenPoints(self.position, ship.position) < topDistance) topDistance = SPACEDistanceBetweenPoints(self.position, ship.position);
	}
	return topDistance;
}

@end

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

@end

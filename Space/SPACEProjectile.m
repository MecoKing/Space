//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEProjectile.h"
#import "SPACEFunction.h"
#import "SPACEMyScene.h"

@implementation SPACEProjectile

+(instancetype)missileOriginatingFromNode:(SKNode *)node withFaction:(SPACEFaction*)faction {
	SPACEProjectile *missile = [self spriteNodeWithImageNamed:@"Missile"];
	missile.position = node.position;
	missile.physicsBody.mass = 10;
	missile.physicsBody.categoryBitMask = projectileCategory;
	missile.physicsBody.contactTestBitMask = shipCategory | stellarBodyCategory;
	missile.faction = faction;
	return missile;
}

+(instancetype)laserOriginatingFromNode:(SKNode *)node withFaction:(SPACEFaction*)faction {
	SPACEProjectile *laser = [self spriteNodeWithImageNamed:@"Laser"];
	laser.position = CGPointMake(node.position.x, node.position.y + 15);
	laser.zRotation = node.zRotation;
	laser.physicsBody.mass = 1;
	laser.physicsBody.categoryBitMask = projectileCategory;
	laser.physicsBody.contactTestBitMask = shipCategory | stellarBodyCategory;
	laser.faction = faction;
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

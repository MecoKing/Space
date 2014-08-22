//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEProjectile.h"
#import "SPACEFunction.h"

@implementation SPACEProjectile

+(instancetype)missileOriginatingFromNode:(SKNode *)node withFaction:(SPACEFaction*)faction {
	SPACEProjectile *missile = [self spriteNodeWithImageNamed:@"Missile"];
	missile.position = node.position;
	missile.physicsBody.mass = 10;
	missile.faction = faction;
	return missile;
}

+(instancetype)laserOriginatingFromNode:(SKNode *)node withFaction:(SPACEFaction*)faction {
	SPACEProjectile *laser = [self spriteNodeWithImageNamed:@"Laser"];
	laser.position = node.position;
	laser.zRotation = node.zRotation;
	laser.physicsBody.mass = 1;
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

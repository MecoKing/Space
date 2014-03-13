//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEStar.h"
#import "SPACEFunction.h"

@implementation SPACEStar {
	SKShapeNode *_shape;
}

+(instancetype)starWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(SKColor *)colour {
	return [[self alloc] initWithRadius:radius mass:mass colour:colour];
}

-(instancetype)initWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(SKColor *)colour {
	if ((self = [super init])) {
		_radius = radius;
		
		CGRect bounds = {
			.origin.x = -_radius, .origin.y = -_radius,
			.size.width = _radius * 2, .size.height = _radius * 2
		};
		
		_shape = [SKShapeNode new];
		CGPathRef path = CGPathCreateWithEllipseInRect(bounds, NULL);
		_shape.path = path;
		CGPathRelease(path);
		
		_shape.fillColor = colour;
		SKColor *coronaColour = [[colour blendedColorWithFraction:0.25 ofColor:[SKColor whiteColor]] colorWithAlphaComponent:0.75];
		_shape.strokeColor = coronaColour;
		
		CGFloat coronaRatio = SPACERandomInInterval(0.3, 0.45);
		_shape.glowWidth = radius * coronaRatio;
		
		self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
		self.physicsBody.mass = mass;
		CGFloat area = M_PI * radius * radius;
		self.physicsBody.density = self.mass / area;
		
		self.physicsBody.friction = 0;
		self.physicsBody.angularDamping = 0;
		
		[self addChild:_shape];
	}
	return self;
}


+(instancetype)randomSuperGiant {
	return [self starWithRadius:SPACERandomInInterval(400, 600) mass:SPACERandomInInterval(1.5e31, 2.2e31) colour:[SKColor colorWithRed:SPACERandomInInterval(0.75, 1) green:SPACERandomInInterval(0.45, 0.55) blue:0.2 alpha:1]];
}

+(instancetype)randomRedGiant {
	return [self starWithRadius:SPACERandomInInterval(250, 400) mass:SPACERandomInInterval(2.4e30, 3e30) colour:[SKColor colorWithRed:SPACERandomInInterval(0.5, 1) green:SPACERandomInInterval(0, 0.1) blue:SPACERandomInInterval(0, 0.1) alpha:1]];
}

+(instancetype)randomWhiteDwarf {
	return [self starWithRadius:SPACERandomInInterval(150, 250) mass:SPACERandomInInterval(2e30, 2.1e30) colour:[SKColor colorWithRed:SPACERandomInInterval(0.8, 1) green:SPACERandomInInterval(0.8, 1) blue:SPACERandomInInterval(0.8, 1) alpha:1]];
}


-(CGFloat)mass {
	return self.physicsBody.mass;
}


-(NSColor *)colour {
	return _shape.fillColor;
}

@end

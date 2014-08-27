//
//  SPACEStellarBody.m
//  Space
//
//  Created by [pixelmonster] on 2/5/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEStellarBody.h"
#import "SPACEFunction.h"
#import "SPACEStar.h"
#import "SPACEMyScene.h"

@implementation SPACEStellarBody {
	SKShapeNode *_shape;
}

+(instancetype)bodyWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(NSColor *)colour haloWidthRatio:(CGFloat)haloWidthRatio {
	return [[self alloc] initWithRadius:radius mass:mass colour:colour haloWidthRatio:haloWidthRatio];
}

-(instancetype)initWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(SKColor *)colour haloWidthRatio:(CGFloat)haloWidthRatio {
	if ((self = [super init])) {
		_radius = radius;
		_haloWidthRatio = haloWidthRatio;
		
		_colour = colour;
		
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
		
		_shape.glowWidth = radius * haloWidthRatio;
		
		[self addChild:_shape];
		
		
		self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
		self.physicsBody.mass = mass;
		CGFloat area = M_PI * radius * radius;
		self.physicsBody.density = self.mass / area;
		
		self.physicsBody.friction = 0;
		self.physicsBody.angularDamping = 0;
		
		
		self.physicsBody.categoryBitMask = stellarBodyCategory;
		self.physicsBody.contactTestBitMask = shipCategory;
		self.physicsBody.collisionBitMask = stellarBodyCategory;
	}
	return self;
}


-(CGFloat)mass {
	return self.physicsBody.mass;
}


-(NSColor *)haloColour {
	return nil;
}


#pragma mark SKBarycentre

-(void)updateWithSystem:(SPACESystem *)origin overInterval:(CFTimeInterval)time {}

@end

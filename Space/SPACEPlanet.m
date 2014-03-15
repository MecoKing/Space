//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import "SPACEPlanet.h"
#import "SPACEFunction.h"
#import "SPACEMyScene.h"
#import "SPACESystem.h"

@implementation SPACEPlanet {
	SKSpriteNode *sprite;
}

+(SKView *)textureRenderingView {
	static SKView *view;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		view = [[SKView alloc] initWithFrame:(NSRect){ .size.width = 1000, .size.height = 1000 }];
	});
	return view;
}

-(instancetype)initWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(NSColor *)colour haloWidthRatio:(CGFloat)haloWidthRatio texture:(SKTexture *)texture {
	if ((self = [super initWithRadius:radius mass:mass colour:colour haloWidthRatio:haloWidthRatio])) {
		_texture = texture;
		
		CGSize size = { .width = radius * 2, .height = radius * 2 };
		
		SKCropNode *crop = [SKCropNode node];
		
		SKSpriteNode *textureNode = [SKSpriteNode spriteNodeWithTexture:texture size:size];
		textureNode.color = self.colour;
		textureNode.texture.filteringMode = SKTextureFilteringNearest;
//		textureNode.blendMode = SKBlendModeScreen;
		[crop addChild:textureNode];
		
		SKShapeNode *mask = [SKShapeNode node];
		mask.fillColor = [SKColor whiteColor];
		mask.strokeColor = [SKColor clearColor];
		
		CGPathRef path = CGPathCreateWithEllipseInRect((CGRect){ .origin.x = -radius, .origin.y = -radius, .size = size }, NULL);
		mask.path = path;
		CGPathRelease(path);
		
        SKShapeNode *shadow = [SKShapeNode new];
        shadow.path = mask.path;
        shadow.fillColor = [SKColor colorWithCalibratedWhite:0 alpha:0.99];
        shadow.strokeColor = [SKColor colorWithCalibratedWhite:0 alpha:0.9];
        shadow.glowWidth = shadow.frame.size.width * 0.2;
        
        CGSize containerSize = {
            .width = size.width * 1.4,
            .height = size.height * 1.4,
        };
        SKSpriteNode *shadowContainer = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:containerSize];
        [shadowContainer addChild:shadow];
        
		crop.maskNode = [SKSpriteNode spriteNodeWithTexture:[[self.class textureRenderingView] textureFromNode:mask]];
        
        self.shadow = [SKSpriteNode spriteNodeWithTexture:[[self.class textureRenderingView] textureFromNode:shadowContainer]];
        [crop addChild:self.shadow];
		[self addChild:crop];
	}
	return self;
}


+(instancetype)randomMoon {
	SPACEPlanet *planet = [[self alloc] initWithRadius:SPACERandomInInterval(5, 15) mass:SPACERandomInInterval(1e15, 1e23) colour:SPACEAverageDarkColour() haloWidthRatio:0 texture:nil];
	planet.name = @"Moon";
	return planet;
}

+(instancetype)randomTerrestrialPlanet {
    NSArray *planetTextures = @[ @"TerraPlanetTexture01", @"TerraPlanetTexture02", @"TerraPlanetTexture03" ];
	SPACEPlanet *planet = [[self alloc] initWithRadius:SPACERandomInInterval(20, 50) mass:SPACERandomInInterval(2e23, 2e25) colour:SPACEAverageDarkColour() haloWidthRatio:SPACERandomInInterval(0, 0.15) texture:[SKTexture textureWithImageNamed:planetTextures[SPACERandomIntegerInInterval(0, 2)]]];
	planet.name = @"Terrestrial";
	return planet;
}

+(instancetype)randomMoltenPlanet {
    NSArray *planetTextures = @[ @"MoltenPlanetTexture01", @"MoltenPlanetTexture02", @"MoltenPlanetTexture03" ];
	SPACEPlanet *planet = [[self alloc] initWithRadius:SPACERandomInInterval(20, 50) mass:SPACERandomInInterval(2e25, 2e27) colour:SPACEAverageDarkColour() haloWidthRatio:SPACERandomInInterval(0, 0.1) texture:[SKTexture textureWithImageNamed:planetTextures[SPACERandomIntegerInInterval(0, 2)]]];
	planet.name = @"Molten";
	return planet;
}

+(instancetype)randomGasGiant {
    NSArray *planetTextures = @[ @"GasPlanetTexture01", @"GasPlanetTexture02", @"GasPlanetTexture03" ];
	SPACEPlanet *planet = [[self alloc] initWithRadius:SPACERandomInInterval(60, 100) mass:SPACERandomInInterval(1e25, 1e27) colour:SPACEAverageDarkColour() haloWidthRatio:SPACERandomInInterval(0, 0.2) texture:[SKTexture textureWithImageNamed:planetTextures[SPACERandomIntegerInInterval(0, 2)]]];
	planet.name = @"Gas Giant";
	return planet;
}


#pragma mark Properties

@synthesize haloColour = _haloColour;

-(NSColor *)haloColour {
	return _haloColour ?: (_haloColour = [[self.colour blendedColorWithFraction:0.75 ofColor:[SKColor colorWithRed:0.73 green:0.81 blue:1 alpha:1]] colorWithAlphaComponent:0.25]);
}


#pragma mark SKBarycentre

-(void)updateWithSystem:(SPACESystem *)origin overInterval:(CFTimeInterval)time {
    //Today I speak good english yes.
    SKNode *node = self;
    CGFloat totalRotation = 0;
    
    while (node != origin) {
        totalRotation += node.zRotation;
        node = node.parent;
    }
    SPACEPolarPoint polarPoint = SPACEPolarPointWithPoint(SPACEMultiplyPointByScalar(SPACENormalizePoint(SPACESubtractPoint(origin.position, [origin convertPoint:self.position fromNode:self])), -0.5 * self.radius));
    polarPoint.phi -= totalRotation;
    self.shadow.position = SPACEPointWithPolarPoint(polarPoint);
}

@end

//
//  SPACEHUD.m
//  Space
//
//  Created by [pixelmonster] on 2014-03-15.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEMyScene.h"
#import "SPACEHUD.h"
#import "SPACEFunction.h"
#import "SPACEShip.h"
#import "SPACEFaction.h"
#import "SPACESystem.h"
#import "SPACEPlanet.h"

@implementation SPACEHUD

@dynamic scene;

#pragma mark Instance Methods

+(instancetype) compassHUDWithColour:(SKColor*)colour atPosition: (CGPoint) position {
	SPACEHUD *HUD = [SPACEHUD new];
	
	HUD.colour = [SKColor colorWithRed:colour.redComponent green:colour.greenComponent blue:colour.blueComponent alpha:0.5];
	
	HUD.compass = [SKShapeNode new];
	CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(position.x, position.y, 300, 300), NULL);
	HUD.compass.path = path;
	CGPathRelease(path);
	
	HUD.compass.strokeColor = HUD.colour;
	HUD.compass.glowWidth = 5;
	
	[HUD addChild:HUD.compass];
	
	return HUD;
}

+(instancetype) engineHUDWithColour:(SKColor*)colour atPosition: (CGPoint)position {
	SPACEHUD *HUD = [SPACEHUD new];
	HUD.colour = colour;
	HUD.thrusterCapacity = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	HUD.thrusterCapacity.fontColor = HUD.colour;
	HUD.thrusterCapacity.fontSize = 16;
	HUD.thrusterCapacity.position = position;
	[HUD addChild:HUD.thrusterCapacity];
	return HUD;
}

#pragma mark
#pragma mark CompassHUD

-(void) drawCompassDots {
	CGPathRef starDotPath = CGPathCreateWithEllipseInRect(CGRectMake(self.compass.position.x - 15, self.compass.position.y - 15, 30, 30), NULL);
	CGPathRef shipDotPath = CGPathCreateWithEllipseInRect(CGRectMake(self.compass.position.x - 5, self.compass.position.y - 5, 10, 10), NULL);
	CGPathRef planetDotPath = CGPathCreateWithEllipseInRect(CGRectMake(self.compass.position.x -10, self.compass.position.y - 10, 20, 20), NULL);

	for (SPACEShip *ship in self.scene.ships) {
		[self solidDotForShip:ship withFaction:ship.faction andPath:shipDotPath];
	}
	[self solidDotForNode:self.scene.system withColour:self.colour path:starDotPath andGlow:YES];
	for (SPACESystem *planet in self.scene.system.satellites) {
		[self solidDotForNode:planet withColour:[SKColor colorWithWhite:0.1 alpha:1.0] path:planetDotPath andGlow:NO];
	}
}

-(void) solidDotForNode:(SKNode*)node withColour:(SKColor*)colour path:(CGPathRef)path andGlow:(bool)hasGlow {
	SKShapeNode *dot = [SKShapeNode new];
	dot.path = path;
	dot.fillColor = colour;
	if (hasGlow) dot.strokeColor = colour;
	else dot.strokeColor = [SKColor clearColor];
	dot.glowWidth = 3;
	SPACEPolarPoint polarPoint = SPACEPolarPointWithPoint(SPACEMultiplyPointByScalar(SPACENormalizePoint(SPACESubtractPoint(node.position, self.scene.playerShip.position)), 150));
	dot.position = SPACEPointWithPolarPoint(polarPoint);
	[self.compass addChild:dot];
}
-(void) solidDotForShip:(SPACEShip*)ship withFaction:(SPACEFaction*)faction andPath:(CGPathRef)path {
	SKShapeNode *dot = [SKShapeNode new];
	dot.path = path;
	dot.fillColor = faction.shipColour;
	if (faction == self.scene.playerShip.faction) dot.strokeColor = [SKColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
	else dot.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
	dot.glowWidth = 0.05;
	SPACEPolarPoint polarPoint = SPACEPolarPointWithPoint(SPACEMultiplyPointByScalar(SPACENormalizePoint(SPACESubtractPoint(ship.position, self.scene.playerShip.position)), 150));
	dot.position = SPACEPointWithPolarPoint(polarPoint);
	[self.compass addChild:dot];
}

-(void) updateDotsOnCompass {
	[self.compass removeAllChildren];
	[self drawCompassDots];
}

#pragma mark
#pragma mark EngineHUD

-(void) updateEngineHUD {
	self.thrusterCapacity.text = [NSString stringWithFormat:@"EnginePower: %i%%", self.scene.playerEnginePower];
}

@end

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
#import "SPACEShipPart.h"

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

+(instancetype) factionHUDWithColour:(SKColor*)colour forFaction:(SPACEFaction*)faction atPosition: (CGPoint)position {
	SPACEHUD *HUD = [SPACEHUD new];
	HUD.faction = faction;
	HUD.colour = colour;
	HUD.position = position;
	[HUD updateFactionHUD];
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

#pragma mark
#pragma mark FactionHUD

-(void) updateFactionHUD {
	[self removeAllChildren];
	SKLabelNode *factionNameLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	factionNameLabel.text = self.faction.name;
	factionNameLabel.fontColor = self.faction.shipColour;
	factionNameLabel.fontSize = 12;
	factionNameLabel.position = CGPointMake(self.position.x, self.position.y + 30);
	[self addChild:factionNameLabel];
	SKLabelNode *shipCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	int shipCount = 0;
	for (SPACEShip *ship in self.scene.ships) {
		if (ship.faction == self.faction) {
			shipCount++;
		}
	}
	shipCountLabel.text = [NSString stringWithFormat:(@"Ships Owned: %lu"), (unsigned long)shipCount];
	shipCountLabel.fontColor = self.colour;
	shipCountLabel.fontSize = 12;
	shipCountLabel.position = CGPointMake(self.position.x, self.position.y + 18);
	[self addChild:shipCountLabel];
	SKLabelNode *hullNameLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	hullNameLabel.text = self.faction.hullPart.name;
	hullNameLabel.fontColor = self.colour;
	hullNameLabel.fontSize = 12;
	hullNameLabel.position = CGPointMake(self.position.x, self.position.y + 6);
	[self addChild:hullNameLabel];
	SKLabelNode *wingNameLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	wingNameLabel.text = self.faction.wingPart.name;
	wingNameLabel.fontColor = self.colour;
	wingNameLabel.fontSize = 12;
	wingNameLabel.position = CGPointMake(self.position.x, self.position.y - 6);
	[self addChild:wingNameLabel];
	SKLabelNode *thrusterNameLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	thrusterNameLabel.text = self.faction.thrusterPart.name;
	thrusterNameLabel.fontColor = self.colour;
	thrusterNameLabel.fontSize = 12;
	thrusterNameLabel.position = CGPointMake(self.position.x, self.position.y - 18);
	[self addChild:thrusterNameLabel];
}

@end

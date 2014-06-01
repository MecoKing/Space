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

@implementation SPACEHUD

@dynamic scene;

+(instancetype) compassHUDAtPosition: (CGPoint) position {
	SPACEHUD *HUD = [SPACEHUD new];
	
	HUD.compass = [SKShapeNode new];
	CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(position.x, position.y, 300, 300), NULL);
	HUD.compass.path = path;
	CGPathRelease(path);
	
	HUD.compass.strokeColor = SPACEInverseOfColour(HUD.scene.backgroundColor);
	HUD.compass.strokeColor = [SKColor colorWithRed:HUD.compass.strokeColor.redComponent green:HUD.compass.strokeColor.greenComponent blue:HUD.compass.strokeColor.blueComponent alpha:0.4];
	
	[HUD addChild:HUD.compass];
	
	return HUD;
}

-(void) drawDots {
	CGPathRef starDotPath = CGPathCreateWithEllipseInRect(CGRectMake(self.compass.position.x - 10, self.compass.position.y - 10, 20, 20), NULL);
	CGPathRef shipDotPath = CGPathCreateWithEllipseInRect(CGRectMake(self.compass.position.x - 5, self.compass.position.y - 5, 10, 10), NULL);
	
	SKShapeNode *starDot = [SKShapeNode new];
	starDot.path = starDotPath;
	starDot.strokeColor = self.compass.strokeColor;
	SPACEPolarPoint starPolarPoint = SPACEPolarPointWithPoint(SPACEMultiplyPointByScalar(SPACENormalizePoint(SPACESubtractPoint(self.scene.system.position, self.scene.playerShip.position)), 150));
	starDot.position = SPACEPointWithPolarPoint(starPolarPoint);
	
	[self.compass addChild:starDot];
	
	for (SPACEShip *ship in self.scene.AIShips) {
		SKShapeNode *shipDot = [SKShapeNode new];
		shipDot.path = shipDotPath;
		
		shipDot.fillColor = ship.faction.shipColour;
		
		shipDot.strokeColor = [SKColor clearColor];
		
		
		SPACEPolarPoint shipPolarPoint = SPACEPolarPointWithPoint(SPACEMultiplyPointByScalar(SPACENormalizePoint(SPACESubtractPoint(ship.position, self.scene.playerShip.position)), 150));
		shipDot.position = SPACEPointWithPolarPoint(shipPolarPoint);
		
		
		[self.compass addChild:shipDot];
	}
}

-(void) updateDotsOnCompass {
	[self.compass removeAllChildren];
	[self drawDots];
}

@end

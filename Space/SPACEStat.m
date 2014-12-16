//
//  SPACEStat.m
//  Space
//
//  Created by [pixelmonster] on 2014-08-22.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEStat.h"
#import "SPACEShip.h"
#import "SPACEFaction.h"
#import "SPACEFunction.h"

@implementation SPACEStat

#pragma mark ShipStats

+(instancetype) statsForShip:(SPACEShip*)ship {
	SPACEStat *stat = [SPACEStat new];
	stat.position = ship.position;
	stat.shipObject = ship;
	[stat updateAllShipStats];
	return stat;
}

-(void) printNameInfo {
	[self.title removeFromParent];
	self.title = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	self.title.text = [NSString stringWithFormat:@"%@ - %@",self.shipObject.faction.name, self.shipObject.name];
	self.title.fontColor = self.shipObject.faction.shipColour;
	self.title.fontSize = 10;
	self.title.position = CGPointMake(0, -45);
	[self addChild:self.title];
}
-(void) updateShipStatInfo {
	[self.info removeFromParent];
	self.info = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	self.info.text = [NSString stringWithFormat:@"Value:%lu Rank:%lu", (unsigned long)self.shipObject.value, (unsigned long)self.shipObject.rank];
	self.info.fontColor = SPACEInverseOfColour(self.scene.backgroundColor);
	self.info.fontSize = 10;
	self.info.position = CGPointMake(0, -35);
	[self addChild:self.info];
}
-(void) updateShipTargetInfo {
	[self.target removeFromParent];
	self.target = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	self.target.text = [NSString stringWithFormat:@"Target:%@ FactionTarget:%@", self.shipObject.priority, self.shipObject.faction.priority];
	self.target.fontColor = SPACEInverseOfColour(self.scene.backgroundColor);
	self.target.fontSize = 10;
	self.target.position = CGPointMake(0, -55);
	[self addChild:self.target];
}
-(void) updateHealthBarInfo {
	[self.healthBar removeFromParent];
	CGRect healthFrame = CGRectMake(self.shipObject.health*0.25, 0, 0.25, 1);
	self.healthBar = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithRect:healthFrame inTexture:[SKTexture textureWithImageNamed:@"Healthbar"]]];
	self.healthBar.position = CGPointMake(0, -20);
	self.healthBar.texture.filteringMode = SKTextureFilteringNearest;
	[self addChild:self.healthBar];
}

-(void) updateAllShipStats {
	self.position = [self.parent convertPoint:self.shipObject.position fromNode:self.shipObject.parent];
	self.zRotation = 0;
	[self printNameInfo];
	[self updateHealthBarInfo];
	[self updateShipStatInfo];
	[self updateShipTargetInfo];
}

#pragma mark PlanetStats

@end

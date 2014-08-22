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

@implementation SPACEStat

+(instancetype) statsForShip:(SPACEShip*)ship {
	SPACEStat *stat = [SPACEStat new];
	stat.shipObject = ship;
	stat.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1];
	stat.physicsBody.allowsRotation = false;
	[stat updateAllShipStats];
	return stat;
}

-(void) updateShipStatInfo {
	[self.info removeFromParent];
	self.info = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
	self.info.text = [NSString stringWithFormat:@"Value:%lu Rank:%lu", (unsigned long)self.shipObject.value, (unsigned long)self.shipObject.rank];
	self.info.fontColor = self.shipObject.faction.shipColour;
	self.info.fontSize = 10;
	self.info.position = CGPointMake(0, -35);
	[self addChild:self.info];
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
	[self updateHealthBarInfo];
	[self updateShipStatInfo];
}

@end

//
//  SPACEHUD.h
//  Space
//
//  Created by [pixelmonster] on 2014-03-15.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEMyScene;
@class SPACEFaction;

@interface SPACEHUD : SKNode

@property SKShapeNode *compass;
@property SKLabelNode *thrusterCapacity;
@property SPACEFaction *faction;
@property SKColor *colour;

@property (nonatomic, readonly) SPACEMyScene *myScene;


+(instancetype) compassHUDWithColour:(SKColor*)colour atPosition: (CGPoint) position;
+(instancetype) engineHUDWithColour:(SKColor*)colour atPosition: (CGPoint)position;
+(instancetype) factionHUDWithColour:(SKColor*)colour forFaction:(SPACEFaction*)faction atPosition: (CGPoint)position;
-(void) updateDotsOnCompass;
-(void) updateEngineHUD;
-(void) updateFactionHUD;

@end

//
//  SPACEMyScene.h
//  Space
//

//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEShip;
@class SPACESystem;
@class SPACEHUD;

@interface SPACEMyScene : SKScene

@property NSTimeInterval previousTime;

@property int playerEnginePower;
@property NSArray* ships;
@property NSArray* shipStats;
@property NSArray* factions;
@property SKNode *universe;
@property SKNode *laserManager;
@property SPACEShip *playerShip;
@property SPACESystem* system;
@property SPACEHUD *compassHUD;
@property SPACEHUD *engineHUD;

@end
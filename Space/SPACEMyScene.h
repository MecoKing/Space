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

@property SPACEShip *playerShip;
@property int playerEnginePower;
@property NSArray* AIShips;
@property SPACESystem* system;
@property SKNode *universe;
@property SKNode *laserManager;
@property SPACEHUD *compassHUD;
@property SPACEHUD *engineHUD;
@property NSArray* factions;

@end

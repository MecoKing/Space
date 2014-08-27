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

@interface SPACEMyScene : SKScene <SKPhysicsContactDelegate>

@property NSTimeInterval previousTime;

@property int playerEnginePower;
@property NSMutableArray* ships;
@property NSMutableArray* shipStats;
@property NSArray* factions;
@property SKNode *universe;
@property SKNode *laserManager;
@property SPACEShip *playerShip;
@property SPACESystem* system;
@property SPACEHUD *compassHUD;
@property SPACEHUD *engineHUD;

@end

static const uint32_t projectileCategory = 0x1 << 0;
static const uint32_t shipCategory = 0x1 << 1;
static const uint32_t stellarBodyCategory = 0x1 << 2;
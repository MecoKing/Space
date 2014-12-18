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

@property int difficulty;

@property int playerEnginePower;
@property NSMutableArray* ships;
@property NSMutableArray* shipStats;
@property NSMutableArray* factions;
@property SKNode *universe;
@property SKNode *laserManager;
@property SKNode *nebula;
@property SPACEShip *playerShip;
@property SPACESystem* system;
@property SPACEHUD *compassHUD;
@property SPACEHUD *engineHUD;


@property bool playerIsDead;
@end

static const uint32_t projectileCategory = 0x1 << 0;
static const uint32_t shipCategory = 0x1 << 1;
static const uint32_t stellarBodyCategory = 0x1 << 2;
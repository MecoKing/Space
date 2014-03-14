//
//  SPACEMyScene.h
//  Space
//

//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEShip;
@class SPACESystem;

@interface SPACEMyScene : SKScene

@property NSTimeInterval previousTime;

@property SPACEShip *playerShip;
@property NSArray* AIShips;
@property SPACESystem* system;
@property SKNode *universe;
@property SKNode *laserManager;

@end

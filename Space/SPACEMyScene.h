//
//  SPACEMyScene.h
//  Space
//

//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SPACEShip;

@interface SPACEMyScene : SKScene

@property NSTimeInterval previousTime;

@property SPACEShip *playerShip;

@property SKNode *universe;
@property SKNode *laserManager;

@end

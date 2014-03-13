//
//  SPACEShip.h
//  Space
//
//  Created by [pixelmonster] on 2/3/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SPACEShip : NSObject

@property (readonly) SKNode *node;//why is this readonly!!!
@property CGFloat linearMagnitude;
@property CGFloat angularMagnitude;

-(void) activateDirectionalThrustersRight;
-(void) activateDirectionalThrustersLeft;
-(void) activateThrusters;
-(void) runAutoPilot;
-(void) fireLaser;

@end

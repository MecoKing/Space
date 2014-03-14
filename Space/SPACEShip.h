//
//  SPACEShip.h
//  Space
//
//  Created by [pixelmonster] on 2/3/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SPACEShip : SKSpriteNode


@property CGFloat linearMagnitude;
@property CGFloat angularMagnitude;
@property SKSpriteNode *sprite;
@property NSUInteger allegiance;//Number 1-5 | 1 = Loyal to the Player, 3 = Neutral, 5 = Loyal to not the Player

@property CGPoint relativePoint;
@property CGFloat angleToFace;
@property CGFloat currentAngle;

-(void) releaseDirectionalThrusters;
-(void) activateDirectionalThrustersRight;
-(void) activateDirectionalThrustersLeft;
-(void) activateThrusters;
-(void) runAutoPilot;
-(void) fireLaser;
-(void) fireMissileAtPoint: (CGPoint) destination;
+(instancetype) shipWithImageNamed: (NSString*) imageName;

@end

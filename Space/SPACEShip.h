//
//  SPACEShip.h
//  Space
//
//  Created by [pixelmonster] on 2/3/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "SPACEDefines.h"

@class SPACEMyScene;

@interface SPACEShip : SKSpriteNode

@property CGFloat linearMagnitude;
@property CGFloat angularMagnitude;
@property SKSpriteNode *sprite;
@property NSUInteger allegiance;//Number 1-5 | 1 = Loyal to the Player, 3 = Neutral, 5 = Loyal to not the Player
@property SPACEFaction faction;
@property NSArray *hullImages;
@property NSArray *wingImages;
@property NSArray *thrustImages;


@property CGPoint relativePoint;
@property CGFloat angleToFace;
@property CGFloat currentAngle;

@property (SK_NONATOMIC_IOSONLY, readonly) SPACEMyScene *scene;

-(void) releaseDirectionalThrusters;
-(void) activateDirectionalThrustersRight;
-(void) activateDirectionalThrustersLeft;
-(void) activateThrusters;
-(void) runAutoPilot;
-(void) fireLaser;
-(void) fireMissileAtPoint: (CGPoint) destination;
+(instancetype) shipWithImageNamed: (NSString*) imageName;
+(instancetype) randomShip;

@end

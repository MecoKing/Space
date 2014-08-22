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
@class SPACEFaction;
@class SPACEStat;

@interface SPACEShip : SKSpriteNode

@property CGFloat linearMagnitude;
@property CGFloat angularMagnitude;
@property SKSpriteNode *wings;
@property SKSpriteNode *hull;
@property SKSpriteNode *thruster;
@property SPACEFaction *faction;
@property NSInteger health;
@property SPACEStat *statDisplay;


//WIP AI rework
@property NSUInteger rank;
@property NSString *targetPriority;
@property NSString *superiorPriority;
@property NSUInteger value;



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
-(void) updateShipStats;
+(instancetype) randomFighterOfFaction: (SPACEFaction*)faction;

@end

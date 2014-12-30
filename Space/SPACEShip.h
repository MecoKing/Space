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

@property (nonatomic, readonly) SPACEMyScene *myScene;
//Physics
@property CGFloat linearMagnitude;
@property CGFloat angularMagnitude;
@property CGFloat angleToFace;
@property CGFloat currentAngle;
@property CGPoint relativePoint;
//Visual
@property SKShapeNode *wings;
@property SKShapeNode *hull;
@property SKShapeNode *thruster;
//Statistics
@property NSInteger health;
@property NSUInteger rank;
@property NSUInteger value;
@property SPACEStat *statDisplay;
@property SPACEFaction *faction;
//AI
@property NSString *priority;
@property CGPoint destination;


+(instancetype) randomFighterOfFaction: (SPACEFaction*)faction;
-(void) releaseDirectionalThrusters;
-(void) activateDirectionalThrustersRight;
-(void) activateDirectionalThrustersLeft;
-(void) activateThrusters;
-(void) runAutoPilot;
-(void) fireLaser;
-(void) fireMissileAtPoint: (CGPoint) destination;

@end

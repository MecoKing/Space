//
//  SPACEShipPart.h
//  Space
//
//  Created by [pixelmonster] on 2014-12-18.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SPACEShipPart : SKNode

@property NSUInteger value;
@property NSUInteger storage;

@property CGMutablePathRef shape;

+(instancetype) randomWingPart;
+(instancetype) randomHullPart;
+(instancetype) randomThrusterPart;
-(CGMutablePathRef) generatedWings;
-(CGMutablePathRef) generatedHull;
-(CGMutablePathRef) generatedThruster;

@end

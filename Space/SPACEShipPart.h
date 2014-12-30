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

@property (strong) CGPathRef shape __attribute__((NSObject));

+(instancetype) randomWingPart;
+(instancetype) randomHullPart;
+(instancetype) randomThrusterPart;
-(CGPathRef) newGeneratedWings;
-(CGPathRef) newGeneratedHull;
-(CGPathRef) newGeneratedThruster;

@end

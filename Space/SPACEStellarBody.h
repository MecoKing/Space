//
//  SPACEStellarBody.h
//  Space
//
//  Created by [pixelmonster] on 2/5/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class SPACEStar;

@interface SPACEStellarBody : SKShapeNode

+(instancetype)moonWithSize:(CGSize)size;
+(instancetype)terraPlanetWithSize:(CGSize)size;
+(instancetype)gasPlanetWithSize:(CGSize)size;

@property CGFloat radius;
@property CGFloat mass;
//@property CGPoint position;
@property SKColor *colour;
@property SKColor *glowColour;
@property CGFloat glowRatio;

@property (readonly) SKShapeNode *shape;

@end

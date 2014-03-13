//
//  SPACEStellarBody.h
//  Space
//
//  Created by [pixelmonster] on 2/5/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SPACEBarycentre.h"

@interface SPACEStellarBody : SKShapeNode <SPACEBarycentre>

+(instancetype)bodyWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(SKColor *)colour haloWidthRatio:(CGFloat)haloWidthRatio;
-(instancetype)initWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(SKColor *)colour haloWidthRatio:(CGFloat)haloWidthRatio;

@property (readonly) CGFloat radius; // should eventually be measured in km
@property (readonly) CGFloat mass; // should eventually be measured in kg or similar
@property (readonly) SKColor *colour;

@property (readonly) CGFloat haloWidthRatio;
@property (readonly) SKColor *haloColour; // subclass responsibility


// these methods are not available for creating new instances, use the constructor(s) above
-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;
+(instancetype)node UNAVAILABLE_ATTRIBUTE;

@end

//  Copyright (c) 2014 [pixelmonster]. All rights reserved.

#import <SpriteKit/SpriteKit.h>

@interface SPACEStar : SKNode

+(instancetype)starWithRadius:(CGFloat)radius mass:(CGFloat)mass colour:(SKColor *)colour;

+(instancetype)randomSuperGiant;
+(instancetype)randomRedGiant;
+(instancetype)randomWhiteDwarf;

@property (readonly) CGFloat radius; // measured in km
@property (readonly) CGFloat mass; // measured in kg
@property (readonly) SKColor *colour;


// these methods are not available for creating new stars, use the constructor(s) above
-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;
+(instancetype)node UNAVAILABLE_ATTRIBUTE;

@end

//
//  SPACEHUD.m
//  Space
//
//  Created by [pixelmonster] on 2014-03-15.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEHUD.h"
#import "SPACEMyScene.h"
#import "SPACEFunction.h"
#import "SPACEShip.h"

@implementation SPACEHUD

@dynamic scene;

+(instancetype) compassHUDAtPosition: (CGPoint) position {
    SPACEHUD *HUD = [SPACEHUD new];
    
    HUD.compass = [SKShapeNode new];
    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(position.x, position.y, 300, 300), NULL);
    HUD.compass.path = path;
    CGPathRelease(path);
    
    HUD.compass.strokeColor = SPACEInverseOfColour(HUD.scene.backgroundColor);
    HUD.compass.strokeColor = [SKColor colorWithRed:HUD.compass.strokeColor.redComponent green:HUD.compass.strokeColor.greenComponent blue:HUD.compass.strokeColor.blueComponent alpha:0.4];
    
    [HUD addChild:HUD.compass];
    
    return HUD;
}

-(void) drawDots {
    CGPathRef starDotPath = CGPathCreateWithEllipseInRect(CGRectMake(self.compass.position.x, self.compass.position.y, 20, 20), NULL);
    CGPathRef shipDotPath = CGPathCreateWithEllipseInRect(CGRectMake(self.compass.position.x, self.compass.position.y, 4, 4), NULL);
    
    SKShapeNode *starDot = [SKShapeNode new];
    starDot.path = starDotPath;
    starDot.strokeColor = self.compass.strokeColor;
    [self.compass addChild:starDot];
    
    for (SPACEShip *ship in self.scene.AIShips) {
        SKShapeNode *shipDot = [SKShapeNode new];
        shipDot.path = shipDotPath;
        
        if (ship.allegiance == 1)
            shipDot.fillColor = [SKColor greenColor];
        else if (ship.allegiance == 2)
            shipDot.fillColor = [SKColor yellowColor];
        else if (ship.allegiance == 3)
            shipDot.fillColor = [SKColor grayColor];
        else if (ship.allegiance == 4)
            shipDot.fillColor = [SKColor orangeColor];
        else
            shipDot.fillColor = [SKColor redColor];
        
        [self.compass addChild:shipDot];
    }
}

-(void) updateDotsOnCompass {
    [self.compass removeAllChildren];
    [self drawDots];
}

@end

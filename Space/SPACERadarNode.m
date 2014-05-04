//
//  SPACERadarNode.m
//  Space
//
//  Created by [pixelmonster] on 2014-03-20.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACERadarNode.h"
#import "SPACEFunction.h"
#import "SPACEMyScene.h"
#import "SPACEShip.h"

@implementation SPACERadarNode

+(instancetype) radarNodeTrackingNode: (SKNode*)node withColour: (SKColor*)colour {
	SPACERadarNode *radar = [SPACERadarNode new];
	radar.position = SPACEPointWithPolarPoint(SPACEPolarPointWithPoint(SPACEMultiplyPointByScalar(SPACENormalizePoint(SPACESubtractPoint(node.position, radar.scene.playerShip.position)), 150)));
	return radar;
}

@end

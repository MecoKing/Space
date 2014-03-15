//
//  SPACEAppDelegate.m
//  Space
//
//  Created by [pixelmonster] on 1/29/2014.
//  Copyright (c) 2014 [pixelmonster]. All rights reserved.
//

#import "SPACEAppDelegate.h"
#import "SPACEMyScene.h"

@interface SPACEAppDelegate ()

@property IBOutlet NSWindowController *windowController;

@end

@implementation SPACEAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    CGSize size = [self.window contentRectForFrameRect:self.window.frame].size;
    SKScene *scene = [SPACEMyScene sceneWithSize:size];
	
    scene.scaleMode = SKSceneScaleModeResizeFill;
	
    [self.skView presentScene:scene];
	
	[self.windowController showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end

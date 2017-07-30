//
//  AppDelegate.m
//  CircleTimer
//
//  Created by David Burns on 21/9/16.
//  Copyright © 2016 David Burns. All rights reserved.
//

#import "AppDelegate.h"

int iconNumber = 1;
int timerNumber = 0;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Brings up the status bar icon
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self setTimerNumber];
    
    _statusItem.highlightMode = NO;
    _statusItem.toolTip = @"Option+Click to reset\nControl+Click to exit"; // Add in text for resetting
    
    [_statusItem setAction:@selector(itemClicked:)];
}

- (void)itemClicked:(id)sender {

    // Check whether there was a modifier being held down when the icon was clicked
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSEventModifierFlagControl) {
        // Ctrl click exits the app
        [[NSApplication sharedApplication] terminate:self];
        return;
    } else if ([event modifierFlags] & NSEventModifierFlagOption) {
        // Command click resets the app
        [self stopTimer];
        iconNumber = 1;
        timerNumber = 0;
        [self setStatusIcon:@"05"];
        [self performSelector:@selector(setStatusIcon:) withObject:@"01_0" afterDelay:0.16 ];
    } else if (!_timer.isValid) {
    

        // Set different timers depending on whether the circle is empty or full
        if (iconNumber == 1) {
            
            // Quickly change the icon to grey to show that it was clicked
            [self setStatusIcon:@"05"];
            [self performSelector:@selector(setStatusIcon:) withObject:@"01" afterDelay:0.16 ];
            
            // Start the timer
            _timer = [NSTimer scheduledTimerWithTimeInterval:375
                                                      target:self
                                                    selector:@selector(changeIcon/*:*/)
                                                    userInfo:nil
                                                     repeats:YES];
            //Play a sound
            [[NSSound soundNamed:@"Pop"] play];
            
        } else if (iconNumber == 5) {
            
            // Quickly change the icon to grey to show that it was clicked
            [self setStatusIcon:@"01"];
            [self performSelector:@selector(setStatusIcon:) withObject:@"05" afterDelay:0.16 ];
            
            // Start the timer
            _timer = [NSTimer scheduledTimerWithTimeInterval:75
                                                      target:self
                                                    selector:@selector(changeIcon/*:*/)
                                                    userInfo:nil
                                                     repeats:YES];
            //Play a sound
            [[NSSound soundNamed:@"Pop"] play];
        }
    }
}

-(void)setStatusIcon:(NSString *)imgID {
    // Concatenates the name of the image file
    NSString *imgName;
    imgName = [NSString stringWithFormat:@"Circle%@", imgID];

    // Changes the icon as well as enabling night mode
    _statusItem.image = [NSImage imageNamed:imgName];
    [_statusItem.image setTemplate:YES];
    
}

-(void)changeIcon/*:(NSTimer *)timer*/ {
    // Changes the icon of the app in the menu bar based on where the timer is up to
    
    // Checks where the timer is up to
    switch (iconNumber) {
        case 1:
            iconNumber++;
            [self setStatusIcon:@"02"];
            break;
        case 2:
            iconNumber++;
            [self setStatusIcon:@"03"];
            break;
        case 3:
            iconNumber++;
            [self setStatusIcon:@"04"];
            break;
        case 4:
            iconNumber++;
            [self setStatusIcon:@"05"];
            // The first timer is complete, turning it off
            [self stopTimer];
            break;
        case 5:
            iconNumber++;
            [self setStatusIcon:@"06"];
            break;
        case 6:
            iconNumber++;
            [self setStatusIcon:@"07"];
            break;
        case 7:
            iconNumber++;
            [self setStatusIcon:@"08"];
            break;
        case 8:
            iconNumber = 1;
            [self setStatusIcon:@"01"];
            // Increment the number of timers that have occurred
            if (timerNumber == 9){
                timerNumber = 0;
            } else {
                timerNumber++;
            }
            // The second timer is complete, turning it off
            [self stopTimer];
            break;
        default:
            break;
    }
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
    [self playCompleteSound];
    
    [self performSelector:@selector(playCompleteSound) withObject:nil afterDelay:1.6 ];
    [self performSelector:@selector(playCompleteSound) withObject:nil afterDelay:3.2 ];
    
    // Change the icon to show the number of timers completed
    [self performSelector:@selector(setTimerNumber) withObject:nil afterDelay:1.6 ];


}
- (void)playCompleteSound {
    [[NSSound soundNamed:@"Blow"] play];
}
- (void)setTimerNumber {
    if (iconNumber == 1) {
        // Concatenates the string pointing to the correct image
        NSString *combinedImageNumber;
        NSString *timerNumberAsString;
        timerNumberAsString = [[NSNumber numberWithInt:timerNumber] stringValue];

        combinedImageNumber = [NSString stringWithFormat:@"01_%@", timerNumberAsString];
        
        [self setStatusIcon:combinedImageNumber];
    } else if (iconNumber == 5) {
        // put code in here for the filled icon with numbers
    }
    
}

-(CGImageRef)numberCircle {
    NSImage *background = [NSImage imageNamed:@"background"];
    NSImage *overlay = [NSImage imageNamed:@"overlay"];
    
    NSImage *newImage = [[NSImage alloc] initWithSize:[background size]];
    [newImage lockFocus];
    
    CGRect newImageRect = CGRectZero;
    newImageRect.size = [newImage size];
    
    [background drawInRect:newImageRect];
    [overlay drawInRect:newImageRect];
    
    [newImage unlockFocus];
    
    CGImageRef newImageRef = [newImage CGImageForProposedRect:NULL context:nil hints:nil];
    return newImageRef;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end

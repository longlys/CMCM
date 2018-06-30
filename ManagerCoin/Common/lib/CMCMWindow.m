//
//  CMCMWindow.m
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMWindow.h"

@implementation CMCMWindow

- (void)sendEvent:(UIEvent *)event
{
    UIResponder *responder = [self performSelector:@selector(firstResponder)];
    
    [super sendEvent:event];
    
    if (event.type == UIEventTypeTouches) {
        NSSet *allTouches = [event allTouches];
        self.touchesCount = (int)allTouches.count;
        UITouchPhase phase = [((UITouch *)[allTouches anyObject]) phase];
        switch (phase) {
            case UITouchPhaseEnded:
            {
                
                
                if ([responder isKindOfClass:[UIView class]]) {
                    BOOL needFirseResponder = YES;
                    
                    NSSet *touchs = [event allTouches];
                    if (touchs) {
                        UIView *view = (UIView *)responder;
                        for (UITouch *touch in touchs) {
                            CGPoint point = [touch locationInView:view];
                            if ([view pointInside:point withEvent:event]) {
                                needFirseResponder = NO;
                                break;
                            }
                        }
                        //                        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
                    }
                    if (needFirseResponder) {
                        // calling via dispatch will cause bug: tap twice to close custom popup
                        //                        dispatch_async(dispatch_get_main_queue(), ^{
                        [responder resignFirstResponder];
                        //                        });
                    }
                }
            }
                break;
                
                //            case UITouchPhaseEnded:
            case UITouchPhaseCancelled:
                // Start counter.
            {
            }
                break;
                
            default:
                break;
        }
    }
}

@end

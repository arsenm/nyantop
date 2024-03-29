/* Copyright (c) 2011, Nate Stedman <natesm@gmail.com>
 * 
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#import "NyanWindow.h"

@implementation NyanWindow

-(id)init
{
    // get a random screen
    NSArray* screens = [NSScreen screens];
    NSUInteger index = rand() % [screens count];
    NSScreen* screen = [screens objectAtIndex:index];
    
    // get a random position on the screen
    NSRect frame = [screen frame];
    
    frame.origin.x = 0.0;
    frame.origin.y = ((CGFloat)rand() / (CGFloat)RAND_MAX) * (frame.size.height - NyanWindowHeight);
    frame.size.height = NyanWindowHeight;
    
    // create the window
    self = [super initWithContentRect:frame
                            styleMask:NSBorderlessWindowMask
                              backing:NSBackingStoreBuffered
                                defer:YES
                               screen:screen];
    
    if (self)
    {
        [self setContentView:[[NyanView alloc] initWithFrame:[[self contentView] frame]]];
        [self setLevel:CGShieldingWindowLevel()];
    }
    
    return self;
}

-(void)dealloc
{
    [[self contentView] release];
}

-(BOOL)ignoresMouseEvents
{
    return YES;
}

-(NSColor*)backgroundColor
{
    return [NSColor clearColor];
}

-(BOOL)isOpaque
{
    return NO;
}

@end

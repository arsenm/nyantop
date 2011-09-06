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

#import "NyantopAppDelegate.h"

#import "NyanWindow.h"

@implementation NyantopAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    /*nextNyanTimer = [NSTimer scheduledTimerWithTimeInterval:NyanMinTime + (rand() % NyanTimeInterval)
                                                     target:self
                                                   selector:@selector(itsNyanTime:)
                                                   userInfo:nil
                                                    repeats:NO];*/
    [self itsNyanTime:nil];
}

-(void)itsNyanTime:(NSTimer*)timer
{
    [timer release];
    
    NSWindow* window = [[NyanWindow alloc] init];
    [window orderFront:self];
    
    nextNyanTimer = [NSTimer scheduledTimerWithTimeInterval:NyanMinTime + (rand() % NyanTimeInterval)
                                                     target:self
                                                   selector:@selector(itsNyanTime:)
                                                   userInfo:nil
                                                    repeats:NO];
}

@end

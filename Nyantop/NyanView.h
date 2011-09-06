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

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#define NyanCatWidth 188.0
#define NyanCatHeight 114.0
#define NyanCatFrames 12
#define NyanCatMinFrame 1
#define NyanPixelsPerSecond 400.0
#define NyanCatFrameRate 0.1

#define NyanCatFlipRate (NyanCatFrameRate * 2.0)

#define NyanRainbowImageWidth 92.0
#define NyanRainbowImageRepeat 8.0
#define NyanRainbowWidth (NyanRainbowImageWidth * NyanRainbowImageRepeat)
#define NyanRainbowHeight 108.0

#define NyanRainbowOffset 114.0

#define NyanTotalWidth (NyanRainbowWidth + NyanCatWidth)

#define NyanCatShadowRadius 20.0
#define NyanCatShadowOpacity 0.5

@interface NyanView : NSView
{
    CALayer* cat;
    CALayer* rainbow;
    NSTimer* animationTimer;
    NSTimer* flipTimer;
    int currentFrame;
    CGImageRef* images;
}

-(void)frameAdvance:(id)sender;
-(void)rainbowFlip:(id)sender;

@end

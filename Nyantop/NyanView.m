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

#import "NyanView.h"

static void NyanDrawRainbow(void* image, CGContextRef ctx)
{
    CGContextDrawImage(ctx, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
}

static void NyanReleaseRainbow(void* image)
{
    CGImageRelease(image);
}

@implementation NyanView

-(void)viewDidMoveToWindow
{
    [self setWantsLayer:YES];
    
    // load the nyan cat images
    images = malloc(sizeof(CGImageRef) * NyanCatFrames);
    for (int i = 0; i < NyanCatFrames; i++)
    {
        NSString* imageName = [NSString stringWithFormat:@"nyan-%d", i + NyanCatMinFrame];
        NSString* path = [[NSBundle mainBundle] pathForImageResource:imageName];
        CGDataProviderRef source = (void*)NSMakeCollectable(CGDataProviderCreateWithFilename([path UTF8String]));
        CGImageRef image = (void*)NSMakeCollectable((CGImageCreateWithPNGDataProvider(source, NULL, false, kCGRenderingIntentDefault)));
        CGDataProviderRelease(source);
        images[i] = image;
    }
    
    // load the rainbow image
    NSString* path = [[NSBundle mainBundle] pathForImageResource:@"rainbow"];
    CGDataProviderRef source = (void*)NSMakeCollectable(CGDataProviderCreateWithFilename([path UTF8String]));
    CGImageRef image = (void*)NSMakeCollectable(CGImageCreateWithPNGDataProvider(source, NULL, false, kCGRenderingIntentDefault));
    CGDataProviderRelease(source);
    
    // create a pattern color for the rainbow
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    static const CGPatternCallbacks callbacks = {0, &NyanDrawRainbow, &NyanReleaseRainbow};
    CGPatternRef pattern = (void*)NSMakeCollectable(CGPatternCreate(image,
                                                                    CGRectMake(0, 0, width, height),
                                                                    CGAffineTransformMake(1, 0, 0, 1, 0, 0),
                                                                    width,
                                                                    height,
                                                                    kCGPatternTilingConstantSpacing,
                                                                    true,
                                                                    &callbacks));
    CGColorSpaceRef space = (void*)NSMakeCollectable(CGColorSpaceCreatePattern(NULL));
    CGFloat components[1] = {1.0};
    CGColorRef color = (void*)NSMakeCollectable(CGColorCreateWithPattern(space, pattern, components));
    CGColorSpaceRelease(space);
    CGPatternRelease(pattern);
    
    // create the layers
    cat = [[CALayer alloc] init];
    rainbow = [[CALayer alloc] init];
    
    // set the current cat images
    currentFrame = rand() % NyanCatFrames;
    [self frameAdvance:self];
    
    // randomly calculate start and end positions
    CGFloat start, end;
    CGFloat rainbowOrigin;
    
    if (rand() % 2)
    {
        start = -NyanTotalWidth;
        end = [[self window] frame].size.width + NyanTotalWidth;
        rainbowOrigin = NyanCatWidth - NyanRainbowOffset - NyanRainbowWidth + NyanCatShadowRadius;
    }
    else
    {
        end = -NyanTotalWidth;
        start = [[self window] frame].size.width + NyanTotalWidth;
        rainbowOrigin = NyanRainbowOffset + NyanCatShadowRadius;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // flip the cat if headed left
    if (start > end)
    {
        [cat setValue:[NSNumber numberWithDouble:-1.0] forKeyPath:@"transform.scale.x"];
    }
    
    // set the frames of the layers
    [cat setFrame:CGRectMake(NyanCatShadowRadius, NyanCatShadowRadius, NyanCatWidth, NyanCatHeight)];
    [rainbow setFrame:CGRectMake(rainbowOrigin, NyanCatShadowRadius, NyanRainbowWidth, NyanRainbowHeight)];
    [rainbow setZPosition:-1.0];
    
    // initialize the transforms
    [cat setValue:[NSNumber numberWithDouble:end] forKeyPath:@"transform.translation.x"];
    [rainbow setValue:[NSNumber numberWithDouble:end] forKeyPath:@"transform.translation.x"];
    
    // set the rainbow image
    [rainbow setBackgroundColor:color];
    CGColorRelease(color);
    
    // set the shadow
    [[self layer] setShadowOpacity:NyanCatShadowOpacity];
    [[self layer] setShadowRadius:NyanCatShadowRadius / 2.0];
    
    // add the layers
    [[self layer] addSublayer:cat];
    [[self layer] addSublayer:rainbow];
    
    [CATransaction commit];
    
    // animate the cat
    CABasicAnimation* anim = [CABasicAnimation animation];
    [anim setFromValue:[NSNumber numberWithDouble:start]];
    [anim setToValue:[NSNumber numberWithDouble:end]];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [anim setDuration:fabs(start - end) / NyanPixelsPerSecond];
    [rainbow addAnimation:anim forKey:@"transform.translation.x"];
    [anim setDelegate:self];
    [cat addAnimation:anim forKey:@"transform.translation.x"];
    
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:NyanCatFrameRate
                                                      target:self
                                                    selector:@selector(frameAdvance:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    flipTimer = [NSTimer scheduledTimerWithTimeInterval:NyanCatFlipRate
                                                 target:self
                                               selector:@selector(rainbowFlip:)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)frameAdvance:(id)sender
{
    currentFrame--;
    if (currentFrame < 0) currentFrame += NyanCatFrames;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [cat setContents:(id)images[currentFrame]];
    [CATransaction commit];
}

-(void)rainbowFlip:(id)sender
{
    double new = [[rainbow valueForKeyPath:@"transform.scale.x"] doubleValue] * -1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [rainbow setValue:[NSNumber numberWithDouble:new] forKeyPath:@"transform.scale.x"];
    [CATransaction commit];
}

-(void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{
    [[self window] close];
}

-(void)finalize
{
    [flipTimer invalidate];
    [animationTimer invalidate];
    free(images);
    [super finalize];
}

@end

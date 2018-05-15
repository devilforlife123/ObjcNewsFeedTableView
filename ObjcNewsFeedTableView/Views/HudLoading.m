//
//  HudLoading.m
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import "Hudloading.h"
#import <QuartzCore/QuartzCore.h>


CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
    //
    // Create the boundary path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius);
    
    // Top left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius);
    
    // Top right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
    // Close the path at the rounded rect
    CGPathCloseSubpath(path);
    
    return path;
}

@implementation Hudloading

+(id)hudloadingInView:(UIView *)superView{
    
    Hudloading * hudloading = [[Hudloading alloc]initWithFrame:CGRectMake(0, 0, superView.bounds.size.width/2, superView.bounds.size.height/3)];
    hudloading.center = superView.center;
    if (!hudloading)
    {
        return nil;
    }
    
    hudloading.opaque = NO;
    hudloading.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [superView addSubview:hudloading];
    
    const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
    const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
    CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
    UILabel *loadingLabel =
    [[UILabel alloc]
     initWithFrame:labelFrame]
    ;
    loadingLabel.text = NSLocalizedString(@"Loading...", nil);
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    loadingLabel.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    
    [hudloading addSubview:loadingLabel];
    UIActivityIndicatorView *activityIndicatorView =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [hudloading addSubview:activityIndicatorView];
    activityIndicatorView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    [activityIndicatorView startAnimating];
    
    CGFloat totalHeight =
    loadingLabel.frame.size.height +
    activityIndicatorView.frame.size.height;
    labelFrame.origin.x = floor(0.5 * (hudloading.frame.size.width - DEFAULT_LABEL_WIDTH));
    labelFrame.origin.y = floor(0.5 * (hudloading.frame.size.height - totalHeight));
    loadingLabel.frame = labelFrame;
    
    CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.origin.x =
    0.5 * (hudloading.frame.size.width - activityIndicatorRect.size.width);
    activityIndicatorRect.origin.y =
    loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
    activityIndicatorView.frame = activityIndicatorRect;
    
    // Set up the fade-in animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[superView layer] addAnimation:animation forKey:@"layerAnimation"];
    
    return hudloading;
    
}

- (void)removeView
{
    UIView *superView = [self superview];
    [super removeFromSuperview];
    
    // Set up the animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    
    [[superView layer] addAnimation:animation forKey:@"layerAnimation"];
}


- (void)drawRect:(CGRect)rect
{
    rect.size.height -= 1;
    rect.size.width -= 1;
    
    const CGFloat RECT_PADDING = 8.0;
    rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
    
    const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
    CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat BACKGROUND_OPACITY = 0.85;
    CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextFillPath(context);
    
    const CGFloat STROKE_OPACITY = 0.25;
    CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextStrokePath(context);
    
    CGPathRelease(roundRectPath);
}
@end


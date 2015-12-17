//
//  TESignatureView.m
//  TESignatureTemplate
//
//  Created by Asif Ali on 12/2/15.
//  Copyright © 2015 Asif Ali. All rights reserved.
//

#import "TESignatureView.h"

#define DEFAULT_COLOR [UIColor redColor];
#define DEFAULT_WIDTH 2.0
#define DEFAULT_PLACEHOLDER @"Sign Here";
#define FONT_NAME @"Verdana"

@implementation TESignatureView

{
    UIBezierPath *beizerPath;
    UIImage *incrImage;
    CGPoint points[5];
    uint control;
}

// Create a View which contains Signature Label

-(void) awakeFromNib {
    [super awakeFromNib];
    
    float lblHeight = 60;

    [self setMultipleTouchEnabled:NO];
    beizerPath = [UIBezierPath bezierPath];
    [beizerPath setLineWidth:signatureWidth <= 0 ? 2.0 : signatureWidth];
    signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - lblHeight/2, self.frame.size.width, lblHeight)];
    signatureLabel.numberOfLines = 0;
    signatureLabel.font = [UIFont fontWithName:FONT_NAME size:60];
    signatureLabel.text = placeholderText != nil ? placeholderText : DEFAULT_PLACEHOLDER;
    signatureLabel.textColor = [UIColor lightGrayColor];
    signatureLabel.textAlignment = NSTextAlignmentCenter;
    signatureLabel.adjustsFontSizeToFitWidth = YES;
    signatureLabel.minimumScaleFactor = 0.1;
    signatureLabel.alpha = 0.3;
    [self addSubview:signatureLabel];
    [self performSelector:@selector(updateText) withObject:nil afterDelay:0.2];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float lblHeight = 60;

        [self setMultipleTouchEnabled:NO];
        beizerPath = [UIBezierPath bezierPath];
        [beizerPath setLineWidth:signatureWidth <= 0 ? 2.0 : signatureWidth];
        signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - lblHeight/2, self.frame.size.width, lblHeight)];
        signatureLabel.font = [UIFont fontWithName:FONT_NAME size:60];
        signatureLabel.text = placeholderText != nil ? placeholderText : DEFAULT_PLACEHOLDER;
        signatureLabel.textColor = [UIColor lightGrayColor];
        signatureLabel.textAlignment = NSTextAlignmentCenter;
        signatureLabel.adjustsFontSizeToFitWidth = YES;
        signatureLabel.minimumScaleFactor = 0.1;
        signatureLabel.alpha = 0.3;
        [self addSubview:signatureLabel];
        [self performSelector:@selector(updateText) withObject:nil afterDelay:0.2];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [incrImage drawInRect:rect];
    [beizerPath stroke];
    
    // Set initial color for drawing
    
    UIColor *fillColor = signatureColor != nil ? signatureColor : DEFAULT_COLOR;
    [fillColor setFill];
    UIColor *strokeColor = signatureColor != nil ? signatureColor : DEFAULT_COLOR;
    [strokeColor setStroke];
    [beizerPath stroke];
}

#pragma mark - UIView Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([signatureLabel superview]){
        [signatureLabel removeFromSuperview];
    }
    control = 0;
    UITouch *touch = [touches anyObject];
    points[0] = [touch locationInView:self];
    
    CGPoint startPoint = points[0];
    CGPoint endPoint = CGPointMake(startPoint.x + 1.5, startPoint.y
                                   + 2);
    
    [beizerPath moveToPoint:startPoint];
    [beizerPath addLineToPoint:endPoint];
    
    NSLog(@"began");
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    control++;
    points[control] = touchPoint;
    
    if (control == 4)
    {
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0);
        
        [beizerPath moveToPoint:points[0]];
        [beizerPath addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        
        [self setNeedsDisplay];
        
        points[0] = points[3];
        points[1] = points[4];
        control = 1;
        NSLog(@"moved");
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmapImage];
    [self setNeedsDisplay];
    [beizerPath removeAllPoints];
    control = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Bitmap Image Creation

- (void)drawBitmapImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!incrImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [self.backgroundColor setFill];
        [rectpath fill];
    }
    [incrImage drawAtPoint:CGPointZero];
    
    //Set final color for drawing
    UIColor *strokeColor = signatureColor != nil ? signatureColor : DEFAULT_COLOR;
    [strokeColor setStroke];
    [beizerPath stroke];
    incrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

- (void)clearSignature
{
    incrImage = nil;
    [self setNeedsDisplay];
}

#pragma mark - Get Signature image from given path

- (UIImage *)getSignatureImage {
    
    if([signatureLabel superview]){
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return signatureImage;
}

-(void) updateText {
    
    signatureLabel.userInteractionEnabled = NO;
    signatureLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    signatureLabel.text = placeholderText != nil ? placeholderText : DEFAULT_PLACEHOLDER;
}

@end

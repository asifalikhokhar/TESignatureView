//
//  TESignatureView.h
//  TESignatureTemplate
//
//  Created by Asif Ali on 12/2/15.
//  Copyright © 2015 Asif Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TESignatureView : UIView

{
    UILabel *signatureLabel;
    CAShapeLayer *shapeLayer;
    
    IBInspectable NSString *placeholderText;
    IBInspectable UIColor *signatureColor;
    IBInspectable NSUInteger signatureWidth;
}

- (UIImage *)getSignatureImage;
- (void)clearSignature;
@end

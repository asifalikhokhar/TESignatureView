//
//  ViewController.m
//  TESignatureTemplate
//
//  Created by Asif Ali on 12/17/15.
//  Copyright © 2015 v7iTech. All rights reserved.
//

#import "ViewController.h"
#import "TESignatureView.h"

@interface ViewController ()
{
    __weak IBOutlet TESignatureView *signtureView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)resetButtonPressed:(id)sender {
    
    [signtureView clearSignature];
}

-(IBAction)saveButtonPressed:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum([signtureView getSignatureImage], nil, nil, nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

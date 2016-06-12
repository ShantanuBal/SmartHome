//
//  ViewController.h
//  SmartHome
//
//  Created by Bal, Shantanu on 6/11/16.
//  Copyright © 2016 Bal, Shantanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)switchChanged:(UISwitch *)sender;
- (IBAction)sliderChanged:(UISlider *)sender;

@end


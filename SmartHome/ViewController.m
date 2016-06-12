//
//  ViewController.m
//  SmartHome
//
//  Created by Bal, Shantanu on 6/11/16.
//  Copyright © 2016 Bal, Shantanu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)checkLights {
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.100/api/H60hg5i4iRkijuRRKnsORWL8aBssw5DxJKR-V5E5/groups/4"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *resData = [response dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:resData options:0 error:nil];
    
    BOOL isON = [[[json objectForKey:@"state"] objectForKey:@"all_on"] boolValue];
    float brightness = [[[json objectForKey:@"action"] objectForKey:@"bri"] floatValue];
    
    if (isON == YES && brightness > 0) {
        [self.toggleSwitch setOn:YES];
        [self.value setText:@"Lights are ON"];
    } else {
        [self.toggleSwitch setOn:NO];
        [self.value setText:@"Lights are OFF"];
    }
    
    if (isON) {
        [self.slider setValue:brightness];
    } else {
        [self.slider setValue:0];
    }
    
    [self.spinner stopAnimating];
    NSLog(@"ret=%@", response);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slider.continuous = NO;
    [self checkLights];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)putRequest:(NSString *)data url:(NSString *)url {
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"PUT";
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSData *requestBodyData = [data dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)switchChanged:(UISwitch *)sender {
    [self.spinner startAnimating];
    
    NSString *stringData;
    if (sender.isOn) {
        NSLog(@"TURNING ON");
        stringData = @"{\"on\":true}";
    } else {
        NSLog(@"TURNING OFF");
        stringData = @"{\"on\":false}";
    }
    
    [self putRequest:stringData url:@"http://192.168.0.100/api/H60hg5i4iRkijuRRKnsORWL8aBssw5DxJKR-V5E5/groups/4/action"];
    
    
    SEL aSelector = @selector(checkLights);
    [self performSelector:aSelector withObject:nil afterDelay:2];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    [self.spinner startAnimating];
    
    uint8_t sliderValue = (uint8_t)sender.value;
    NSLog(@"Setting value to %d", sliderValue);
    
    NSString *sliderValString = [NSString stringWithFormat:@"%d", sliderValue];
    NSString *stringData = @"{\"bri\":";
    stringData = [stringData stringByAppendingString:sliderValString];
    stringData = [stringData stringByAppendingString:@"}"];
    NSLog(@"Data: %@", stringData);

    [self putRequest:stringData url:@"http://192.168.0.100/api/H60hg5i4iRkijuRRKnsORWL8aBssw5DxJKR-V5E5/groups/4/action"];
    
    SEL aSelector = @selector(checkLights);
    [self performSelector:aSelector withObject:nil afterDelay:2];
}
@end

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
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *retdata = [ret dataUsingEncoding:NSUTF8StringEncoding];
    
    id json = [NSJSONSerialization JSONObjectWithData:retdata options:0 error:nil];
    
    BOOL isON = [[[json objectForKey:@"state"] objectForKey:@"all_on"] boolValue];
    
    if (isON == YES) {
        [self.toggleSwitch setOn:YES];
        [self.value setText:@"Lights are ON"];
    } else {
        [self.toggleSwitch setOn:NO];
        [self.value setText:@"Lights are OFF"];
    }
    
    [self.spinner stopAnimating];
    NSLog(@"ret=%@", ret);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkLights];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchChanged:(UISwitch *)sender {
    [self.spinner startAnimating];
    
    NSString *stringData;
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.100/api/H60hg5i4iRkijuRRKnsORWL8aBssw5DxJKR-V5E5/groups/4/action"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"PUT";
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    if (sender.isOn) {
        NSLog(@"TURNING ON");
        stringData = @"{\"on\":true}";
    } else {
        NSLog(@"TURNING OFF");
        stringData = @"{\"on\":false}";
    }
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    SEL aSelector = @selector(checkLights);
    [self performSelector:aSelector withObject:nil afterDelay:2];
}
@end

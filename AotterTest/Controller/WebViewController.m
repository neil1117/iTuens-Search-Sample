//
//  WebViewController.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/24.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *appleWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://support.apple.com/itunes"]];
    [_appleWebView loadRequest:request];
}

#pragma marl - Button Clicked Event
- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end

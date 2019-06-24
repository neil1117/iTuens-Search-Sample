//
//  BaseViewController.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/24.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setColor];
}

#pragma mark - Private

- (void)setColor {
    if ([[[ColorTheme sharedInstance] getColorTheme] isEqualToString:kThemeLightColor]) {
         self.view.backgroundColor = [UIColor whiteColor];
    } else if ([[[ColorTheme sharedInstance] getColorTheme] isEqualToString:kThemeDeepColor]) {
        self.view.backgroundColor = [UIColor blackColor];
    }
   
}

@end

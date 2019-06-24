//
//  ColorViewController.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/23.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()

@property (weak, nonatomic) IBOutlet UIView *lightArrow;
@property (weak, nonatomic) IBOutlet UIView *deepColorArrow;

@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSelectTheme:[ColorTheme.sharedInstance getColorTheme]];
}

- (void)setSelectTheme:(NSString *)selectTheme {
    
    BOOL isSuccess = [ColorTheme.sharedInstance setColorTheme:selectTheme];
    
    if (!isSuccess) {
        return;
    }
    
    [_lightArrow setHidden:![selectTheme isEqualToString:kThemeLightColor]];
    [_deepColorArrow setHidden:![selectTheme isEqualToString:kThemeDeepColor]];
    [self setColor];
}

#pragma mark - Button Click Event

- (IBAction)lightColorClicked:(id)sender {
    [self setSelectTheme:kThemeLightColor];
}

- (IBAction)deepColorClicked:(id)sender {
    [self setSelectTheme:kThemeDeepColor];
}

@end

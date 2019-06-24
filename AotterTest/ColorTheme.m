//
//  ColorTheme.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/24.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "ColorTheme.h"

static NSString * const ColorThemeConstant = @"ColorTheme";

@interface ColorTheme()
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSUserDefaults* userDefaults;
@end

@implementation ColorTheme

static ColorTheme *sharedInstance;

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *colorTheme =  [_userDefaults objectForKey:ColorThemeConstant];
        if (!colorTheme) {
            _theme = kThemeLightColor;
            [self setColorTheme:_theme];
        } else {
            _theme = colorTheme;
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - Public

- (BOOL)setColorTheme:(NSString *)theme {
     [_userDefaults setObject:theme forKey:ColorThemeConstant];
    BOOL isSuccess = [_userDefaults synchronize];
    if (isSuccess) {
        _theme = theme;
    }
    return isSuccess;
}

- (NSString *)getColorTheme {
    return _theme;
}

@end

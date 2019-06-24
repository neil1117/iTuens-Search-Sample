//
//  ColorTheme.h
//  AotterTest
//
//  Created by Neil Wu on 2019/6/24.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorTheme : NSObject

+ (instancetype) sharedInstance;

- (BOOL)setColorTheme:(NSString *)theme;
- (NSString *)getColorTheme;
@end

NS_ASSUME_NONNULL_END

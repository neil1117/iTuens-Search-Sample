//
//  ResultViewController.h
//  AotterTest
//
//  Created by Neil Wu on 2019/6/23.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : BaseViewController

@property (nonatomic) KindForiTunes section;
- (void)setShowSection:(KindForiTunes)section;
@end

NS_ASSUME_NONNULL_END

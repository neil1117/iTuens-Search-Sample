//
//  PersonalInfoViewController.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/20.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "ColorViewController.h"
#import "StarViewController.h"
#import "WebViewController.h"

@interface PersonalInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    _userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupColorLabel];
    [self setupStarLabel];
}

#pragma mark - Private

- (void)setupNavigation {
    self.title = @"個人資料";
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = false;
}

- (void)setupColorLabel {
    NSString *colorStr = @"";
    NSString *theme = [ColorTheme.sharedInstance getColorTheme];
    if ([theme isEqualToString:kThemeLightColor]) {
        colorStr = @"淺色";
    } else if ([theme isEqualToString:kThemeDeepColor]) {
        colorStr = @"深色";
    }
    _colorLabel.text = colorStr;
}

- (void)setupStarLabel {
    NSArray *musics = [_userDefaults objectForKey:[NSString stringWithFormat:@"%ld", musicType]];
    NSArray *movies = [_userDefaults objectForKey:[NSString stringWithFormat:@"%ld", movieType]];
    NSInteger totalStar = musics.count + movies.count;
    _starCountLabel.text = [NSString stringWithFormat:@"共有 %ld 項收藏", totalStar];
}

#pragma mark - Button Clicked Event

- (IBAction)clolrButtonClicked:(id)sender {
    ColorViewController *colorVC = [[ColorViewController alloc] initWithNibName:@"ColorViewController" bundle:nil];
    [self.navigationController pushViewController:colorVC animated:true];
}
- (IBAction)starBtuuonClicked:(id)sender {
    StarViewController *starVC = [[StarViewController alloc] initWithNibName:@"StarViewController" bundle:nil];
    [self.navigationController pushViewController:starVC animated:true];
}

- (IBAction)aboutButtonClicked:(id)sender {
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [self presentViewController:webVC animated:true completion:nil];
}

@end

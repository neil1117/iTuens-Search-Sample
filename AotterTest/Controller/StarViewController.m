//
//  StarViewController.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/23.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "StarViewController.h"
#import "ResultViewController.h"

@interface StarViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sectionSegment;

@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSArray *dataSources;
@property (nonatomic) NSInteger controllerCurrentIndex;

@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _controllerCurrentIndex = movieType;
    [self setupSectionSegment];
    [self setupPageVCDataSource];
    [self setupPageVC];
}

#pragma mark - Private

- (void)setupSectionSegment {
    [_sectionSegment addTarget:self action:@selector(sectionSegmentClicked:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupPageVCDataSource {
    ResultViewController *movieResultVC = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    movieResultVC.section = movieType;
    ResultViewController *musivResultVC = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    musivResultVC.section = musicType;
    _dataSources = @[movieResultVC, musivResultVC];
}

- (void)setupPageVC {
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: nil];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [self addChildViewController:_pageVC];
    [_pageVC didMoveToParentViewController:self];
    _pageVC.view.translatesAutoresizingMaskIntoConstraints = false;
    [_contentView addSubview:_pageVC.view];
    NSDictionary *views = @{@"pageView": _pageVC.view};
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pageView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [_pageVC setViewControllers:@[_dataSources.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
}

#pragma mark - SegmentControl Clicked Event

- (void)sectionSegmentClicked:(id)sender {
    //根據 index 決定要移動的方向或是不動
    UIPageViewControllerNavigationDirection direction;
    if (_controllerCurrentIndex > _sectionSegment.selectedSegmentIndex) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    } else if (_controllerCurrentIndex < _sectionSegment.selectedSegmentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        return;
    }
    _controllerCurrentIndex = _sectionSegment.selectedSegmentIndex;
    [_pageVC setViewControllers:@[_dataSources[_controllerCurrentIndex]] direction:direction animated:true completion:nil];
}

#pragma mark - UIPageViewContollerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger currentIndex = ((ResultViewController *)viewController).section;
    _controllerCurrentIndex = currentIndex;
    [_sectionSegment setSelectedSegmentIndex:_controllerCurrentIndex];
    NSInteger preIndex = currentIndex - 1;
    
    if (preIndex < 0) {
        return nil;
    }
    return _dataSources[preIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger currentIndex = ((ResultViewController *)viewController).section;
    _controllerCurrentIndex = currentIndex;
    [_sectionSegment setSelectedSegmentIndex:_controllerCurrentIndex];
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex >= _dataSources.count) {
        return nil;
    }
    return _dataSources[nextIndex];
}

@end

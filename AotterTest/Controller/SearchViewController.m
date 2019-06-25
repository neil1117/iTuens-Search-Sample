//
//  SearchViewController.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/20.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailTableViewCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DetailCellDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) NSMutableArray *movieArray;
@property (strong, nonatomic) NSMutableArray *musicArray;

@property (strong, nonatomic) AFURLSessionManager *networkManager;
@property (strong, nonatomic) NSUserDefaults *userDefaults;



@end

@implementation SearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [self setupNetWorkManager];
    [self setupSearchBar];
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startSearch];
}

#pragma mark - Private

- (void)setupTableView {
    _movieArray = [[NSMutableArray alloc] init];
    _musicArray = [[NSMutableArray alloc] init];
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    [_resultTableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCell"];
    _resultTableView.tableFooterView = [[UIView alloc] init];
    [_resultTableView reloadData];
}

- (void)setupSearchBar {
    _searchBar.delegate = self;
}

- (void)setupNetWorkManager {
    _networkManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (nullable NSMutableArray *)getStarArrayWithSection:(KindForiTunes)section {
    
    NSMutableArray *targetArray;
    switch (section) {
        case movieType:
        case musicType:
            targetArray = [[_userDefaults objectForKey:[NSString stringWithFormat:@"%ld", section]] mutableCopy];
            if (!targetArray) {
                targetArray = [[NSMutableArray alloc] init];
            }
            break;
        default:
            break;
    }
    return targetArray;
}

- (BOOL)setStarArrayWithSection:(KindForiTunes)section newValue:(NSMutableArray *)array {
    [_userDefaults setObject:array forKey:[NSString stringWithFormat:@"%ld", section]];
    return [_userDefaults synchronize];
}

- (void)startSearch {
    if ([_searchBar.text isEqualToString:@""]) {
        return;
    }
    
    NSMutableCharacterSet *customCharacterSet = [[NSMutableCharacterSet alloc] init];
    [customCharacterSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    [customCharacterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [customCharacterSet addCharactersInString:@".-_*+"];
    
    NSString *searchKeyWord = [_searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    searchKeyWord = [searchKeyWord stringByAddingPercentEncodingWithAllowedCharacters:customCharacterSet];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=TW", searchKeyWord];
    NSURL *url  = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"applicatiopn/json" forHTTPHeaderField:@"Content-Type"];
    [[_networkManager dataTaskWithRequest:request uploadProgress:nil
                         downloadProgress:nil
                        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                            if (error ||
                                ![responseObject isKindOfClass:[NSDictionary class]] ||
                                ![((NSDictionary *)responseObject).allKeys containsObject:@"results"]) {
                                return;
                            }
                            NSArray *resultArray = ((NSDictionary *)responseObject)[@"results"];
                            NSMutableArray *musics = [[NSMutableArray alloc] init];
                            NSMutableArray *movies = [[NSMutableArray alloc] init];
                            NSMutableArray *musicStars = [self getStarArrayWithSection:musicType];
                            NSMutableArray *moviewStars = [self getStarArrayWithSection:movieType];
                            
                            for (int i = 0; i < resultArray.count; i++) {
                                NSDictionary *dic = resultArray[i];
                                NSString *kind = dic[kAPIKind];
                                NSString *trackId = dic[kAPITrackId];
                                
                                if (![kind isEqualToString:kAPISong] && ![kind isEqualToString:kAPIMovie]) {
                                    continue;
                                }
                                //利用 NSDate 取得歌曲的長度
                                NSInteger seconds = [dic[kAPITrackTimeMillis] integerValue] / 1000;
                                NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                formatter.dateFormat = @"HH:mm:ss";
                                formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                                NSString *timeStr = [formatter stringFromDate:date];
                                //最前面為 00: 就刪掉
                                if ([[timeStr substringToIndex:3] isEqualToString:@"00:"]) {
                                    timeStr = [timeStr substringFromIndex:3];
                                }
                                
                                if ([kind isEqualToString:kAPISong]) {
                                    NSMutableDictionary *cellDic = [DetailTableViewCell getConfigDicWithTrack:dic[kAPITrackName] artist:dic[kAPIArtistName] collection:dic[kAPICollectionName] longStr:timeStr description:nil image:dic[kAPIArtworkUrl100] isStar:[musicStars containsObject:trackId] index:[NSIndexPath indexPathForRow:musics.count inSection:musicType] otherInfo:@{kDicTrackId: trackId}];
                                    [musics addObject:cellDic];
                                } else if ([kind isEqualToString:kAPIMovie]) {
                                    NSMutableDictionary *cellDic = [DetailTableViewCell getConfigDicWithTrack:dic[kAPITrackName] artist:dic[kAPIArtistName] collection:dic[kAPICollectionName] longStr:timeStr description:dic[kAPILongDescription] image:dic[kAPIArtworkUrl100] isStar:[moviewStars containsObject:trackId] index:[NSIndexPath indexPathForRow:movies.count inSection:movieType] otherInfo:@{kDicTrackId: trackId}];
                                    [movies addObject:cellDic];
                                }
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.movieArray = movies;
                                self.musicArray = musics;
                                [self.resultTableView reloadData];
                            });
                        }] resume];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    if (section == movieType) {
        count = _movieArray.count;
    } else if (section == musicType) {
        count = _musicArray.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
    //給 cell 最新的寬度，並要求立即更新 ui
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NSMutableDictionary *dic;
    if (indexPath.section == movieType) {
        dic = _movieArray[indexPath.row];
    } else if (indexPath.section == musicType) {
        dic = _musicArray[indexPath.row];
    } else {
        return cell;
    }
    [cell configWithDictionary:dic];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *result;
    switch (section) {
        case movieType:
            if (_movieArray.count > 0) {
                result = @"電影";
            }
            break;
        case musicType:
            if (_musicArray.count > 0) {
                result = @"音樂";
            }
            break;
    }
    return result;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    [self startSearch];
}

#pragma mark - DetailCellDelegate

- (void)starButtonClickedIndex:(NSIndexPath *)index {
    
    NSInteger targetSection = index.section;
    NSInteger targetRow = index.row;
    NSArray *targetArray;
    switch (targetSection) {
        case movieType:
            targetArray = _movieArray;
            break;
        case musicType:
            targetArray = _musicArray;
        default:
            break;
    }
    
    if (!targetArray || targetArray.count <= targetRow) {
        return;
    }
    NSMutableDictionary *targetDic = targetArray[targetRow];
    BOOL newIsStar = ![targetDic[kDicIsStar] boolValue];
    
    
    
     NSMutableArray *sectionStarArray = [self getStarArrayWithSection:targetSection];
    if (newIsStar) {
         [sectionStarArray addObject:targetDic[kDicTrackId]];
    } else {
        [sectionStarArray removeObject:targetDic[kDicTrackId]];
    }
    BOOL isSaveScuuess = [self setStarArrayWithSection:targetSection newValue:sectionStarArray];
    
    if (!isSaveScuuess) {
        return;
    }
    
    targetDic[kDicIsStar] = @(newIsStar);
    [_resultTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)readMoreButtonClickedIndex:(NSIndexPath *)index {
    
    NSArray *targetArray;
    switch (index.section) {
        case movieType:
            targetArray = _movieArray;
            break;
        case musicType:
            targetArray = _musicArray;
        default:
            break;
    }
    NSMutableDictionary *dic = targetArray[index.row];
    if ([dic.allKeys containsObject:kDicIsRead] && ![dic[kDicIsRead] boolValue]) {
        dic[kDicIsRead] = @(true);
    }
    [_resultTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

@end

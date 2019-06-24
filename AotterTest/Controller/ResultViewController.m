//
//  ResultViewController.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/23.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "ResultViewController.h"
#import "DetailTableViewCell.h"

@interface ResultViewController () <UITableViewDelegate, UITableViewDataSource, DetailCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (strong, nonatomic) NSMutableArray *tableViewArray;
@property (strong, nonatomic) AFURLSessionManager *networkManager;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSMutableArray *idArray;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _networkManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getStarsWithType:_section];
    [self getStarDetail];
}

#pragma mark - Public

- (void)setShowSection:(KindForiTunes)section {
    _section = section;
}

#pragma mark - Private

- (void)setupTableView {
    _tableViewArray = [[NSMutableArray alloc] init];
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    [_resultTableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCell"];
    _resultTableView.tableFooterView = [[UIView alloc] init];
}

- (void)getStarDetail {
    if (_idArray.count == 0) {
        return;
    }
    NSMutableString *idStr = @"".mutableCopy;
    for (int i = 0; i < _idArray.count; i++) {
        [idStr appendString:[NSString stringWithFormat:@"%@", _idArray[i]]];
        if (i != _idArray.count - 1) {
            [idStr appendString:@","];
        }
    }
    __weak typeof(self) weakSelf = self;
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&country=TW", idStr]];
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
                            NSMutableArray *itemArray = [[NSMutableArray alloc] init];
                            
                            for (int i = 0; i < resultArray.count; i++) {
                                NSDictionary *dic = resultArray[i];
                                NSMutableDictionary *cellDic;
                                
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
                
                                if (weakSelf.section == movieType) {
                                    cellDic = [DetailTableViewCell getConfigDicWithTrack:dic[kAPITrackName] artist:dic[kAPIArtistName] collection:dic[kAPICollectionName] longStr:timeStr description:dic[kAPILongDescription] image:dic[kAPIArtworkUrl100] isStar:true index:[NSIndexPath indexPathForRow:itemArray.count inSection:0] otherInfo:@{kDicTrackViewUrl: dic[kAPITrackViewUrl]}];
                                } else if (weakSelf.section == musicType) {
                                    cellDic = [DetailTableViewCell getConfigDicWithTrack:dic[kAPITrackName] artist:dic[kAPIArtistName] collection:dic[kAPICollectionName] longStr:timeStr description:nil image:dic[kAPIArtworkUrl100] isStar:true index:[NSIndexPath indexPathForRow:itemArray.count inSection:0]  otherInfo:@{kDicTrackViewUrl: dic[kAPITrackViewUrl]}];
                                }
                                [itemArray addObject:cellDic];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                weakSelf.tableViewArray = itemArray;
                                [weakSelf.resultTableView reloadData];
                            });
                        }] resume];
}

- (void)getStarsWithType:(KindForiTunes)type {
    NSMutableArray *targetArray;
    switch (type) {
        case movieType:
        case musicType:
            targetArray = [[_userDefaults objectForKey:[NSString stringWithFormat:@"%ld", type]] mutableCopy];
            if (!targetArray) {
                targetArray = [[NSMutableArray alloc] init];
            }
            break;
        default:
            break;
    }
    _idArray = targetArray;;
}

- (BOOL)setStarArrayWithSection:(KindForiTunes)section newValue:(NSMutableArray *)array {
    [_userDefaults setObject:array forKey:[NSString stringWithFormat:@"%ld", section]];
    return [_userDefaults synchronize];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger targetRow = indexPath.row;
    if (_tableViewArray.count <= targetRow) {
        return;
    }
    NSDictionary *dic = _tableViewArray[targetRow];
    NSString *trackViewUrl = dic[kDicTrackViewUrl];
    NSLog(@"%@", trackViewUrl);
    if (trackViewUrl) {
        trackViewUrl = [trackViewUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"itms://"];
        NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
        if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
            [[UIApplication sharedApplication] openURL:appStoreURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @(true)} completionHandler:nil];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
    //給 cell 最新的寬度，並要求立即更新 ui
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    [cell layoutIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NSMutableDictionary *dic = _tableViewArray[indexPath.row];
    [cell configWithDictionary:dic];
    return cell;
}

#pragma mark - DetailCellDelegate

- (void)starButtonClickedIndex:(NSIndexPath *)index {
    
    NSInteger targetRow = index.row;
    
    if (_tableViewArray.count <= targetRow) {
        return;
    }
    NSMutableDictionary *targetDic = _tableViewArray[targetRow];
    
    [_idArray removeObject:targetDic[kDicTrackId]];
    BOOL isSaveScuuess = [self setStarArrayWithSection:_section newValue:_idArray];
    
    if (!isSaveScuuess) {
        return;
    }
    
    [_tableViewArray removeObject:targetDic];
    [_resultTableView reloadData];
    
    
}

- (void)readMoreButtonClickedIndex:(NSIndexPath *)index {
    
    NSMutableDictionary *dic = _tableViewArray[index.row];
    if ([dic.allKeys containsObject:kDicIsRead] && ![dic[kDicIsRead] boolValue]) {
        dic[kDicIsRead] = @(true);
    }
    [_resultTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

@end

//
//  Constants.h
//  AotterTest
//
//  Created by Neil Wu on 2019/6/23.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// 利用 enum 來分類, 也作為 TableView 的 Section
typedef NS_ENUM(NSUInteger, KindForiTunes) {
    movieType = 0,
    musicType = 1
};

// Theme Key
static NSString * const kThemeLightColor = @"light";
static NSString * const kThemeDeepColor = @"deep";

// Constant fot API
static NSString * const kAPITrackName = @"trackName";
static NSString * const kAPIArtistName = @"artistName";
static NSString * const kAPICollectionName = @"collectionName";
static NSString * const kAPILongDescription = @"longDescription";
static NSString * const kAPIArtworkUrl100 = @"artworkUrl100";
static NSString * const kAPITrackId = @"trackId";
static NSString * const kAPIKind = @"kind";
static NSString * const kAPISong = @"song";
static NSString * const kAPIMovie = @"feature-movie";
static NSString * const kAPITrackViewUrl = @"trackViewUrl";
static NSString * const kAPITrackTimeMillis = @"trackTimeMillis";

// Constant for Dictionary key
static NSString * const kDicTrackName = @"trackName";
static NSString * const kDicArtistName = @"artistName";
static NSString * const kDicCollectionName = @"collection";
static NSString * const kDicDescription = @"description";
static NSString * const kDicImageName = @"imageName";
static NSString * const kDicTrackId = @"trackId";
static NSString * const kDicIsStar = @"isStar";
static NSString * const kDicIsRead = @"isRead";
static NSString * const kDicSelfIndex = @"selfIndex";
static NSString * const kDicTrackViewUrl = @"trackViewUrl";
static NSString * const kDicTime = @"time";


//trackId = dic[@"trackId"];
//NSMutableDictionary *cellDic = [DetailTableViewCell getConfigDicWithTrack:dic[@"trackName"] artist:dic[@"artistName"] collection:dic[@"collectionName"] longStr:@"12:00" description:dic[@"longDescription"] image:dic[@"artworkUrl100"] isStar:[moviewStars containsObject:trackId] index:[NSIndexPath indexPathForRow:movies.count inSection:movieSection] otherInfo:@{@"trackId": trackId}];
//[movies addObject:cellDic];

#endif /* Constants_h */

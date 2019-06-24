//
//  DetailTableViewCell.h
//  AotterTest
//
//  Created by Neil Wu on 2019/6/20.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailCellDelegate <NSObject>
@required
- (void)starButtonClickedIndex:(NSIndexPath *)index;
- (void)readMoreButtonClickedIndex:(NSIndexPath *)index;
@end

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) id <DetailCellDelegate> delegate;

/**
 設定 Cell 需要的資料
 @param dic 用 getConfigDicWithTrack: artist: collection: longStr: description: image: isStar: index: otherInfo: 產生的 Dictionary
 */
- (void)configWithDictionary:(NSDictionary *)dic;

/**
 取得這個 Cell 需要的資料組合 Dictionary, 只要給顯示在 Cell 上面的資料剩下的 Cell 不需要的統統放在 otherInfo
 @param track 作品名稱
 @param artist 作者
 @param collection 專輯
 @param longStr 長度
 @param description 描述，可為空. 音樂沒有描述
 @param imageName 圖片網址
 @param isStar 是否收藏
 @param index 在 tableView 哪一個位置
 @param infoDic 其餘跟 Cell 顯示的資料沒有關係的都包在這裡
 */
+ (NSMutableDictionary *)getConfigDicWithTrack:(NSString *)track artist:(NSString *)artist collection:(NSString *)collection longStr:(NSString *)longStr description:(nullable NSString *)description image:(NSString *)imageName isStar:(BOOL)isStar index:(NSIndexPath *)index otherInfo:(nullable NSDictionary *)infoDic;

@end

NS_ASSUME_NONNULL_END

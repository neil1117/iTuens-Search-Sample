//
//  DetailTableViewCell.m
//  AotterTest
//
//  Created by Neil Wu on 2019/6/20.
//  Copyright © 2019 Neil Wu. All rights reserved.
//

#import "DetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readMoreButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descAndReadLayoutConstraint;

@property (strong,nonatomic) NSIndexPath *selfIndex;

@end

@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupButton];
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Private

- (void)setupButton {
    [_starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_readMoreButton addTarget:self action:@selector(readMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configWithDictionary:(NSDictionary *)dic {
    
    NSArray *allKeys = dic.allKeys;
    
    _trackNameLabel.text = [allKeys containsObject:kDicTrackName] ? dic[kDicTrackName] : @"";
    _artistNameLabel.text = [allKeys containsObject:kDicArtistName] ? dic[kDicArtistName] : @"";
    _collectionLabel.text = [allKeys containsObject:kDicCollectionName] ? dic[kDicCollectionName] : @"";
    _longLabel.text = [allKeys containsObject:kDicTime] ? dic[kDicTime] : @"";
    [_imageVIew sd_setImageWithURL:[NSURL URLWithString:dic[kDicImageName]]];
    
    //設定 收藏按鈕 上的文字
    if ([allKeys containsObject:kDicIsStar]) {
        _starLabel.text = [dic[kDicIsStar] boolValue] ? @"取消收藏" : @"收藏";
        [_starButton setHidden:false];
    } else {
        _starLabel.text = @"";
        [_starButton setHidden:true];
    }
    
    //先設定是否有描述這個資料
    if ([allKeys containsObject:kDicDescription]) {
        _descriptionLabel.text = dic[kDicDescription];
        [self setReadMoreButtonHidden:false];
    } else {
        [self setReadMoreButtonHidden:true];
        _descriptionLabel.text = @"";
    }
    
    //遇到下列的情況 a.描述行數 <= 2 b.已經按下 readMore 時，將 readMore 隱藏
    if (![dic[kDicIsRead] boolValue]) {
        int lineCount = [self lineCountForText:_descriptionLabel.text width:_descriptionLabel.frame.size.width font:_descriptionLabel.font];
        if (lineCount > 2) {
            _descriptionLabel.numberOfLines = 2;
        } else {
            [self setReadMoreButtonHidden:true];
        }
    } else {
        _descriptionLabel.numberOfLines = 0;
        [self setReadMoreButtonHidden:true];
    }
    
    _selfIndex = [allKeys containsObject:kDicSelfIndex] ? dic[kDicSelfIndex] : nil;
    
}

- (void)setReadMoreButtonHidden:(BOOL)setHidden {
    _readMoreButtonHeightConstraint.constant = setHidden ? 0 : 14;
    _readMoreButton.frame = CGRectMake(_readMoreButton.frame.origin.x, _readMoreButton.frame.origin.y, _readMoreButton.frame.size.width, setHidden ? 0 : 14);
    [_readMoreButton setHidden:setHidden];
    _descAndReadLayoutConstraint.constant = setHidden ? 0 : 5;
}

- (CGRect)getTextRectWithStrign:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    return rect;
}

- (int)lineCountForText:(NSString *)text width:(double)width font:(UIFont *)font {
    
    if ([text isEqualToString:@""]) {
        return 0;
    }
    
    CGRect rect = [self getTextRectWithStrign:text width:width font:font];
    
    return ceil(rect.size.height / font.lineHeight);
}

#pragma mark - Button Click Event

- (void)starButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(starButtonClickedIndex:)] && _selfIndex) {
        [_delegate starButtonClickedIndex:_selfIndex];
    }
}

- (void)readMoreButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(readMoreButtonClickedIndex:)] && _selfIndex) {
        [_delegate readMoreButtonClickedIndex:_selfIndex];
    }
}

#pragma mark - Public

+ (NSMutableDictionary *)getConfigDicWithTrack:(NSString *)track artist:(NSString *)artist collection:(NSString *)collection longStr:(NSString *)longStr description:(nullable NSString *)description image:(NSString *)imageName isStar:(BOOL)isStar index:(NSIndexPath *)index otherInfo:(nullable NSDictionary *)infoDic {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:track forKey:kDicTrackName];
    [dic setObject:artist forKey:kDicArtistName];
    if (collection) {
        [dic setObject:collection forKey:kDicCollectionName];
    }
    [dic setObject:longStr forKey:kDicTime];
    [dic setObject:imageName forKey:kDicImageName];
    [dic setObject:@(isStar) forKey:kDicIsStar];
    if (description) {
        [dic setObject:description forKey:kDicDescription];
    }
    [dic setObject:index forKey:kDicSelfIndex];
    [dic setObject:@(false) forKey:kDicIsRead];
    
    if (infoDic) {
        [dic setValuesForKeysWithDictionary:infoDic];
    }
    
    return dic;
}



@end

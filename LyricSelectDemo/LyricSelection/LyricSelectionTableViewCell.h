//
//  LyricSelectionTableViewCell.h
//  LyricSelectDemo
//
//  Created by chenjie on 15/8/9.
//  Copyright (c) 2015年 jch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyricSelectionCellDelegate <NSObject>

- (void)lyricSelectionCellDidPressedStartButtonInRow:(NSInteger)rowNo;
- (void)lyricSelectionCellDidPressedEndButtonInRow:(NSInteger)rowNo;

@end

@interface LyricSelectionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LyricSelectionCellDelegate> delegate;
@property (nonatomic, strong) NSString *lyricText;  ///< 一行歌词
@property (nonatomic, assign) NSInteger rowNo; ///< 第几行

@property (nonatomic, assign) BOOL lyricSelected;

@end

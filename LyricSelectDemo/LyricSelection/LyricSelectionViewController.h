//
//  LyricSelectionViewController.h
//  LyricSelectDemo
//
//  Created by chenjie on 15/8/9.
//  Copyright (c) 2015年 jch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyricSelectionDelegate <NSObject>

@required
- (void)lyricSelectionDidSelectStartRow:(NSInteger)startRow endRow:(NSInteger)endRow;

@end


@interface LyricSelectionViewController : UIViewController

@property (nonatomic, strong) NSArray *lyricArray;

+ (instancetype)getInstance;

- (void)setSelectionWithStartRow:(NSInteger)startRow endRow:(NSInteger)endRow;

@end

//
//  LyricSelectionTableViewCell.m
//  LyricSelectDemo
//
//  Created by chenjie on 15/8/9.
//  Copyright (c) 2015年 jch. All rights reserved.
//

#import "LyricSelectionTableViewCell.h"

@interface LyricSelectionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lyricLabel;

- (IBAction)onStartButtonPressed:(UIButton *)sender;
- (IBAction)onEndButtonPressed:(UIButton *)sender;

@end

@implementation LyricSelectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - event response
- (IBAction)onStartButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lyricSelectionCellDidPressedStartButtonInRow:)]) {
        [self.delegate lyricSelectionCellDidPressedStartButtonInRow:self.rowNo];
    }
}

- (IBAction)onEndButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lyricSelectionCellDidPressedEndButtonInRow:)]) {
        [self.delegate lyricSelectionCellDidPressedEndButtonInRow:self.rowNo];
    }
}

#pragma mark - setter
- (void)setLyricText:(NSString *)lyricText
{
    _lyricText = lyricText;
    self.lyricLabel.text = lyricText;
}

- (void)setLyricSelected:(BOOL)lyricSelected
{
    _lyricSelected = lyricSelected;
    if (lyricSelected) {
        self.backgroundColor = [UIColor redColor];
    }
    else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

//
//  ViewController.m
//  LyricSelectDemo
//
//  Created by chenjie on 15/8/9.
//  Copyright (c) 2015年 jch. All rights reserved.
//

#import "ViewController.h"
#import "LyricSelectionViewController.h"

@interface ViewController () <LyricSelectionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultEndLabel;

- (IBAction)onSelectButtonPressed:(UIButton *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"lyric selection demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LyricSelectionDelegate
- (void)lyricSelectionDidSelectStartRow:(NSInteger)startRow endRow:(NSInteger)endRow
{
    self.resultStartLabel.text = [NSString stringWithFormat:@"start at row: %ld", (long)startRow];
    self.resultEndLabel.text   = [NSString stringWithFormat:@"end at row: %ld",   (long)startRow];
}

#pragma mark - Event response
- (IBAction)onSelectButtonPressed:(UIButton *)sender {
    LyricSelectionViewController *vc = [LyricSelectionViewController getInstance];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  LyricSelectionViewController.m
//  LyricSelectDemo
//
//  Created by chenjie on 15/8/9.
//  Copyright (c) 2015年 jch. All rights reserved.
//

#import "LyricSelectionViewController.h"

@interface LyricSelectionViewController ()

@property (nonatomic) NSInteger startRow;
@property (nonatomic) NSInteger endRow;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LyricSelectionViewController

+ (instancetype)getInstance
{
    LyricSelectionViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LyricSelectionViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"lyric selection";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

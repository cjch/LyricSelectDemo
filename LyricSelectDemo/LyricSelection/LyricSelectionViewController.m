//
//  LyricSelectionViewController.m
//  LyricSelectDemo
//
//  Created by chenjie on 15/8/9.
//  Copyright (c) 2015年 jch. All rights reserved.
//

#import "LyricSelectionViewController.h"
#import "LyricSelectionTableViewCell.h"

static NSString * const LyricSelectionCellIdentifier = @"LyricSelectionTableViewCell";

@interface LyricSelectionViewController () <UITableViewDataSource, UITableViewDelegate, LyricSelectionCellDelegate>

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LyricSelectionTableViewCell" bundle:nil] forCellReuseIdentifier:LyricSelectionCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Method
- (void)setSelectionWithStartRow:(NSInteger)startRow endRow:(NSInteger)endRow
{
    self.startRow = startRow;
    self.endRow = endRow;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LyricSelectionCellIdentifier];
    cell.delegate = self;
    cell.lyricText = self.lyricArray[indexPath.row];
    cell.rowNo = indexPath.row;
    cell.lyricSelected = indexPath.row >= self.startRow && indexPath.row <= self.endRow;
    
    return cell;
}

#pragma mark - LyricSelectionCellDelegate
- (void)lyricSelectionCellDidPressedStartButtonInRow:(NSInteger)rowNo
{
    
}

- (void)lyricSelectionCellDidPressedEndButtonInRow:(NSInteger)rowNo
{
    
}

@end

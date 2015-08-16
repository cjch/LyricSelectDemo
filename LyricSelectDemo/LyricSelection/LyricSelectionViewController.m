//
//  LyricSelectionViewController.m
//  LyricSelectDemo
//
//  Created by chenjie on 15/8/9.
//  Copyright (c) 2015年 jch. All rights reserved.
//

#import "LyricSelectionViewController.h"
#import "LyricSelectionTableViewCell.h"

typedef NS_ENUM(NSInteger, PanGestureViewType){
    PanGestureViewTypeStart,
    PanGestureViewTypeEnd
};

static CGFloat const PanViewBorderLength = 44;
static NSString * const LyricSelectionCellIdentifier = @"LyricSelectionTableViewCell";

@interface LyricSelectionViewController () <UITableViewDataSource, UITableViewDelegate, LyricSelectionCellDelegate>

@property (nonatomic) NSInteger startRow;
@property (nonatomic) NSInteger endRow;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//手势相关
@property (nonatomic, strong) UIButton *selectStartButton, *selectEndButton;

@end

@implementation LyricSelectionViewController

#pragma mark - life circle
+ (instancetype)getInstance
{
    LyricSelectionViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LyricSelectionViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"lyric selection";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButtonPressed)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LyricSelectionTableViewCell" bundle:nil] forCellReuseIdentifier:LyricSelectionCellIdentifier];
    
    [self.tableView addSubview:self.selectStartButton];
    [self.tableView addSubview:self.selectEndButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Method
- (void)setSelectionWithStartRow:(NSInteger)startRow endRow:(NSInteger)endRow
{
    if (self.startRow >= self.lyricArray.count) {
        self.startRow = self.lyricArray.count - 1;
    }
    if (endRow < startRow) {
        endRow = startRow;
    }
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
    return PanViewBorderLength;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LyricSelectionCellIdentifier];
    cell.delegate = self;
    cell.lyricText = self.lyricArray[indexPath.row];
    cell.rowNo = indexPath.row;
    cell.lyricSelected = indexPath.row >= self.startRow && indexPath.row <= self.endRow;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - LyricSelectionCellDelegate
- (void)lyricSelectionCellDidPressedStartButtonInRow:(NSInteger)rowNo
{
    self.startRow = rowNo;
    self.endRow = MAX(self.startRow, self.endRow);
    [self updatePanView];
    [self.tableView reloadData];
}

- (void)lyricSelectionCellDidPressedEndButtonInRow:(NSInteger)rowNo
{
    self.endRow = rowNo;
    self.startRow = MIN(self.startRow, self.endRow);
    [self updatePanView];
    [self.tableView reloadData];
}

#pragma mark - event response and gesture
- (void)onDoneButtonPressed
{
    if ([self.delegate respondsToSelector:@selector(lyricSelectionDidSelectStartRow:endRow:)]) {
        [self.delegate lyricSelectionDidSelectStartRow:self.startRow endRow:self.endRow];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handlePanGes:(UIPanGestureRecognizer *)ges
{
    UIView *panView = [ges view];
    PanGestureViewType gesViewType = (PanGestureViewType)panView.tag;
    static CGRect oldStartFrame, oldEndFrame, referenceFrame;
    if (ges.state == UIGestureRecognizerStateBegan) {
        NSLog(@"=================ges begin=====================");
        oldStartFrame = self.selectStartButton.frame;
        oldEndFrame = self.selectEndButton.frame;
        referenceFrame = oldStartFrame;
        if (gesViewType == PanGestureViewTypeEnd) {
            referenceFrame = oldEndFrame;
        }
    }
    CGPoint curPoint = [ges translationInView:self.tableView];
    
    NSLog(@"panView : %f", panView.frame.origin.y);
    NSLog(@"curpoint: %f", curPoint.y);
    
    // 边界情况
    if ( -curPoint.y > referenceFrame.origin.y ) {
        //往上移动到tableView的顶部
        curPoint.y = -referenceFrame.origin.y;
    }
    else if(curPoint.y > self.lyricArray.count * PanViewBorderLength - referenceFrame.origin.y - PanViewBorderLength ) {
        // 往下移动到tableView底部(不包括footerView)
        curPoint.y = self.lyricArray.count * PanViewBorderLength - referenceFrame.origin.y - PanViewBorderLength;
    }
    
    CGRect startFrame = self.selectStartButton.frame;
    CGRect endFrame = self.selectEndButton.frame;
    //计算panView的新frame
    if (gesViewType == PanGestureViewTypeStart) {
        startFrame.origin.y = oldStartFrame.origin.y + curPoint.y;
        if (startFrame.origin.y > endFrame.origin.y) {
            endFrame.origin.y = startFrame.origin.y;
        }
    }
    else{
        endFrame.origin.y = oldEndFrame.origin.y + curPoint.y;
        if (endFrame.origin.y < startFrame.origin.y) {
            startFrame.origin.y = endFrame.origin.y;
        }
    }
    
    CGFloat duration = 0;
    if (ges.state == UIGestureRecognizerStateEnded) {
        //调整panView边界和cell对齐
        NSLog(@"=================ges end=====================");
        startFrame.origin.y = round(startFrame.origin.y / PanViewBorderLength) * PanViewBorderLength;
        endFrame.origin.y = round(endFrame.origin.y / PanViewBorderLength) * PanViewBorderLength;
        
        duration = 0.3;
    }
    
    //更新startRow和endRow
    self.startRow = round(startFrame.origin.y / PanViewBorderLength);
    self.endRow = round(endFrame.origin.y / PanViewBorderLength);
    
    //动画效果
    [UIView animateWithDuration:duration animations:^{
        self.selectStartButton.frame = startFrame;
        self.selectEndButton.frame = endFrame;
    }];
    [self.tableView reloadData];
}

#pragma mark - setter
- (UIButton *)selectStartButton
{
    if (!_selectStartButton) {
        _selectStartButton = [[UIButton alloc]initWithFrame:CGRectMake(0, PanViewBorderLength * _startRow, PanViewBorderLength, PanViewBorderLength)];
        [_selectStartButton setTitle:@"开始" forState:UIControlStateNormal];
        _selectStartButton.backgroundColor = [UIColor blueColor];
        _selectStartButton.tag = PanGestureViewTypeStart;
        
        UIPanGestureRecognizer *startPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGes:)];
        [_selectStartButton addGestureRecognizer:startPan];
        _selectStartButton.exclusiveTouch = YES;
    }
    
    return _selectStartButton;
}

- (UIButton *)selectEndButton
{
    if (!_selectEndButton) {
        _selectEndButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - PanViewBorderLength, PanViewBorderLength * _endRow, PanViewBorderLength, PanViewBorderLength)];
        [_selectEndButton setTitle:@"结束" forState:UIControlStateNormal];
        _selectEndButton.backgroundColor = [UIColor blueColor];
        _selectEndButton.tag = PanGestureViewTypeEnd;
        
        UIPanGestureRecognizer *endPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGes:)];
        [_selectEndButton addGestureRecognizer:endPan];
        _selectEndButton.exclusiveTouch = YES;
    }
    
    return _selectEndButton;
}

#pragma mark - Helper
- (void)updatePanView
{
    CGRect startFrame = self.selectStartButton.frame;
    CGRect endFrame =self.selectEndButton.frame;
    startFrame.origin.y = self.startRow * PanViewBorderLength;
    endFrame.origin.y = self.endRow * PanViewBorderLength;
    self.selectStartButton.frame = startFrame;
    self.selectEndButton.frame = endFrame;
}

@end

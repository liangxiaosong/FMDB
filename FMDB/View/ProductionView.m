//
//  ProductionView.m
//  FMDB
//
//  Created by LPPZ-User01 on 2017/4/12.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "ProductionView.h"
#import "LXSFMDB.h"

@interface ProductionView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView                *tableView;
@property (nonatomic, strong) NSMutableArray             *dataArray;
@property (nonatomic, strong) UISegmentedControl         *segment;
@property (nonatomic, strong) UIScrollView               *scrollView;
@property (nonatomic, strong) UILabel                    *alertLabel;
@property (nonatomic, strong) NSMutableArray             *columnNameArr;


@end

@implementation ProductionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        [self configViews];
    }
    return self;
}

- (void)configViews {
    LXSFMDB *db = [LXSFMDB shareDatabase];

    [self creatSegmentAndSView];

    if (![db lxs_isExistTable:@"user"]) {
        [self showAlertLabel];
    }else {
        self.columnNameArr = [NSMutableArray arrayWithArray:[db lxs_columnNameArray:@"user"]];
        [self creatTableView];
        self.scrollView.hidden = NO;
//        [self reloadData];
    }
}

- (void)creatSegmentAndSView {
    NSArray *array = @[@"插入",@"删除",@"更改",@"",@"查找",@"事务操作"];
    self.segment = [[UISegmentedControl alloc] initWithItems:array];
    self.segment.frame = CGRectMake(0, 20, KWidth, 25);
    _segment.tintColor = [UIColor colorWithWhite:0.8 alpha:1];
    _segment.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segment];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame), KWidth, KHeight / 2)];
    self.scrollView.contentSize = CGSizeMake(KWidth * array.count, KHeight / 2);
    self.scrollView.hidden = YES;
    [self addSubview:self.scrollView];
}

- (void)showAlertLabel {
    self.alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, KHeight/8, KWidth-100, KHeight/4)];
    _alertLabel.font = [UIFont systemFontOfSize:17];
    _alertLabel.numberOfLines = 0;
    _alertLabel.backgroundColor = [UIColor grayColor];
    _alertLabel.textColor = [UIColor whiteColor];
    _alertLabel.layer.cornerRadius = 5;
    _alertLabel.layer.masksToBounds = YES;
    _alertLabel.text = @"已默认创建数据库, 但无表, 点击任意位置创建表, 表字段由Person类根据runtime自动生成";

    [self addSubview:_alertLabel];
}

- (void)creatTableView
{
    [self addSubview:[self tableHeadView:_columnNameArr]];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KHeight/2+30, KWidth, KHeight/2-30)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 40;
    [self addSubview:_tableView];
}

- (UIView *)tableHeadView:(NSArray *)columnArr
{

    float width = KWidth;
    float height = 30;
    UIView *headView = UIView.new;
    headView.frame = CGRectMake(0, KHeight/2, KWidth, height);

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 15)];
    titleLabel.text = @"模拟显示数据库";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    [headView addSubview:titleLabel];

    for (int i = 0; i < columnArr.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*(width/columnArr.count), 15, width/columnArr.count, height-15)];
        label.text = columnArr[i];
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];

        [headView addSubview:label];
    }

    return headView;
}

#pragma mark - active

- (void)segmentAction:(UISegmentedControl *)seg
{
    [self.scrollView setContentOffset:CGPointMake(KWidth * seg.selectedSegmentIndex, 0) animated:YES];
}

@end

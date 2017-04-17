//
//  ProductionView.m
//  FMDB
//
//  Created by LPPZ-User01 on 2017/4/12.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "ProductionView.h"
#import "LXSFMDB.h"
#import "PersonTableViewCell.h"
#import "Person.h"

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
@property (nonatomic, strong) NSMutableArray             *blockArr;



@end

@implementation ProductionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        self.blockArr = [NSMutableArray arrayWithCapacity:0];
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
        [self reloadData];
    }
    [self insertSubviews];
    [self deleteSubviews];
    [self updateSubviews];
    [self lookupSubviews];
    [self inTransaction];
}

- (void)inTransaction
{
    NSArray *arr = @[@"用事务插入1000条数据"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20+KWidth*4, 20*(i+1)+i*30, KWidth-40, 30);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 500+i;
        [btn addTarget:self action:@selector(transactionBtn:) forControlEvents:UIControlEventTouchUpInside];

        [self.scrollView addSubview:btn];
    }
}

- (void)creatSegmentAndSView {
    NSArray *array = @[@"插入",@"删除",@"更改",@"查找",@"事务操作"];
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

#pragma mark - 增 删 查 改

- (void)insertSubviews{

    NSArray *arr = @[@"插入一条数据",@"插入一组数据",@"保证线程安全插入一条数据",@"异步(防止UI卡死)插入一条数据"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 20*(i+1)+i*30, KWidth-40, 30);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(insertBtn:) forControlEvents:UIControlEventTouchUpInside];

        [self.scrollView addSubview:btn];
    }
}

- (void)deleteSubviews{

    NSArray *arr = @[@"删除最后一条数据",@"删除全部数据",@"保证线程安全删除最后一条数据",@"异步(防止UI卡死)删除最后一条数据"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20+KWidth, 20*(i+1)+i*30, KWidth-40, 30);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];

        [self.scrollView addSubview:btn];
    }
}

- (void)updateSubviews{

    NSArray *arr = @[@"更新最后一条数据的name=testName",@"把表中的name全部改成godlike",@"保证线程安全更新最后一条数据",@"异步(防止UI卡死)更新最后一条数据"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20+KWidth*2, 20*(i+1)+i*30, KWidth-40, 30);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 300+i;
        [btn addTarget:self action:@selector(updateBtn:) forControlEvents:UIControlEventTouchUpInside];

        [self.scrollView addSubview:btn];
    }
}

- (void)lookupSubviews{

    NSArray *arr = @[@"查找name=cleanmonkey的数据",@"查找表中所有数据",@"保证线程安全查找name=cleanmonkey",@"异步(防止UI卡死)查找name=cleanmonkey"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20+KWidth*3, 20*(i+1)+i*30, KWidth-40, 30);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 400+i;
        [btn addTarget:self action:@selector(lookupBtn:) forControlEvents:UIControlEventTouchUpInside];

        [self.scrollView addSubview:btn];
    }
}


#pragma mark - active

- (void)segmentAction:(UISegmentedControl *)seg
{
    [self.scrollView setContentOffset:CGPointMake(KWidth * seg.selectedSegmentIndex, 0) animated:YES];
}

#pragma mark - *************** buttons action
- (void)insertBtn:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        if (i == btn.tag-100) {
            BLOCK block = _blockArr[i];
            block();
        }
    }
}

- (void)deleteBtn:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        if (i == btn.tag-200) {
            BLOCK block = _blockArr[i+4];
            block();
        }
    }
}

- (void)updateBtn:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        if (i == btn.tag-300) {
            BLOCK block = _blockArr[i+8];
            block();
        }
    }
}

- (void)lookupBtn:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        if (i == btn.tag-400) {
            BLOCK block = _blockArr[i+12];
            block();
        }
    }
}

- (void)transactionBtn:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        if (i == btn.tag-500) {
            BLOCK block = _blockArr[i+16];
            block();
        }
    }
}

- (void)insertMethod1:(BLOCK)block{[self.blockArr addObject:block];}
- (void)insertMethod2:(BLOCK)block{[self.blockArr addObject:block];}
- (void)insertMethod3:(BLOCK)block{[self.blockArr addObject:block];}
- (void)insertMethod4:(BLOCK)block{[self.blockArr addObject:block];}

- (void)deleteMethod1:(BLOCK)block{[self.blockArr addObject:block];}
- (void)deleteMethod2:(BLOCK)block{[self.blockArr addObject:block];}
- (void)deleteMethod3:(BLOCK)block{[self.blockArr addObject:block];}
- (void)deleteMethod4:(BLOCK)block{[self.blockArr addObject:block];}

- (void)updateMethod1:(BLOCK)block{[self.blockArr addObject:block];}
- (void)updateMethod2:(BLOCK)block{[self.blockArr addObject:block];}
- (void)updateMethod3:(BLOCK)block{[self.blockArr addObject:block];}
- (void)updateMethod4:(BLOCK)block{[self.blockArr addObject:block];}

- (void)lookupMethod1:(BLOCK)block{[self.blockArr addObject:block];}
- (void)lookupMethod2:(BLOCK)block{[self.blockArr addObject:block];}
- (void)lookupMethod3:(BLOCK)block{[self.blockArr addObject:block];}
- (void)lookupMethod4:(BLOCK)block{[self.blockArr addObject:block];}

- (void)transactionMethod1:(BLOCK)block{[self.blockArr addObject:block];}



- (void)reloadData
{
    LXSFMDB *db = [LXSFMDB shareDatabase];

    NSArray *resultArr = [db lxs_lookupTable:@"user" dicOrModel:[Person class] whereFormat:nil];

    self.dataArray = resultArr.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark --- 触摸开始

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        LXSFMDB *db = [LXSFMDB shareDatabase];

        if (![db lxs_isExistTable:@"user"]) {
            [_alertLabel removeFromSuperview];
            [db lxs_createTable:@"user" dicOrModel:[Person class]];
            self.columnNameArr = [NSMutableArray arrayWithArray:[db lxs_columnNameArray:@"user"]];
            [self creatTableView];
            self.scrollView.hidden = NO;
        }
    });
}


#pragma mark --- tebleViewDelegate -----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier columnArr:self.columnNameArr];
    }
    [cell setData:self.dataArray[indexPath.row]];
    return cell;
}

@end

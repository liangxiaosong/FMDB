//
//  PersonTableViewCell.h
//  FMDB
//
//  Created by LPPZ-User01 on 2017/4/17.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface PersonTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *pkid;
@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong)UILabel *phoneNum;
@property (nonatomic, strong)UILabel *photoData;
@property (nonatomic, strong)UILabel *luckyNum;
@property (nonatomic, strong)UILabel *sex;
@property (nonatomic, strong)UILabel *age;
@property (nonatomic, strong)UILabel *height;
@property (nonatomic, strong)UILabel *weight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier columnArr:(NSArray *)array;
- (void)setData:(Person *)model;

@end

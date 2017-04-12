//
//  ViewController.m
//  FMDB
//
//  Created by LPPZ-User01 on 2017/4/11.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "Person.h"
#import "LXSFMDB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *person = [[Person alloc] init];
    person.name = @"cleanmonkey";
    person.phoneNum = @(18866668888);
    person.photoData = UIImagePNGRepresentation([UIImage imageNamed:@"bg.jpg"]);
    person.luckyNum = 7;
    person.sex = 0;
    person.age = 26;
    person.height = 172.12;
    person.weight = 120.4555;

    // 用来测试操作一组数据
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3; i++) {
        Person *person = [[Person alloc] init];
        person.name = [self randomName];
        person.phoneNum = @(18866668888);
        person.photoData = UIImagePNGRepresentation([UIImage imageNamed:@"bg.jpg"]);
        person.luckyNum = 7;
        person.sex = arc4random()%2;
        person.age = 26;
        person.height = 172.12;
        person.weight = 120.4555;

        [mArr addObject:person];
    }

    LXSFMDB *db = [LXSFMDB shareDatabase];
    NSLog(@"last:%ld", (long)[db lastInsertPrimaryKeyId:@"user"]);


}

// 获得随机字符名称
- (NSString *)randomName{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 7; i++) {
        int figure = (arc4random() % 26) + 97;
        char character = figure;
        NSString *tempString = [NSString stringWithFormat:@"%c", character];
        string = [string stringByAppendingString:tempString];
    }

    return string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

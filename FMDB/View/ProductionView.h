//
//  ProductionView.h
//  FMDB
//
//  Created by LPPZ-User01 on 2017/4/12.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN
typedef void(^BLOCK)(void);

@interface ProductionView : UIView


- (void)reloadData;

- (void)insertMethod1:(BLOCK)block;
- (void)insertMethod2:(BLOCK)block;
- (void)insertMethod3:(BLOCK)block;
- (void)insertMethod4:(BLOCK)block;

- (void)deleteMethod1:(BLOCK)block;
- (void)deleteMethod2:(BLOCK)block;
- (void)deleteMethod3:(BLOCK)block;
- (void)deleteMethod4:(BLOCK)block;

- (void)updateMethod1:(BLOCK)block;
- (void)updateMethod2:(BLOCK)block;
- (void)updateMethod3:(BLOCK)block;
- (void)updateMethod4:(BLOCK)block;

- (void)lookupMethod1:(BLOCK)block;
- (void)lookupMethod2:(BLOCK)block;
- (void)lookupMethod3:(BLOCK)block;
- (void)lookupMethod4:(BLOCK)block;

- (void)transactionMethod1:(BLOCK)block;

@end
NS_ASSUME_NONNULL_END

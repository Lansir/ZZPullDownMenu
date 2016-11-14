//
//  ZZTitleListView.h
//  ZZPullDownControl
//
//  Created by 呵呵嗒 on 2016/11/11.
//  Copyright © 2016年 呵呵嗒. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlockShow) (NSInteger idx , BOOL isShow);

@interface ZZTitleListView : UIView

@property (nonatomic, strong) UIView *redAnimationView;

- (instancetype)initActionList:(NSArray *)titleList
                    clickBlock:(ClickBlockShow)block;

- (void)updateTitleActionShow:(BOOL)show;


@end

//
//  ZZPullDownView.h
//  ZZPullDownControl
//
//  Created by 呵呵嗒 on 2016/11/11.
//  Copyright © 2016年 呵呵嗒. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^ZZPullDownBlock) (NSString *details, NSInteger idx);


@interface ZZPullDownView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) ZZPullDownBlock clickBlock;

- (instancetype)initWithActionList:(NSArray *)listArr
                      withListItem:(NSDictionary *)listItem
                         withBlock:(ZZPullDownBlock)block;

- (void)updateDataWith:(NSDictionary*)itemInfo;
@end

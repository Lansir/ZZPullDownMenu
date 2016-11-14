//
//  TabViewController.m
//  ZZPullDownControl
//
//  Created by 呵呵嗒 on 2016/11/11.
//  Copyright © 2016年 呵呵嗒. All rights reserved.
//

#import "TabViewController.h"
#import "ZZPullDownView.h"


#define tag_pull_down   10001
@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"嘿，Tab啊";
    
    [self initUI];
    
}
#pragma mark - Data
- (void)initData
{
    
}
#pragma mark - UI
- (void)initUI
{
    NSArray *titleArr = @[@"itemOne",@"itemTWo",@"itemThree"];
    NSArray *itemOneArr = @[@"itemOne_1",@"itemOne_2",@"itemOne_3"];
    NSArray *itemTwoArr = @[@"itemTWo_1",@"itemTWo_2",@"itemTWo_3",@"itemTWo_4"];
    NSArray *itemThreeArr = @[@"itemThree_1",@"itemThree_2",@"itemThree_3",@"itemThree_4",@"itemThree_5",];
    NSDictionary *itemInfo = @{@"itemOne":itemOneArr,
                               @"itemTWo":itemTwoArr,
                               @"itemThree":itemThreeArr};
    ZZPullDownView *pullMenu =(ZZPullDownView*) [self.view viewWithTag:tag_pull_down];
    if (pullMenu) {
        //refresh
        [pullMenu updateDataWith:itemInfo];
    }else{
        pullMenu = [[ZZPullDownView alloc]initWithActionList:titleArr
                                                    withListItem:itemInfo
                                                   withBlock:^(NSString *details, NSInteger idx){
                                                       //实现点击方法
                                                   }];
        pullMenu.backgroundColor = [UIColor blackColor];
        pullMenu.tag = tag_pull_down;
        [self.view addSubview:pullMenu];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

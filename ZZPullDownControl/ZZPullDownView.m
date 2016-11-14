//
//  ZZPullDownView.m
//  ZZPullDownControl
//
//  Created by 呵呵嗒 on 2016/11/11.
//  Copyright © 2016年 呵呵嗒. All rights reserved.
//

#import "ZZPullDownView.h"
#import "ZZTitleListView.h"

#define PullTableViewHeight 230
#define PullTableViewMINHeight 100
#define pullTag    2001

@interface ZZPullDownView()
{
}

@property (nonatomic, strong) NSArray *listArr;

@property (nonatomic, strong) NSDictionary *itemInfo;

@property (nonatomic, strong) UIView        *bgView;

@property (nonatomic, strong) UITableView  *pullTableView;

@property (nonatomic, assign) NSInteger selectMenuIdx;

@property (nonatomic, strong) ZZTitleListView *listView;

@property (nonatomic, strong) NSMutableArray *listContentArray;

@property (nonatomic, strong) NSMutableArray *m_indexArray;

@end

@implementation ZZPullDownView
- (UIView*)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,50+64, SCREEN_WIDTH, SCREEN_HEIGHT-50-64)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.userInteractionEnabled = YES;
        _bgView.alpha = .5;
    }
    return _bgView;
}
- (instancetype)initWithActionList:(NSArray *)listArr
                      withListItem:(NSDictionary *)listItem
                         withBlock:(ZZPullDownBlock)block
{
    self = [super initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _selectMenuIdx = -1;
        
        self.listContentArray = [NSMutableArray new];
        self.m_indexArray = [NSMutableArray arrayWithArray:@[@(-1),@(-1),@(-1)]];
        
        self.listArr = listArr;
        self.itemInfo = listItem;
        [self setUpUI];
        
        [self initData];
        
        
        self.clickBlock = block;
    }
    return self;
}
#pragma mark - UI
- (void)setUpUI
{
    __weak __typeof(&*self)bSelf = self;
    ZZTitleListView *view = [[ZZTitleListView alloc]initActionList:self.listArr
                                                        clickBlock:^(NSInteger idx, BOOL isShow) {
                                                            if (_selectMenuIdx == idx) {
                                                                if (isShow){
                                                                    [bSelf addToSuper];
                                                                }else{
                                                                    [bSelf removeFromSuper];
                                                                }
                                                            }else{
                                                                _selectMenuIdx = idx;
                                                                [bSelf addToSuper];
                                                            }
                                                        }];
    _listView = view;
    [self addSubview:view];
    
    UITableView *tabView = [UITableView new];
    tabView.frame = CGRectMake(0.0f, 64 + 50.0f, SCREEN_WIDTH, 0);
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.rowHeight = 40;
    tabView.tag = pullTag;
    tabView.backgroundColor = [UIColor clearColor];
    _pullTableView = tabView;
}
#pragma mark - Data
- (void)initData
{
    for (id key in self.itemInfo) {
        [self.listContentArray addObject:[self.itemInfo objectForKey:key]];
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _selectMenuIdx = MAX(0, _selectMenuIdx);
    NSInteger count = [_listContentArray[_selectMenuIdx] count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    }
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    _selectMenuIdx = MAX(0,_selectMenuIdx);
    cell.textLabel.text = _listContentArray[_selectMenuIdx][indexPath.row];
    NSInteger selectIndex = [self.m_indexArray[_selectMenuIdx] integerValue];
    if (selectIndex ==  indexPath.row && selectIndex >= 0) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectMenuIdx = MAX(0, _selectMenuIdx);
    NSString *clickContentStr =  _listContentArray[_selectMenuIdx][indexPath.row];
    [self.m_indexArray replaceObjectAtIndex:_selectMenuIdx withObject:@(indexPath.row)];
    if (_clickBlock) {
        _clickBlock(clickContentStr,_selectMenuIdx);
        [self removeFromSuper];
        [self.listView updateTitleActionShow:NO];
    }
    [tableView reloadData];
}

#pragma makr - 方法
- (void)addToSuper
{
    [self.superview addSubview:self.bgView];
    if (self.superview) {
        if (![self.superview viewWithTag:pullTag]) {
            [self.superview addSubview:_pullTableView];
        }
        CGRect rTemp = CGRectZero;
        rTemp = _pullTableView.frame;
        rTemp.origin.y = 50 + 64;
        _pullTableView.frame = rTemp;
        
        [self setUpHeight];
    }
    [_pullTableView reloadData];
}
- (void)updateDataWith:(NSDictionary*)itemInfo
{
    [self initData];
    [_pullTableView reloadData];
}
- (void)setUpHeight
{
    _selectMenuIdx = MAX(0, _selectMenuIdx);
    NSInteger count = [[self.listContentArray objectAtIndex:_selectMenuIdx]count];
    CGFloat totalHeight = count * 40;
    totalHeight = MAX(PullTableViewMINHeight, totalHeight);
    totalHeight = MIN(totalHeight, PullTableViewHeight);
    
    CGRect rTemp = CGRectZero;
    rTemp = _pullTableView.frame;
    rTemp.size.height = totalHeight;
    _pullTableView.frame = rTemp;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
    tap.numberOfTapsRequired = 1;
    _bgView.frame = CGRectMake(0.0f, totalHeight+50+64, SCREEN_HEIGHT, SCREEN_HEIGHT - totalHeight);
    [_bgView addGestureRecognizer:tap];
}

- (void)hide:(UITapGestureRecognizer *)tap
{
    [self removeFromSuper];
}
-(void)removeFromSuper
{
    if (self.superview) {
        [_bgView removeFromSuperview];
        [_pullTableView removeFromSuperview];
        _listView.redAnimationView.hidden = YES;
    }
}
@end

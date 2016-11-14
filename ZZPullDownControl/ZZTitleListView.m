//
//  ZZTitleListView.m
//  ZZPullDownControl
//
//  Created by 呵呵嗒 on 2016/11/11.
//  Copyright © 2016年 呵呵嗒. All rights reserved.
//

#import "ZZTitleListView.h"
#import "Masonry.h"

#define tag_self_btn   1001
@interface ZZTitleListView ()
{
    BOOL isShow;
    
    NSInteger preIndex;
}
//选项
@property (nonatomic, strong) NSArray *btnTitleArr;

//item选项
@property (nonatomic, strong) NSMutableArray *totalBtnList;

@property (nonatomic, copy) ClickBlockShow clickShowBlock;



@end

@implementation ZZTitleListView

- (instancetype)initActionList:(NSArray *)titleList
                    clickBlock:(ClickBlockShow)block
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.btnTitleArr = titleList;
        _totalBtnList = [NSMutableArray arrayWithCapacity:0];
        [self setUpUI];
        preIndex = -1;
        isShow = NO;
        self.clickShowBlock = block;
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    CGRect rTemp = CGRectZero;
    NSInteger width = SCREEN_WIDTH / [self.btnTitleArr count];
    for (NSInteger idx = 0 ; idx < [self.btnTitleArr count]; idx++){
        rTemp = CGRectMake(idx *width, 0, width, 50);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rTemp;
        [btn setTitle:[self.btnTitleArr objectAtIndex:idx] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        btn.tag = tag_self_btn + idx;
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 55.0f, 0.0f, 0.0f)];
        [self addSubview:btn];
        
        //分隔线(坚线)
        if ( idx < [self.btnTitleArr count]) {
            UIView *aligView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 50)];
            aligView.backgroundColor = UIColorFromHex(0xf2f2f2);
            [self addSubview:aligView];
            CGRect aligViewFrame = aligView.frame;
            aligViewFrame.origin.x = idx * width;
            aligView.frame = aligViewFrame;
        }
        
        [_totalBtnList addObject:btn];
    }
    
    //选中红色线
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 2)];
    redView.backgroundColor = [UIColor redColor];
    redView.hidden = YES;
    [self addSubview:redView];
    CGRect redViewFrame = redView.frame;
    redViewFrame.origin.y = self.frame.size.height - 2;
    redView.frame = redViewFrame;
    _redAnimationView = redView;
}
#pragma mark - 事件
- (void)onBtnClick:(UIButton *)sender
{
     [self setSelectBtnIndex:sender.tag - tag_self_btn];
}

//设置选中项
- (void)setSelectBtnIndex:(NSInteger)index
{
    [self.totalBtnList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = (UIButton*)obj;
        if (idx == index) {
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }];
    [self doAnimation:index];
    preIndex = index;
}

- (void)doAnimation:(NSInteger)index
{
    if (preIndex == index) {
        isShow = !isShow;
        _redAnimationView.hidden = true;
    }else{
        isShow = true;
        _redAnimationView.hidden = false;
    }
    
    NSInteger width = SCREEN_WIDTH / [self.btnTitleArr count];
    __weak __typeof(&*self)bSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect redAnimationRect = _redAnimationView.frame;
        redAnimationRect.origin.x = width * index;
        _redAnimationView.frame = redAnimationRect;
        if (bSelf.clickShowBlock) {
            bSelf.clickShowBlock(index,isShow);
        }
    }];
}
- (void)updateTitleActionShow:(BOOL)show
{
    isShow = show;
}
@end

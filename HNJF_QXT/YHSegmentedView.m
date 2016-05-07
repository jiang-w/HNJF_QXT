//
//  YHSegmentedView.m
//  HNJF_QXT
//
//  Created by 江伟 on 16/4/27.
//  Copyright © 2016年 jiangw. All rights reserved.
//

#import "YHSegmentedView.h"

@interface YHSegmentedView ()

@property (nonatomic, strong) NSMutableArray *itemButtons;
@property (nonatomic, strong) NSMutableArray *itemConstraints;

@end

@implementation YHSegmentedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemButtons = [NSMutableArray array];
        _itemConstraints = [NSMutableArray array];
        _selectedIndex = -1;
    }
    return self;
}

- (void)setItemTitles:(NSArray *)titles {
    [self removeAllConstraints];
    for (UIButton *btn in self.itemButtons) {
        [btn removeFromSuperview];
    }
    [self.itemButtons removeAllObjects];
    
    if (titles.count > 0) {
        for (NSString *title in titles) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:tabbar_select_color forState:UIControlStateSelected];
            [btn setTitleColor:tabbar_normal_color forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            
            UILabel *bottomLine = [[UILabel alloc] init];
            bottomLine.backgroundColor = tabbar_select_color;
            bottomLine.tag = 1001;
            bottomLine.hidden = YES;
            [btn addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(btn);
                make.height.mas_offset(2);
            }];
            
            [btn addTarget:self action:@selector(tapButtonEventHandle:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.itemButtons addObject:btn];
            [self addSubview:btn];
        }
        [self addItemConstraints];
        
        self.selectedIndex = 0;
    }
    
    [self setNeedsLayout];
}

- (void)removeAllConstraints {
    for (id obj in self.itemConstraints) {
        if ([obj isKindOfClass:MASConstraint.class]) {
            [(MASConstraint *)obj uninstall];
        }
        else if([obj isKindOfClass:NSArray.class]) {
            for (MASConstraint * constraint in (NSArray *)obj) {
                [constraint uninstall];
            }
        }
        else {
            NSAssert(NO, @"Error:unknown class type: %@", obj);
        }
    }
    [self.itemConstraints removeAllObjects];
}

- (void)addItemConstraints {
    UIButton *prevBtn;
    for (UIButton *btn in self.itemButtons) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (prevBtn) {
                [self.itemConstraints addObject:make.left.equalTo(prevBtn.mas_right)];
                [self.itemConstraints addObject:make.width.equalTo(prevBtn)];
            }
            else {
                [self.itemConstraints addObject:make.left.equalTo(self)];
            }
            
            if (btn == self.itemButtons.lastObject) {
                [self.itemConstraints addObject:make.right.equalTo(self)];
            }
            
            [self.itemConstraints addObject:make.top.bottom.equalTo(self)];
        }];
        
        prevBtn = btn;
    }
}

- (void)tapButtonEventHandle:(UIButton *)button {
    NSUInteger index = [self.itemButtons indexOfObject:button];
    self.selectedIndex = index;
}

- (void)setSelectedIndex:(NSInteger)index {
    if (index >= -1 && (self.itemButtons.count - index) > 0 && _selectedIndex != index) {
        NSInteger oldIndex = _selectedIndex;
        _selectedIndex = index;
        
        if (oldIndex != -1) {
            UIButton *oldTag = self.itemButtons[oldIndex];
            oldTag.selected = NO;
            [oldTag viewWithTag:1001].hidden = YES;
            
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(segmentedView:didChangedIndex:)]) {
                    [self.delegate segmentedView:self didChangedIndex:_selectedIndex];
                }
            }
        }
        
        if (_selectedIndex != -1) {
            UIButton *selectTag = self.itemButtons[_selectedIndex];
            selectTag.selected = YES;
            [selectTag viewWithTag:1001].hidden = NO;
        }
    }
}


@end

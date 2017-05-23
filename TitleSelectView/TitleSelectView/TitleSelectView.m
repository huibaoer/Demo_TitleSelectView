//
//  TitleView.m
//  ShuiHuiSaas
//
//  Created by zhanght on 16/4/27.
//  Copyright © 2016年 . All rights reserved.
//

#import "TitleSelectView.h"

#define kAnimateLineHeight  2

@interface TitleSelectView ()
@property (nonatomic, copy) SelectHandler selectHandler;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *animateLine;
@property (nonatomic, strong) NSLayoutConstraint *lcAnimateLineLeading;

@end

@implementation TitleSelectView

- (void)setTitles:(NSArray *)titles selectHandler:(SelectHandler)selectHandler {
    self.titles = titles;
    self.selectHandler = selectHandler;
    [self setupUI];
}

- (void)setupUI {
    self.clipsToBounds = YES;
    _selectedIndex = -1;
    _normalFontSize = 15.0f;
    _selectedFontSize = 18.0f;
    _normalColor = [UIColor grayColor];
    _selectedColor = [UIColor redColor];
    
    //buttons
    NSMutableArray *buttons = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.tag = i;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:btn];
        [self addSubview:btn];
        
        NSLayoutConstraint *lcTop = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:lcTop];
        NSLayoutConstraint *lcBottom = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraint:lcBottom];
        if (i == 0) {//first
            NSLayoutConstraint *lcLeft = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            [self addConstraint:lcLeft];
        } else {
            UIButton *lastBtn = buttons[i-1];
            NSLayoutConstraint *lcLeft = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lastBtn attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            [self addConstraint:lcLeft];
            NSLayoutConstraint *lcWidth = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastBtn attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
            [self addConstraint:lcWidth];
            
            if (i == self.titles.count-1) {//last
                NSLayoutConstraint *lcRight = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
                [self addConstraint:lcRight];
            }
        }
    }
    self.buttons = buttons;
    
    //animateLine
    self.animateLine = [[UIView alloc] init];
    self.animateLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.animateLine.backgroundColor = self.selectedColor;
    [self addSubview:self.animateLine];
    
    UIButton *btn = self.buttons.firstObject;
    NSLayoutConstraint *lcWidth = [NSLayoutConstraint constraintWithItem:self.animateLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self addConstraint:lcWidth];
    NSLayoutConstraint *lcHeight = [NSLayoutConstraint constraintWithItem:self.animateLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kAnimateLineHeight];
    [self addConstraint:lcHeight];
    NSLayoutConstraint *lcBottom = [NSLayoutConstraint constraintWithItem:self.animateLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:lcBottom];
    self.lcAnimateLineLeading = [NSLayoutConstraint constraintWithItem:self.animateLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self addConstraint:self.lcAnimateLineLeading];
    
    [self setSelectedIndex:0];
}

- (void)buttonAction:(UIButton *)btn {
    if (btn.selected) return;
    [self setSelectedIndex:btn.tag];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex) return;
    if (selectedIndex >= self.buttons.count) return;
    
    _selectedIndex = selectedIndex;
    for (UIButton *btn in self.buttons) {
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:self.normalFontSize];
    }
    UIButton *selectedBtn = self.buttons[_selectedIndex];
    [selectedBtn setTitleColor:self.selectedColor forState:UIControlStateNormal];
    selectedBtn.titleLabel.font = [UIFont systemFontOfSize:self.selectedFontSize];
    
    //animation
    [UIView animateWithDuration:0.1 animations:^{
        self.lcAnimateLineLeading.constant = selectedBtn.bounds.size.width*_selectedIndex;
        [self layoutIfNeeded];
    } completion:nil];
    _selectHandler(_selectedIndex);
}

- (void)setScrollProgress:(CGFloat)scrollProgress {
    _scrollProgress = scrollProgress;
    
    for (UIButton *btn in self.buttons) {
        CGFloat detal = fabsf(_scrollProgress - btn.tag);
        if (detal < 1) {
            CGFloat red, green, blue, alpha;
            [self.normalColor getRed:&red green:&green blue:&blue alpha:&alpha];
            red *= detal;
            green *= detal;
            blue *= detal;
            
            CGFloat red1, green1, blue1, alpha1;
            [self.selectedColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
            red1 *= (1-detal);
            green1 *= (1-detal);
            blue1 *= (1-detal);
            
            UIColor *color = [UIColor colorWithRed:red+red1 green:green+green1 blue:blue+blue1 alpha:1.0];
            [btn setTitleColor:color forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
        
        if (detal>=-0.000001f && detal<=0.000001f) {
            [self setSelectedIndex:btn.tag];
        }
    }
    
    UIButton *btn = self.buttons.firstObject;
    self.lcAnimateLineLeading.constant = btn.bounds.size.width*_scrollProgress;
    [self layoutIfNeeded];

}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    for (UIButton *btn in self.buttons) {
        [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        if (btn.tag == self.selectedIndex) {
            [btn setTitleColor:self.selectedColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if (self.selectedIndex != -1 && self.selectedIndex < self.buttons.count) {
        UIButton *selectedBtn = self.buttons[self.selectedIndex];
        [selectedBtn setTitleColor:_selectedColor forState:UIControlStateNormal];
    }
    self.animateLine.backgroundColor = _selectedColor;
}



@end













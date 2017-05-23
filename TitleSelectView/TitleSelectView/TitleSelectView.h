//
//  TitleView.h
//  ShuiHuiSaas
//
//  Created by zhanght on 16/4/27.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^SelectHandler)(NSInteger selectedIndex);

/**
 *  TitleSelectView：实现类似segmentControl的选中功能
 *  适用场景：1.navigationBar的titleView
 *          2.作为子视图贴到其他view上
 */
@interface TitleSelectView : UIView
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat scrollProgress;
@property (nonatomic, assign) CGFloat normalFontSize;
@property (nonatomic, assign) CGFloat selectedFontSize;

- (void)setTitles:(NSArray *)titles selectHandler:(SelectHandler)selectHandler;

@end








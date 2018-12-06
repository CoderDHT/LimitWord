//
//  LimitWordTextView.h
//  LimitWord
//
//  Created by 董海涛 on 2018/12/5.
//  Copyright © 2018年 董海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitWordTextView : UITextView

/// 限制长度
@property (nonatomic, assign) NSInteger limitLength;

/// placeholder
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderTextColor;

@property (nonatomic, strong) UIFont *placeholderFont;

/// 文本发生改变回调
@property (nonatomic, copy) void (^TextDidChanged)(NSString *text);

@end

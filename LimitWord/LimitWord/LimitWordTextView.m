//
//  LimitWordTextView.m
//  LimitWord
//
//  Created by 董海涛 on 2018/12/5.
//  Copyright © 2018年 董海涛. All rights reserved.
//

#import "LimitWordTextView.h"

@interface LimitWordTextView ()

// placeholder
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation LimitWordTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self config];
}

// MARK: 设置
- (void)config {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self createPlaceholderLabel];
}

// MARK: 创建placeholderLabel
- (void)createPlaceholderLabel {
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:12];
    self.placeholderLabel.numberOfLines = 0;
    [self addSubview:self.placeholderLabel];
}

// MARK: 文本发生变化
- (void)textDidChanged:(NSNotification *)notification {
    
    self.placeholderLabel.hidden = self.text.length;
    
    /*
     四种情况不处理
     1. 不是当前TextView文本发生变化
     2. limitLength 小于等于0 无意义
     3. 当前长度小于 limitLength
     4. 变化的是标记部分, 若限制会出现拼音输入一半不能继续输入的情况(如系统输入法输入中文时, 拼音会被标记显示在输入框中)
     */
    if (notification.object != self || self.limitLength <= 0 || self.text.length <= self.limitLength) {
        if (self.TextDidChanged) {
            self.TextDidChanged(self.text);
        }
        return;
    };
    
    // 需特殊处理, 去除标记后长度小于 limitLength 则不进行限制, 防止拼音输入一半的情况; 反之则进行限制, 连拼音也不允许输入
    if (self.markedTextRange) {
        // 标记部分
        NSString *markedText = [self textInRange:self.markedTextRange];
        if ([self.text stringByReplacingOccurrencesOfString:markedText withString:@""].length < self.limitLength) {
            if (self.TextDidChanged) {
                self.TextDidChanged(self.text);
            }
            
            return;
        };
    }
    
    // 光标前文本
    NSString *beforeCursorText = [self.text substringToIndex:self.selectedRange.location];
    
    // 光标后文本
    NSString *afterCursorText = [self.text substringFromIndex:self.selectedRange.location];
    
    // 光标前可输入的文本长度
    NSInteger restLength = self.limitLength - afterCursorText.length;
    // 截取光标前文本 拼接上光标后文本
    self.text = [[beforeCursorText substringToIndex:restLength] stringByAppendingString:afterCursorText];
    
    // 设置光标位置
    self.selectedRange = NSMakeRange(restLength, 0);
    
    if (self.TextDidChanged) {
        self.TextDidChanged(self.text);
    }
}

// MARK: 重载 paste: 方法
// 由于默认的 paste: 方法会设置光标的位置, 同时上面截取字符串会导致光标位置错乱
- (void)paste:(id)sender {
    
    // 光标前文本
    NSString *beforeCursorText = [self.text substringToIndex:self.selectedRange.location];
    
    // 待粘贴文本
    NSString *pasteText = [UIPasteboard generalPasteboard].string;
    
    // 光标后文本
    NSString *afterCursorText = [self.text substringFromIndex:self.selectedRange.location];
    
    // 光标前文本 + 待粘贴文本 + 光标后文本
    self.text = [[beforeCursorText stringByAppendingString:pasteText] stringByAppendingString:afterCursorText];
    
    // 设置光标位置
    self.selectedRange = NSMakeRange(self.text.length, -afterCursorText.length);
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}

// MARK: - Setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor;
    
    self.placeholderLabel.textColor = placeholderTextColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    
    self.placeholderLabel.font = placeholderFont;
}

- (void)layoutSubviews {
    // 貌似总会偏一点 所以加4
    self.placeholderLabel.frame = CGRectMake(self.textContainerInset.left + 4, self.textContainerInset.top, CGRectGetWidth(self.frame) - self.textContainerInset.left - self.textContainerInset.right - 4, CGRectGetHeight(self.frame) - self.textContainerInset.top - self.textContainerInset.bottom);
    [self.placeholderLabel sizeToFit];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end

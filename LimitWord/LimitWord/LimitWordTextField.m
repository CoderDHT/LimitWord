//
//  LimitWordTextField.m
//  LimitWord
//
//  Created by 董海涛 on 2018/12/5.
//  Copyright © 2018年 董海涛. All rights reserved.
//

#import "LimitWordTextField.h"

@implementation LimitWordTextField

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
    [self addTarget:self action:@selector(textDidChanged) forControlEvents:UIControlEventEditingChanged];
}

// MARK: 文本发生变化
- (void)textDidChanged {
    /*
     三种情况不处理
     1. limitLength 小于等于0 无意义
     2. 当前长度小于 limitLength
     3. 变化的是标记部分(主要指拼音), 若限制会出现拼音输入一半不能继续输入的情况(如系统输入法输入中文时, 拼音会被标记显示在输入框中)
     */
    if (self.limitLength <= 0 || self.text.length <= self.limitLength) return ;
    
    // 需特殊处理, 去除标记后长度小于 limitLength 则不进行限制, 防止拼音输入一半的情况; 反之则进行限制, 连拼音也不允许输入
    if (self.markedTextRange) {
        // 标记部分
        NSString *markedText = [self textInRange:self.markedTextRange];
        if ([self.text stringByReplacingOccurrencesOfString:markedText withString:@""].length < self.limitLength) return ;
    }
    
    // 光标后文本
    NSString *afterCursorText = [self afterCursorText];
    
    // 光标前可输入的文本长度
    NSInteger restLength = self.limitLength - afterCursorText.length;
    // 截取光标前文本 + 光标后文本
    self.text = [[[self beforeCursorText] substringToIndex:restLength] stringByAppendingString:afterCursorText];
    
    // 设置光标位置(末尾向前偏移'光标后文本'长度)
    [self setCursorPositionOffsetByEndOfDocument:afterCursorText.length];
}

// MARK: 重载 paste: 方法
// 由于默认的 paste: 方法会设置光标的位置, 同时上面截取字符串会导致光标位置错乱
- (void)paste:(id)sender {

    // 待粘贴文本
    NSString *pasteText = [UIPasteboard generalPasteboard].string;

    // 光标后文本
    NSString *afterCursorText = [self afterCursorText];
    
    // 光标前文本 + 待粘贴文本 + 光标后文本
    self.text = [[[self beforeCursorText] stringByAppendingString:pasteText] stringByAppendingString:afterCursorText];

    // 设置光标位置(末尾向前偏移'光标后文本'长度)
    [self setCursorPositionOffsetByEndOfDocument:afterCursorText.length];

    [self textDidChanged];
}

// MARK: 获取光标前文本
- (NSString *)beforeCursorText {
    UITextRange *beginRange = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    return [self textInRange:beginRange];
}

// MARK: 获取光标后文本
- (NSString *)afterCursorText {
    UITextRange *endRange = [self textRangeFromPosition:self.selectedTextRange.start toPosition:self.endOfDocument];
    return [self textInRange:endRange];
}

// MARK: 设置光标位置(相对于文本末尾偏移量)
- (void)setCursorPositionOffsetByEndOfDocument:(NSInteger)offset {
    UITextPosition *cursorPosition = [self positionFromPosition:self.endOfDocument offset:-offset];
    self.selectedTextRange = [self textRangeFromPosition:cursorPosition toPosition:cursorPosition];
}

@end

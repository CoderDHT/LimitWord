//
//  ViewController.m
//  LimitWord
//
//  Created by 董海涛 on 2018/12/6.
//  Copyright © 2018年 董海涛. All rights reserved.
//

#import "ViewController.h"
#import "LimitWordTextField.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"限制字数";
    
    /*****相比于其他限制字数方案的优势******/
    /*
     1. 对拼音输入友好, 允许输入时不会出现拼音输入一半不能继续输入的情况, 同时不允许输入时连拼音也不能输入
     2. 将光标移到文本中间继续输入时不会替换末尾文本, 同时输入完光标不会移到末尾
     3. 对粘贴处理妥当, 不会因为粘贴导致光标位置错乱
     4. 对 delegate 和 UIMenuController 没有任何影响
     */
    
    LimitWordTextField *textField = [[LimitWordTextField alloc] initWithFrame:CGRectMake(50, 100, kScreenWidth - 50 * 2, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = RGB(230, 230, 230);
    textField.placeholder = @"限制5个字";
    textField.limitLength = 5;
    [self.view addSubview:textField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//
//  ViewController.m
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+RegulateMoneyInput.h"

@interface ViewController () <UITextFieldDelegate>

@end

static const CGFloat kMaxMoney = 100.00;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect textFrame = CGRectMake(15, 80, [UIScreen mainScreen].bounds.size.width - 30, 30);
    UITextField *topTextFiled = [[UITextField alloc] initWithFrame:textFrame];
    topTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    topTextFiled.placeholder = [NSString stringWithFormat:@"Money && amount <= %.2f", kMaxMoney];
    topTextFiled.delegate = self;
    [self.view addSubview:topTextFiled];
    // We hope input only money in this textField.
    topTextFiled.isMoney = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString doubleValue] - kMaxMoney > 0.009999) {// amount should <= kMaxMoney
        return NO;
    }
    return YES;
}

@end

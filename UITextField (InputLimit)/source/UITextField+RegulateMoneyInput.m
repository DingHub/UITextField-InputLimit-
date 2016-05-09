//
//  UITextField+RegulateMoneyInput.m
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "UITextField+RegulateMoneyInput.h"
#import <objc/runtime.h>


@interface UITextFieldMoneyObserver : NSObject

@property (nonatomic, copy) NSString *currectText;

@end

@implementation UITextFieldMoneyObserver

- (void)textChanged:(UITextField *)textField {

    NSString *allText = textField.text;

    if (textField.isMoney) {
        
        NSString *newString;
        if (_currectText) {
            NSRange oldTextRange = [allText rangeOfString:_currectText];
            newString = [allText substringFromIndex:oldTextRange.length];
        } else {
            newString = allText;
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]invertedSet];
        NSString *filtered = [[newString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (filtered.length == 0) {
            if ([newString isEqualToString:@""]) {//inputed backSpace
                _currectText = newString;
            }
            textField.text = _currectText;
            return;
        }
        if ([_currectText rangeOfString:@"."].length) {
            if ([newString isEqualToString:@"."]) {//only one '.'
                textField.text = _currectText;
                return;
            }
            //2 charactors limited after '.'
            NSArray *ary =  [_currectText componentsSeparatedByString:@"."];
            if (ary.count == 2) {
                if ([ary[1] length] >= 2) {
                    NSArray *newStringArray = [newString componentsSeparatedByString:@"."];
                    if (newStringArray.count == 2 && [newStringArray[1] length] == 1) {//inputed backSpace
                        _currectText = newString;
                    }
                    textField.text = _currectText;
                    return;
                }
            }

        } else if (_currectText.length == 1) {
            if ([newString isEqualToString:@"0"] && [_currectText isEqualToString:@"0"]) {
                textField.text = _currectText;
                return;
            }
        }
        if (_currectText.length == 0 && [newString isEqualToString:@"."]) {//"."->"0."
            textField.text
            = _currectText
            = @"0.";
            return;
        }
        if (_currectText.length == 1 && [_currectText isEqualToString:@"0"]) {
            if (![newString isEqualToString:@"."] && [newString intValue] > 0) {//'0'->other numbers
                textField.text
                = _currectText
                = newString;
                return;
            }
        }
    }
    _currectText = allText;

}

@end

static BOOL kIsMoney = NO;
static UITextFieldMoneyObserver *moneyObserver = nil;

@implementation UITextField (RegulateMoneyInput)

- (UITextFieldMoneyObserver *)moneyObserver {
    if (moneyObserver == nil) {
        moneyObserver = [[UITextFieldMoneyObserver alloc] init];
    }
    return moneyObserver;
}

- (void)addMoneyObserver {
    [self addTarget:[self moneyObserver]
             action:@selector(textChanged:)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)setIsMoney:(BOOL)isMoney {
    objc_setAssociatedObject(self, &kIsMoney, @(isMoney), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isMoney) {
        self.keyboardType = UIKeyboardTypeDecimalPad;//We should set key type as decimalPad first
        [self addMoneyObserver];
    }
}
- (BOOL)isMoney {
    return [objc_getAssociatedObject(self, &kIsMoney) boolValue];
}

@end

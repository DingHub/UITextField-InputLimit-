//
//  UITextField+RegulateMoneyInput.m
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "UITextField+RegulateMoneyInput.h"
#import <objc/runtime.h>

@implementation UITextField (RegulateMoneyInput)

static BOOL mIsMoney = NO;
- (BOOL)isMoney {
    return [objc_getAssociatedObject(self, &mIsMoney) boolValue];
}
- (void)setIsMoney:(BOOL)isMoney {
    objc_setAssociatedObject(self, &mIsMoney, @(isMoney), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isMoney) {
        self.keyboardType = UIKeyboardTypeDecimalPad;//We should set key type as decimalPad at first
        [self addMoneyObserver];
    }
}

- (void)addMoneyObserver {
    [self addTarget:self
             action:@selector(observeMoney)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)observeMoney {
    if (!self.isMoney) {
        return;
    }
    NSString *allText = self.text;
    NSString *newText= allText;
    if (self.correctText) {
        NSRange oldTextRange = [allText rangeOfString:self.correctText];
        newText = [allText substringFromIndex:oldTextRange.length];
    }
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]invertedSet];
    NSString *filtered = [[newText componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    if (filtered.length == 0) {
        if ([newText isEqualToString:@""]) {//inputed backSpace
            self.correctText = newText;
        }
        self.text = self.correctText;
        return;
    }
    if ([self.correctText rangeOfString:@"."].length) {
        if ([newText isEqualToString:@"."]) {//only one '.'
            self.text = self.correctText;
            return;
        }
        //2 charactors limited after '.'
        NSArray *array =  [self.correctText componentsSeparatedByString:@"."];
        if (array.count == 2) {
            if ([array[1] length] >= 2) {
                NSArray *newStringArray = [newText componentsSeparatedByString:@"."];
                if (newStringArray.count == 2 && [newStringArray[1] length] == 1) {//inputed backSpace
                    self.correctText= newText;
                }
                self.text = self.correctText;
                return;
            }
        }
        
    } else if (self.correctText.length == 1) {
        if ([newText isEqualToString:@"0"] && [self.correctText isEqualToString:@"0"]) {
            self.text = self.correctText;
            return;
        }
    }
    if (self.correctText.length == 0 && [newText isEqualToString:@"."]) {//"."->"0."
        self.text
        = self.correctText
        = @"0.";
        return;
    }
    if (self.correctText.length == 1 && [self.correctText isEqualToString:@"0"]) {
        if (![newText isEqualToString:@"."] && [newText intValue] > 0) {//'0'->other numbers
            self.text
            = self.correctText
            = newText;
            return;
        }
    }
    self.correctText = allText;
}

static NSString *kCurrectText;
- (void)setCorrectText:(NSString *)correctText {
    objc_setAssociatedObject(self, &kCurrectText, correctText, OBJC_ASSOCIATION_COPY);
}
- (NSString *)correctText {
    return objc_getAssociatedObject(self, &kCurrectText);
}
@end

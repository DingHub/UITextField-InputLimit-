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

static BOOL kIsMoney = NO;
- (void)setIsMoney:(BOOL)isMoney {
    objc_setAssociatedObject(self, &kIsMoney, @(isMoney), OBJC_ASSOCIATION_ASSIGN);
    if (isMoney) {
        self.keyboardType = UIKeyboardTypeDecimalPad;//We should set key type as decimalPad first
        [self addMoneyObserver];
    }
}
- (BOOL)isMoney {
    return [objc_getAssociatedObject(self, &kIsMoney) boolValue];
}

- (void)addMoneyObserver {
    [self addTarget:self
             action:@selector(observeMoney)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)observeMoney {
    
    NSString *allText = self.text;
    
    if (self.isMoney) {
        
        NSString *newString;
        if (self.correctText) {
            NSRange oldTextRange = [allText rangeOfString:self.correctText];
            newString = [allText substringFromIndex:oldTextRange.length];
        } else {
            newString = allText;
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]invertedSet];
        NSString *filtered = [[newString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (filtered.length == 0) {
            if ([newString isEqualToString:@""]) {//inputed backSpace
                self.correctText = newString;
            }
            self.text = self.correctText;
            return;
        }
        if ([self.correctText rangeOfString:@"."].length) {
            if ([newString isEqualToString:@"."]) {//only one '.'
                self.text = self.correctText;
                return;
            }
            //2 charactors limited after '.'
            NSArray *ary =  [self.correctText componentsSeparatedByString:@"."];
            if (ary.count == 2) {
                if ([ary[1] length] >= 2) {
                    NSArray *newStringArray = [newString componentsSeparatedByString:@"."];
                    if (newStringArray.count == 2 && [newStringArray[1] length] == 1) {//inputed backSpace
                        self.correctText= newString;
                    }
                    self.text = self.correctText;
                    return;
                }
            }
            
        } else if (self.correctText.length == 1) {
            if ([newString isEqualToString:@"0"] && [self.correctText isEqualToString:@"0"]) {
                self.text = self.correctText;
                return;
            }
        }
        if (self.correctText.length == 0 && [newString isEqualToString:@"."]) {//"."->"0."
            self.text
            = self.correctText
            = @"0.";
            return;
        }
        if (self.correctText.length == 1 && [self.correctText isEqualToString:@"0"]) {
            if (![newString isEqualToString:@"."] && [newString intValue] > 0) {//'0'->other numbers
                self.text
                = self.correctText
                = newString;
                return;
            }
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
//
//  UITextField+LimitLength.m
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "UITextField+LimitLength.h"
#import <objc/runtime.h>

@implementation UITextField (LimitLength)

static NSUInteger kMaxLength = 0;
- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &kMaxLength, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addLengthObserver];
}
- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, &kMaxLength) integerValue];
}

- (void)addLengthObserver {
    [self addTarget:self
             action:@selector(observeLength)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)observeLength {
    
    NSString *allText = self.text;

    if (self.maxLength > 0) {
        NSUInteger maxLength = self.maxLength;
        // deal with Chinese, Japanese,..., input
        // when input somothing like pinyin, we will not judge the length
        UITextRange *selectedRange = [self markedTextRange];
        if (!selectedRange || !selectedRange.start) {
            if (allText.length > maxLength) {
                self.text
                = self.correctText
                = [allText substringToIndex:maxLength];
                return;
            }
        }
    }
    self.correctText = allText;
}


static NSString *kCorrectText;
- (void)setCorrectText:(NSString *)correctText {
    objc_setAssociatedObject(self, &kCorrectText, correctText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)correctText {
    return objc_getAssociatedObject(self, &kCorrectText);
}

@end

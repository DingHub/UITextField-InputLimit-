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

static NSUInteger mMaxLength = 0;
- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &mMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addLengthObserver];
}
- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, &mMaxLength) integerValue];
}

- (void)addLengthObserver {
    [self addTarget:self
             action:@selector(observeLength)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)observeLength {
    
    if (self.maxLength > 0) {
        NSString *allText = self.text;
        // deal with Chinese, Japanese,..., input
        // when input somothing like pinyin, we will not judge the length
        UITextRange *selectedRange = [self markedTextRange];
        if (!selectedRange || !selectedRange.start) {
            NSUInteger maxLength = self.maxLength;
            if (allText.length > maxLength) {
                self.text = [self.text substringToIndex:maxLength];
            }
        }
    }
    
}

@end

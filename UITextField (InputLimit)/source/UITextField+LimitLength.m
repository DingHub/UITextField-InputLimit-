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

static NSInteger mMaxLength = 0;
- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, &mMaxLength) integerValue];
}
- (void)setMaxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, &mMaxLength, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addLengthObserver];
}

- (void)addLengthObserver {
    [self addTarget:self
             action:@selector(observeLength)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)observeLength {
    
    if (self.maxLength > 0) {
        // deal with Chinese, Japanese,..., input
        // when input somothing like pinyin, we will not judge the length
        UITextRange *selectedRange = [self markedTextRange];
        if (selectedRange && selectedRange.start) { return; }
        if (self.text.length > self.maxLength) {
            self.text = [self.text substringToIndex:self.maxLength];
        }
    }
    
}

@end

//
//  UITextField+LimitLength.m
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "UITextField+LimitLength.h"
#import <objc/runtime.h>


@interface UITextFieldTextLengthObserver : NSObject

@property (nonatomic, copy) NSString *currectText;

@end

@implementation UITextFieldTextLengthObserver

- (void)textChanged:(UITextField *)textField {
    
    NSString *allText = textField.text;
    
    if (textField.maxLength > 0) {
        NSUInteger maxLength = textField.maxLength;
        // deal with Chinese, Japanese,..., input
        // when input somothing like pinyin, we will not judge the length
        UITextRange *selectedRange = [textField markedTextRange];
        if (!selectedRange || !selectedRange.start) {
            if (allText.length > maxLength) {
                textField.text
                = _currectText
                = [allText substringToIndex:maxLength];
                return;
            }
        }
    }
    _currectText = allText;
}

@end


static NSUInteger kMaxLength = 0;
static UITextFieldTextLengthObserver *lengthObserver = nil;
@implementation UITextField (LimitLength)

- (UITextFieldTextLengthObserver *)lengthObserver {
    if (lengthObserver == nil) {
        lengthObserver = [[UITextFieldTextLengthObserver alloc] init];
    }
    return lengthObserver;
}

- (void)addLengthObserver {
    [self addTarget:[self lengthObserver]
             action:@selector(textChanged:)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &kMaxLength, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addLengthObserver];
}
- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, &kMaxLength) integerValue];
}

@end

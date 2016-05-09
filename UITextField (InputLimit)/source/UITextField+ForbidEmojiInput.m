//
//  UITextField+ForbidEmojiInput.m
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "UITextField+ForbidEmojiInput.h"
#import <objc/runtime.h>


@interface UITextFieldEmojiObserver : NSObject

@property (nonatomic, copy) NSString *currectText;

@end

@implementation UITextFieldEmojiObserver

- (void)textChanged:(UITextField *)textField {

    NSString *allText = textField.text;
    
    if (textField.noEmoji) {
        NSString *primaryLaguage = textField.textInputMode.primaryLanguage;
        if (primaryLaguage == nil || [primaryLaguage isEqualToString:@"emoji"]) {
            textField.text = _currectText;
            return;
        }
    }
    _currectText = allText;
}

@end


static BOOL kNoEmoji = NO;
static UITextFieldEmojiObserver *emojiObserver = nil;

@implementation UITextField (ForbidEmojiInput)

- (UITextFieldEmojiObserver *)emojiObserver {
    if (emojiObserver == nil) {
        emojiObserver = [[UITextFieldEmojiObserver alloc] init];
    }
    return emojiObserver;
}

- (void)addEmojiObserver {
    [self addTarget:[self emojiObserver]
             action:@selector(textChanged:)
   forControlEvents:UIControlEventEditingChanged];
}
- (void)setNoEmoji:(BOOL)noEmoji {
    objc_setAssociatedObject(self, &kNoEmoji, @(noEmoji), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (noEmoji) {
        [self addEmojiObserver];
    }
}
- (BOOL)noEmoji {
    return [objc_getAssociatedObject(self, &kNoEmoji) boolValue];
}

@end

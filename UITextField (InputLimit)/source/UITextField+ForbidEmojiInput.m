//
//  UITextField+ForbidEmojiInput.m
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "UITextField+ForbidEmojiInput.h"
#import <objc/runtime.h>

@implementation UITextField (ForbidEmojiInput)

static BOOL kNoEmoji = NO;
- (void)setNoEmoji:(BOOL)noEmoji {
    objc_setAssociatedObject(self, &kNoEmoji, @(noEmoji), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (noEmoji) {
        [self addEmojiObserver];
    }
}
- (BOOL)noEmoji {
    return [objc_getAssociatedObject(self, &kNoEmoji) boolValue];
}

- (void)addEmojiObserver {
    [self addTarget:self
             action:@selector(observeEmoji)
   forControlEvents:UIControlEventEditingChanged];
}
- (void)observeEmoji {
    NSString *allText = self.text;
    
    if (self.noEmoji) {
        NSString *primaryLaguage = self.textInputMode.primaryLanguage;
        if (primaryLaguage == nil || [primaryLaguage isEqualToString:@"emoji"]) {
            self.text = self.correctText;
            return;
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

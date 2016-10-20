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

static BOOL mNoEmoji = NO;
- (BOOL)noEmoji {
    return [objc_getAssociatedObject(self, &mNoEmoji) boolValue];
}
- (void)setNoEmoji:(BOOL)noEmoji {
    objc_setAssociatedObject(self, &mNoEmoji, @(noEmoji), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (noEmoji) {
        [self addEmojiObserver];
    }
}

- (void)addEmojiObserver {
    [self addTarget:self
             action:@selector(observeEmoji)
   forControlEvents:UIControlEventEditingChanged];
}

- (void)observeEmoji {
    if (!self.noEmoji) {
        return;
    }
    
    NSString *primaryLaguage = self.textInputMode.primaryLanguage;
    if (primaryLaguage == nil || [primaryLaguage isEqualToString:@"emoji"]) {
        self.text = self.oldText;
        return;
    }
    self.oldText = self.text;
}

static NSString *kOldText;
- (NSString *)oldText {
    return objc_getAssociatedObject(self, &kOldText);
}
- (void)setOldText:(NSString *)oldText {
    objc_setAssociatedObject(self, &kOldText, oldText, OBJC_ASSOCIATION_COPY);
}

@end

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
- (void)setNoEmoji:(BOOL)noEmoji {
    objc_setAssociatedObject(self, &mNoEmoji, @(noEmoji), OBJC_ASSOCIATION_ASSIGN);
    if (noEmoji) {
        [self addEmojiObserver];
    }
}
- (BOOL)noEmoji {
    return [objc_getAssociatedObject(self, &mNoEmoji) boolValue];
}

- (void)addEmojiObserver {
    [self addTarget:self
             action:@selector(observeEmoji)
   forControlEvents:UIControlEventEditingChanged];
}
- (void)observeEmoji {
    if (self.noEmoji) {
        NSString *allText = self.text;
        static NSString *oldString = nil;
        NSString *primaryLaguage = self.textInputMode.primaryLanguage;
        if (primaryLaguage == nil || [primaryLaguage isEqualToString:@"emoji"]) {
            self.text = oldString;
            return;
        }
        oldString = allText;
    }
}

static NSString *kCorrectText;
- (void)setCorrectText:(NSString *)correctText {
    objc_setAssociatedObject(self, &kCorrectText, correctText, OBJC_ASSOCIATION_COPY);
}
- (NSString *)correctText {
    return objc_getAssociatedObject(self, &kCorrectText);
}
@end

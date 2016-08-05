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
static NSString *oldText = nil;

- (BOOL)noEmoji {
    return [objc_getAssociatedObject(self, &mNoEmoji) boolValue];
}

- (void)setNoEmoji:(BOOL)noEmoji {
    objc_setAssociatedObject(self, &mNoEmoji, @(noEmoji), OBJC_ASSOCIATION_ASSIGN);
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
        self.text = oldText;
        return;
    }
    oldText = self.text;
}

@end

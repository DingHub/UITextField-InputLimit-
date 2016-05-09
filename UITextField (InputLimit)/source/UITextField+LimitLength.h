//
//  UITextField+LimitLength.h
//  UITextField (InputLimit)
//
//  Created by admin on 16/5/8.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)

@property (assign, nonatomic) IBInspectable NSUInteger maxLength;//0 <=> no limit

@end

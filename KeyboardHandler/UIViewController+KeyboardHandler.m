//
//  UIViewController+KeyboardHandler.m
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-7.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import "UIViewController+KeyboardHandler.h"

@implementation UIViewController (KeyboardHandler)



#pragma mark 关闭键盘
- (void)resignAllResponders{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma helper

// 返回textField和textView中最底部的Y值
- (CGFloat)getMaxFieldVerticalHeight
{
    CGFloat maxVerticalHeight = 0;
    
    // UITextField
    for ( UITextField *textField in self.uiTextFieldArray) {
        CGFloat textFieldVerticalHeight = textField.frame.origin.y + textField.frame.size.height;
        maxVerticalHeight = maxVerticalHeight > textFieldVerticalHeight ? maxVerticalHeight : textFieldVerticalHeight;
    }
    
    // UITextView
    for (UITextView *textView in self.uiTextViewArray) {
        CGFloat textFieldVerticalHeight = textView.frame.origin.y + textView.frame.size.height;
        maxVerticalHeight = maxVerticalHeight > textFieldVerticalHeight ? maxVerticalHeight : textFieldVerticalHeight;
    }
    
    NSLog(@"maxVerticalHeight:%f",maxVerticalHeight);
    
    return maxVerticalHeight;
}

@end

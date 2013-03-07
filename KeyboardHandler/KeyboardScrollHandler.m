//
//  KeyboardScrollHandler.m
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-7.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import "KeyboardScrollHandler.h"

@implementation KeyboardScrollHandler


- (void)configKeyboardHandler:(UIScrollView*)wrapper textFields:(NSArray*)textFields textViews:(NSArray*)textViews
{
    self.wrapperScrollView = wrapper;
    self.uiTextFieldArray = [NSMutableArray arrayWithArray:textFields];
    self.uiTextViewArray = [NSMutableArray arrayWithArray:textViews];
    
    // 添加键盘隐藏事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    [self.wrapperScrollView addGestureRecognizer:tap];
}


#pragma mark 关闭键盘
- (void)resignAllResponders{
    [self.wrapperScrollView endEditing:YES];
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

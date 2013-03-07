//
//  KeyboardScrollHandler.m
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-7.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import "KeyboardScrollHandler.h"

@implementation KeyboardScrollHandler

// 初始化配置的方法
- (void)configKeyboardHandler:(UIScrollView*)wrapper textFields:(NSArray*)textFields textViews:(NSArray*)textViews
{
    self.wrapperScrollView = wrapper;
    self.uiTextFieldArray = [NSMutableArray arrayWithArray:textFields];
    self.uiTextViewArray = [NSMutableArray arrayWithArray:textViews];
    
    wrapperInitialHeight = wrapper.frame.size.height;
        
    // 添加键盘隐藏事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    [self.wrapperScrollView addGestureRecognizer:tap];
    
    // 为文本框添加代理
    for (UITextField *textField in textFields) {
        [textField setDelegate:self];
    }
    for (UITextView *textView in textViews) {
        [textView setDelegate:self];
    }
    // 注册键盘观测者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -
#pragma mark 键盘出来时处理
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    animationDurationTime = animationDuration;
    
    lastKeyboardHeight = keyboardHeihgt;
    keyboardHeihgt = keyboardRect.size.height;
    
    NSLog(@"keyboardH : %f",keyboardHeihgt);
    
    [self handlekeyboardHeightChange];
}


#pragma mark 当键盘突然高度变化时（输入法切换）的处理
- (void)handlekeyboardHeightChange
{
    CGRect frame = self.wrapperScrollView.frame;
    
    float keyboardHeightChange = keyboardHeihgt - lastKeyboardHeight;
    if (keyboardHeightChange==0) {
        // 没变化，直接返回
        return;
    }
    frame.size.height = frame.size.height - keyboardHeightChange;
    self.wrapperScrollView.frame = frame;
}



#pragma mark 键盘隐藏时的处理
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:&(animationDurationTime) forTextField:currentTextField];
}

#warning 还需完善
#pragma mark view进行位移的处理
- (void)moveInputBarWithKeyboardHeight:(float)inKeyboardHeight withDuration:(NSTimeInterval*)animationDuration forTextField:(UIControl *)textField{
    
    CGFloat visibleViewHeight = wrapperInitialHeight - inKeyboardHeight;
    CGRect viewFrame = self.wrapperScrollView.frame;
    
    
    
    if (inKeyboardHeight==0.0f) {
        
        viewFrame.size.height = wrapperInitialHeight;//如果传入键盘高度为0，即恢复无键盘状态，修正移动高度
    }else{
        viewFrame.size.height = visibleViewHeight;
    }
    
    [UIView animateWithDuration:*(animationDuration) //速度0.7秒
                     animations:^{//修改坐标
                         self.wrapperScrollView.frame = viewFrame;
                         if (inKeyboardHeight==0.0f) {
                             self.wrapperScrollView.contentOffset = CGPointZero;
                         }else{
                             self.wrapperScrollView.contentOffset = CGPointMake(0, textField.frame.origin.y);
                         }
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

#pragma mark textField和textView完成编辑的事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    [self moveInputBarWithKeyboardHeight:keyboardHeihgt withDuration:&(animationDurationTime) forTextField:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    currentTextField = (UIControl*)textView;
    [self moveInputBarWithKeyboardHeight:keyboardHeihgt withDuration:&(animationDurationTime) forTextField:(UIControl*)textView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

- (void)dealloc
{
    // 注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end

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
    
    //设定键盘初始化高度，和动画时间
    keyboardHeihgt = 216.0f;
    lastKeyboardHeight = 216.0f;
    animationDurationTime = 0.25f;
    
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
    

    if (keyboardHeihgt - lastKeyboardHeight != 0) {
        [self moveInputBarWithKeyboardHeight:keyboardHeihgt withDuration:&(animationDurationTime) forTextField:currentTextField];
    }
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

#pragma mark view进行位移的处理
- (void)moveInputBarWithKeyboardHeight:(float)inKeyboardHeight withDuration:(NSTimeInterval*)animationDuration forTextField:(UIControl *)textField{
    
    CGFloat visibleViewHeight = wrapperInitialHeight - inKeyboardHeight;
    CGRect viewFrame = self.wrapperScrollView.frame;
    
    if (inKeyboardHeight==0.0f) {
        viewFrame.size.height = wrapperInitialHeight;//如果传入键盘高度为0，即恢复无键盘状态，修正移动高度
    }else{
        viewFrame.size.height = visibleViewHeight;
    }
    
    [UIView animateWithDuration:*(animationDuration) //速度为键盘显引的速度
                 animations:^{//修改坐标
                     self.wrapperScrollView.frame = viewFrame;
                 } completion:^(BOOL finished) {
                     // 动画结束
                     CGPoint offsetPoint;
                     if (inKeyboardHeight==0.0f) {
                         offsetPoint = CGPointZero;
                     }else{
                         // 点击了编辑框，需要位移
                         CGFloat yPos = textField.frame.origin.y - (visibleViewHeight/2 - textField.frame.size.height/2);
                         yPos = yPos<0 ? 0 : yPos;
                         offsetPoint = CGPointMake(0, yPos);
                         
                         if (yPos>self.wrapperScrollView.contentSize.height-visibleViewHeight + textField.frame.size.height/2) {
                             offsetPoint = CGPointMake(0, self.wrapperScrollView.contentSize.height - self.wrapperScrollView.bounds.size.height);
                         }
                     }
                     [self.wrapperScrollView setContentOffset:offsetPoint animated:YES];
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

    return maxVerticalHeight;
}


- (void)dealloc
{
    // 注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    self.wrapperScrollView = nil;
    self.uiTextViewArray = nil;
    self.uiTextFieldArray = nil;
}

@end

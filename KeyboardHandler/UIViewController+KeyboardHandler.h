//
//  UIViewController+KeyboardHandler.h
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-7.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KeyboardHandler) <UITextFieldDelegate,UITextViewDelegate>
{
    float keyboardHeihgt; //键盘高度
    float lastKeyboardHeight; //键盘上一次的高度
    NSTimeInterval animationDurationTime; //动画的时间
    UIControl *currentTextField; //当前的编辑框，UITextField和UITextView都是继承自UIControl
}


@property (nonatomic, strong) NSMutableArray    *uiTextFieldArray;
@property (nonatomic, strong) NSMutableArray    *uiTextViewArray;

- (void)resignAllResponders;
- (CGFloat)getMaxFieldVerticalHeight;

@end

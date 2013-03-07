//
//  FormKeyboardViewController.m
//  laobanquan
//
//  Created by 刘 剑华 on 13-1-23.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import "FormKeyboardViewController.h"

@interface FormKeyboardViewController ()

@end

@implementation FormKeyboardViewController{
    float keyboardHeihgt; //键盘高度
    float lastKeyboardHeight; //键盘上一次的高度
    NSTimeInterval animationDurationTime; //动画的时间
    UIControl *currentTextField; //当前的编辑框，UITextField和UITextView都是继承自UIControl
}

@synthesize uiTextViewArray;
@synthesize uiTextFieldArray;
@synthesize resignResponseViewArray;
@synthesize formScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    uiTextViewArray = [NSMutableArray array];
    uiTextFieldArray = [NSMutableArray array];
    
    //设定键盘初始化高度，和动画时间
    keyboardHeihgt = 216.0f;
    lastKeyboardHeight = 216.0f;
    animationDurationTime = 0.25f;
    
    //为添加进来的控制view添加键盘隐藏事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    for (UIView *controlView in resignResponseViewArray) {
        [controlView addGestureRecognizer:tap];
    }
    
    
}

#pragma mark 键盘出现的通知
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
    if (animationDurationTime == 0.0f) {
        animationDurationTime = animationDuration;
    }
    lastKeyboardHeight = keyboardHeihgt;
    keyboardHeihgt = keyboardRect.size.height;
    
    NSLog(@"keyboardH : %f",keyboardHeihgt);
    
    [self handlekeyboardHeightChange];
    
    //NSLog(@"%f",keyboardRect.size.height);
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
//    NSLog(@"keyboardWillShow");
//    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:&(animationDuration) forTextField:currentTextField];
}

#pragma mark 当键盘高度变化时的处理
- (void)handlekeyboardHeightChange
{
    CGRect frame = self.view.frame;
    
    float keyboardHeightChange = keyboardHeihgt - lastKeyboardHeight;
    if (keyboardHeightChange==0) {
        // 没变化，直接返回
        return;
    }
    frame.origin.y = frame.origin.y - keyboardHeightChange;
    self.view.frame = frame;
}

#pragma mark 取消键盘事件观察
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 为文本框添加代理
    for (UITextField *textField in uiTextFieldArray) {
        [textField setDelegate:self];
    }
    for (UITextField *textView in uiTextViewArray) {
        [textView setDelegate:self];
    }
    // 注册键盘观测者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

    CGFloat visibleViewHeight = self.view.frame.size.height - inKeyboardHeight;
    CGRect viewFrame = self.view.frame;
    
        
    
    if (inKeyboardHeight==0.0f) {
        
        viewFrame.size.height = 416;//如果传入键盘高度为0，即恢复无键盘状态，修正移动高度
    }else{
        viewFrame.size.height = visibleViewHeight;
    }
    
    
    
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:*(animationDuration)];
    self.view.frame = viewFrame;
    [UIView commitAnimations];
    
    
    return;
    if (textField==nil) {
        return;
    }
    
    NSLog(@"super y : %f", textField.superview.frame.origin.y);
    
    float textFieldBottom = textField.superview.frame.origin.y+textField.frame.origin.y+textField.frame.size.height+self.view.frame.origin.y;
    float viewHeight = self.view.frame.size.height;
    
    
    
    // 配置上移参数
    float textFieldHeight = textField.frame.size.height;
    CGRect frame = self.view.frame;
//    NSLog(@"frame||x:%f||y:%f||width:%f||height:%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    float moveY = (2*textFieldBottom - viewHeight + inKeyboardHeight - textFieldHeight)/2;

    frame.origin.y -= moveY;
    if (frame.origin.y>0) {
        frame.origin.y = 0;//如果是计算得到的移动后的frame大于0（即向下移动，则使处于原点)
    }
    if (inKeyboardHeight==0.0f) {
        frame.origin.y = 0;//如果传入键盘高度为0，即恢复无键盘状态，修正移动高度
    }
//    NSLog(@"last-y:%f",frame.origin.y);
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:*(animationDuration)];
    self.view.frame = frame;
    [UIView commitAnimations];
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
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma helper

// 返回textField和textView中最底部的Y值
- (CGFloat)getMaxFieldVerticalHeight
{
    CGFloat maxVerticalHeight = 0;
    
    // UITextField
    for ( UITextField *textField in uiTextFieldArray) {
        CGFloat textFieldVerticalHeight = textField.frame.origin.y + textField.frame.size.height;
        maxVerticalHeight = maxVerticalHeight > textFieldVerticalHeight ? maxVerticalHeight : textFieldVerticalHeight;
    }
    
    // UITextView
    for (UITextView *textView in uiTextViewArray) {
        CGFloat textFieldVerticalHeight = textView.frame.origin.y + textView.frame.size.height;
        maxVerticalHeight = maxVerticalHeight > textFieldVerticalHeight ? maxVerticalHeight : textFieldVerticalHeight;
    }
    
    NSLog(@"maxVerticalHeight:%f",maxVerticalHeight);
    
    return maxVerticalHeight;
}

@end

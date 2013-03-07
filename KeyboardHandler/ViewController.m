//
//  ViewController.m
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-7.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.resignResponseViewArray = [NSMutableArray arrayWithArray:@[self.view]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.uiTextFieldArray = [NSMutableArray arrayWithArray:@[self.textField1]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.myScrollView.contentSize = CGSizeMake(self.myScrollView.contentSize.width, 416);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [UIView animateWithDuration:*(animationDuration) //速度0.7秒
                     animations:^{//修改坐标
                         self.view.frame = viewFrame;
                         if (inKeyboardHeight==0.0f) {
                             self.myScrollView.contentOffset = CGPointZero;
                         }else{
                             self.myScrollView.contentOffset = CGPointMake(0, textField.frame.origin.y);
                         }
                     } completion:^(BOOL finished) {
                         
                     }];
    
//    [UIView beginAnimations:@"ResizeView" context:nil];
//    [UIView setAnimationDuration:*(animationDuration)];
//    self.view.frame = viewFrame;
//    [UIView commitAnimations];
    
    
}

- (void)viewDidUnload {
    [self setTextField1:nil];
    [self setMyScrollView:nil];
    [super viewDidUnload];
}
@end

//
//  FormKeyboardViewController.h
//  laobanquan
//
//  Created by 刘 剑华 on 13-1-23.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormKeyboardViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray    *uiTextFieldArray;
@property (nonatomic, strong) NSMutableArray    *uiTextViewArray;
@property (nonatomic, strong) NSMutableArray    *resignResponseViewArray;
@property (nonatomic, strong) UIScrollView      *formScrollView;

- (void)resignAllResponders;
- (CGFloat)getMaxFieldVerticalHeight;

@end

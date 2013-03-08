//
//  TestKeyboardViewController.h
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-8.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardScrollHandler.h"

@interface TestKeyboardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textTop;
@property (weak, nonatomic) IBOutlet UITextField *textMiddle;
@property (weak, nonatomic) IBOutlet UITextField *textBottom;

@property (weak, nonatomic) IBOutlet UITextView *textView1;

@end

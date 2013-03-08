//
//  TestKeyboardViewController.m
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-8.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import "TestKeyboardViewController.h"

@interface TestKeyboardViewController ()
{
    KeyboardScrollHandler *keyboardHandler;
}

@end

@implementation TestKeyboardViewController

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
	// Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:99];
    scrollView.contentSize = self.view.frame.size;
    keyboardHandler = [[KeyboardScrollHandler alloc] init];
    [keyboardHandler configKeyboardHandler:scrollView textFields:@[self.textTop,self.textMiddle,self.textBottom] textViews:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextTop:nil];
    [self setTextMiddle:nil];
    [self setTextBottom:nil];
    [super viewDidUnload];
}
@end

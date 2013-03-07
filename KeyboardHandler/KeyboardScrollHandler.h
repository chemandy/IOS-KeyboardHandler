//
//  KeyboardScrollHandler.h
//  KeyboardHandler
//
//  Created by 刘 剑华 on 13-3-7.
//  Copyright (c) 2013年 figo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardScrollHandler : NSObject

@property (nonatomic, strong) UIScrollView      *wrapperScrollView;
@property (nonatomic, strong) NSMutableArray    *uiTextFieldArray;
@property (nonatomic, strong) NSMutableArray    *uiTextViewArray;

@end

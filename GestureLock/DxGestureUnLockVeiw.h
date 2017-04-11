//
//  DxGestureUnLockVeiw.h
//  GestureLock
//
//  Created by D.xin on 2017/4/7.
//  Copyright © 2017年 D.xin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@class DxGestureUnLockVeiw;
@protocol DxGestureUnlockViewDelegate <NSObject>

@required
-(void)gestureUnlockView:(DxGestureUnLockVeiw *)unLockView  drawReactFinished:(NSMutableString *)getGesturePassWord;


@end

@interface DxGestureUnLockVeiw : UIView

@property(nonatomic,weak) id<DxGestureUnlockViewDelegate>delegate;

@end

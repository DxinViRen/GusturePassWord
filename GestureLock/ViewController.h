//
//  ViewController.h
//  GestureLock
//
//  Created by D.xin on 2017/4/7.
//  Copyright © 2017年 D.xin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DxUnlockType){
    DxUnlockTypeCreatePassWord,
    DxUnlockTypeValidePassWord
};


@interface ViewController : UIViewController

+(void)deleteGesturePassWord;//删除手势密码
+(NSString *)gesturePassword;//获取手势密码

@end


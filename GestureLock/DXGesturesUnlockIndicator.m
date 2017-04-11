
//
//  DXGesturesUnlockIndicator.m
//  GestureLock
//
//  Created by D.xin on 2017/4/7.
//  Copyright © 2017年 D.xin. All rights reserved.
//

#import "DXGesturesUnlockIndicator.h"

@interface DXGesturesUnlockIndicator ()
@property(nonatomic,strong)NSMutableArray * buttons;


@end

@implementation DXGesturesUnlockIndicator

-(instancetype)initWithFrame:(CGRect)frame{

    if(self =[super initWithFrame:frame]){
        [self setUp];
    }
    
    return self;
}

-(void)setUp{
    //创建9个按钮
    for (int i = 0; i<9; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_indicator_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_indicator_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
        [self.buttons addObject:btn];
    }
}

/*一调用initWithFrame就会主动调用这个方法*/
-(void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    
    //列数
    int cols = 3;
    
    CGFloat x= 0,y=0,w=9,h=9;
    //间距
    CGFloat margin =(self.bounds.size.width - cols* count)/(cols+1);
    CGFloat col = 0,row = 0;
    for (int i = 0; i<count; i++) {
        col = i%cols;   //列
        row = i/cols;   //行
        x = margin + (margin + w)*col;
        y = margin + (margin + y)*row;
        UIButton * btn = self.buttons[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}


#pragma mark - publicMethods
-(void)setGesturePassWord:(NSString *)gesturePassword{
    if(gesturePassword.length == 0){
            //没有创建过或者已经删除手势密码  所有的按钮都要设置为未选中的状态
        for (UIButton *btn in self.buttons) {
            btn.selected = NO;
        }
        return;
    }
    //循环遍历取出来存入的手势密码然后设置对应的btn为选中状态显示出来设置的密码
    for (int i = 0; i<gesturePassword.length; i++) {
        NSString * gesPwd= [gesturePassword substringWithRange:NSMakeRange(i, 1)];
        //设置选中的状态，用来显示用户设置的密码
        [self.buttons[[gesPwd integerValue]] setSelected:YES];
    }
}




#pragma mark - getter
-(NSMutableArray*)buttons{
    if(!_buttons){
        _buttons = @[].mutableCopy;
    }
    return _buttons;
}

@end

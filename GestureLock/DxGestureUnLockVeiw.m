
//
//  DxGestureUnLockVeiw.m
//  GestureLock
//
//  Created by D.xin on 2017/4/7.
//  Copyright © 2017年 D.xin. All rights reserved.
//

#import "DxGestureUnLockVeiw.h"
#import "DXGesturesUnlockIndicator.h"
/*由于不在xib中*/
@interface DxGestureUnLockVeiw ()
@property(nonatomic,retain)NSMutableArray * seletedBtns;
@property(nonatomic,assign)CGPoint currentPoint;
@property(nonatomic,retain)NSMutableArray * btnArray;

@end

@implementation DxGestureUnLockVeiw
{
    BOOL  isFirst;
}
#pragma mark - super methods
-(instancetype)init{
    if(self =[super init]){
    
        [self _setupViews];
        self.backgroundColor = [UIColor whiteColor];
        [self setNeedsUpdateConstraints];
        //isFirst = YES;
    }
    
    return self;
}





-(void)updateConstraints{
    [super updateConstraints];
    //自动布局
    NSMutableArray * subArr = @[].mutableCopy;
    NSArray * colArr =@[self.btnArray[0],self.btnArray[3],self.btnArray[6]];
    for (int i = 0; i<3; i++) {
        NSMutableArray * viewArr = @[].mutableCopy;
        for ( int j = 0; j<3;j++) {
            [viewArr addObject:self.btnArray[i*3+j]];
        }
        [subArr addObject:viewArr];
    }
    
    /*大小相同*/
    [self.btnArray autoMatchViewsDimension:ALDimensionWidth];
    [self.btnArray autoMatchViewsDimension:ALDimensionHeight];
    
    
    [subArr[0] autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:30.0f insetSpacing:YES matchedSizes:YES];
    [subArr[1] autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:30.0f insetSpacing:YES matchedSizes:YES];
    [subArr[2] autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:30.0f insetSpacing:YES matchedSizes:YES];
    [colArr autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeVertical withFixedSpacing:30.0f insetSpacing:YES matchedSizes:YES];
}


//每次调用这个方法都会重绘界面
-(void)drawRect:(CGRect)rect{
    
   // [super drawRect:rect];
    if (self.seletedBtns.count == 0) return;
    // 把所有选中按钮中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger count = self.seletedBtns.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.seletedBtns[i];
        if (i == 0) {
            //设置起点
            [path moveToPoint:btn.center];
        }else {
            [path addLineToPoint:btn.center];
        }
    }
    
    [path addLineToPoint:_currentPoint ];
    [UIColorFromRGB(0xffc8ad) set];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 8;
    [path stroke];

}





#pragma mark - self method
-(void)_setupViews{
    
    UIPanGestureRecognizer * gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:gesture];
    
    //创建九个btn
    for (int i = 0; i<9; i++) {
         UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
         btn.userInteractionEnabled = NO;
         [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
       // btn.backgroundColor =[UIColor redColor];
        btn.tag = 1000+i;
         [btn setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
         [self addSubview:btn];
         //把btn存入数组
        [self.btnArray addObject:btn];
    }
}




-(void)panAction:(UIPanGestureRecognizer *)pan{
    //这是当前手势拖动的点
    _currentPoint = [pan locationInView:self];
    [self setNeedsDisplay];
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected ==   NO) {
            button.selected = YES;
            //数组，用来存放已经选中的按钮
            [self.seletedBtns addObject:button];
        }
    }
    [self layoutIfNeeded];
    //拖动结束
    if (pan.state == UIGestureRecognizerStateEnded) {
        //保存输入密码
        NSMutableString *gesturePwd = @"".mutableCopy;
        for (UIButton *button in self.seletedBtns) {
            [gesturePwd appendFormat:@"%ld",button.tag-1000];
            button.selected = NO;
        }
        [self.seletedBtns removeAllObjects];
        //手势密码绘制完成后会调用
        if ([self.delegate respondsToSelector:@selector(gestureUnlockView:drawReactFinished:)]) {
            
            [self.delegate gestureUnlockView:self drawReactFinished:gesturePwd];
        }
    }
}


#pragma mark - getter
-(NSMutableArray *)seletedBtns{
    if(!_seletedBtns){
    
        _seletedBtns= [[NSMutableArray alloc]init];
    }
    return _seletedBtns;
}



-(NSMutableArray *)btnArray{
    if(!_btnArray){
    
        _btnArray = [[NSMutableArray alloc]init];
    }
    return _btnArray;
}

@end

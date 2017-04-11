//
//  ViewController.m
//  GestureLock
//
//  Created by D.xin on 2017/4/7.
//  Copyright © 2017年 D.xin. All rights reserved.
//

#import "ViewController.h"
#import "DxGestureUnLockVeiw.h"

#define  gesturePassWord @"gesturePassword"
@interface ViewController ()<DxGestureUnlockViewDelegate>
@property(nonatomic,retain)DxGestureUnLockVeiw * lockView;
@property(nonatomic,retain)DxGestureUnLockVeiw * gestureUnLockView;
@property(nonatomic,retain)UILabel * stateLabel;
@property(nonatomic,retain)UIButton * resetBtn;
@property(nonatomic,assign)DxUnlockType unlocktype;
@property(nonatomic,copy)NSMutableString * lastPasd;//要创建的手势密码

@end

@implementation ViewController


#pragma mark - Class method
+(void)deleteGesturePassWord{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:gesturePassWord];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



+(void)addGesturePassWord:(NSString *)gesturePsd{
    [[NSUserDefaults standardUserDefaults]setObject:gesturePsd forKey:gesturePassWord];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+(NSString *)gesturePassword{
   return   [[NSUserDefaults standardUserDefaults]objectForKey:gesturePassWord];
 
}






#pragma mark - life cycle
-(instancetype)initWithUnlockType:(DxUnlockType)unlockType{
    if(self = [super init]){
    
        _unlocktype = unlockType;
    }
    return self;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setNeedsUpdateConstraints];
    
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareView];
  
    self.resetBtn.hidden = NO;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - privately method
-(void)_prepareView{
    [self.view addSubview:self.lockView];
    [self.view addSubview:self.resetBtn];
    [self.view addSubview:self.stateLabel];
}


/*创建手势密码*/
-(void)createGesturePassword:(NSMutableString *)gesturePsd{
     //以前没有手势密码，创建手势密码
    if(self.lastPasd.length == 0){
          //至少需要连接四个点才能创建手势密码
        if(gesturePsd.length<4){
            self.stateLabel.text = @"至少需要连接4个点才能创建密码";
            //stateLabel 的晃动
            return;
        }
        
        self.lastPasd = gesturePsd;
        self.stateLabel.text = @"请再一次绘制手势密码";
        return;
    }
    
    //有旧的手势密码，创建的新的手势密码
    if(self.lastPasd.length>0){
        if([self.lastPasd isEqualToString:gesturePsd]){
            //绘制成功
            
            //保存手势密码
            [ViewController addGesturePassWord:gesturePsd];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"绘制密码成功" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alerC addAction:action];
            
        }else{
            self.stateLabel.text = @"与上次绘制的不一样，请重新绘制";
        }
    }
}


#pragma makr - super methods
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.lockView autoPinEdgeToSuperviewEdge:ALEdgeTop    withInset:200.0f];
    [self.lockView autoPinEdgeToSuperviewEdge:ALEdgeLeft   withInset:10.0f];
    [self.lockView autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:10.0f];
    [self.lockView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100.0f ];
    
    
    //stateLabel
    [self.stateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30.0f];
    [self.stateLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.stateLabel sizeToFit];
    [self.stateLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    
    //ResetButton
    [self.resetBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.resetBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [self.resetBtn autoSetDimensionsToSize:CGSizeMake(80.0f, 40.0f)];
    
    
    

}


#pragma mark - DxGestureDelegate
-(void)gestureUnlockView:(DxGestureUnLockVeiw *)unLockView drawReactFinished:(NSMutableString *)getGesturePassWord{
     //拖动手势结束的时候要执行的代理方法
    switch (_unlocktype) {
        case DxUnlockTypeCreatePassWord:
            [self createGesturePassword:getGesturePassWord];
            break;
        case DxUnlockTypeValidePassWord:
            [self createGesturePassword:getGesturePassWord];
            break;
            
        default:
            break;
    }
    
}



#pragma mark - getter
-(DxGestureUnLockVeiw *)lockView{
    if(!_lockView){
    
       _lockView = [[DxGestureUnLockVeiw alloc]init];
        self.lockView.delegate = self;
    }
    return _lockView;
}


//密码重置按钮
-(UIButton *)resetBtn{
    if(!_resetBtn){
        _resetBtn = [[UIButton alloc]init];
        [_resetBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _resetBtn;
}

-(UILabel *)stateLabel{
    if(!_stateLabel){
    
        _stateLabel =[[UILabel alloc]init];
        _stateLabel.layer.cornerRadius = 2;
        _stateLabel.text = @"请绘制手势密码";
        _stateLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        _stateLabel.layer.borderWidth = 0.8;
        
    }
    return _stateLabel;
}
@end

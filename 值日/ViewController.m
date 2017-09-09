//
//  ViewController.m
//  值日
//
//  Created by 刘志武 on 2017/8/19.
//  Copyright © 2017年 zhiwuLiu. All rights reserved.
//

#import "ViewController.h"
#import "JKAlertDialog.h"
#import "LQStartShineView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
{
    SystemSoundID syssoundID1;
    SystemSoundID syssoundID2;
    
    NSURL * urlpath1;
    NSURL * urlpath2;
}

@property(nonatomic,strong) NSMutableArray *dataSourceArray;
@property(nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic, strong) UILabel *selectedNameLabel;
@property (nonatomic, strong) UILabel *scrollNameLabel;
@property (nonatomic, strong) NSString *tempName;
@property (nonatomic, assign) int index;
@property (strong) CAEmitterLayer *dazLayer;
@property (strong) CAEmitterLayer *dazLayer2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _partName;
    //返回按钮
    [self settingReturnButtonAndImageName:@"order_title_return"];
        UIImageView *imageVVV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageVVV.image = [UIImage imageNamed:@"23213"];
        [self.view addSubview:imageVVV];
    
    LQStartShineView * view = [[LQStartShineView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    self.dazLayer = [CAEmitterLayer layer];
    
    // Cells spawn in a 50pt circle around the position
    self.dazLayer.emitterPosition = CGPointMake(60, self.view.frame.size.height);//发射源位置
    self.dazLayer.emitterSize	= CGSizeMake(8, 0);//发射源尺寸大小
    self.dazLayer.emitterMode	= kCAEmitterLayerVolume;//发射源模式
    self.dazLayer.emitterShape	= kCAEmitterLayerLine;//发射源的形状
    self.dazLayer.renderMode    = kCAEmitterLayerAdditive;//渲染模式
    self.dazLayer.velocity      = 1;//发射方向
    self.dazLayer.seed = (arc4random()%100)+1;//用于初始化随机数产生的种子
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 0.5;//粒子产生系数，默认1.0
    rocket.emissionRange	= 0;  // some variation in angle//周围发射角度
    rocket.velocity			= 500;//速度
    rocket.velocityRange	= 10;//速度范围
    rocket.yAcceleration	= 75;//粒子y方向的加速度分量
    rocket.lifetime			= 1.03;	// we cannot set the birthrate < 1.0 for the burst//生命周期
    
    rocket.contents			= (id) [[UIImage imageNamed:@"FFRing"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    rocket.scale			= 0.2;//缩放比例
    rocket.color			= [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];//[[UIColor redColor] CGColor];//粒子的颜色
    rocket.greenRange		= 1.0;		// different colors//一个粒子的颜色green 能改变的范围
    rocket.redRange			= 1.0;      //一个粒子的颜色red 能改变的范围
    rocket.blueRange		= 1.0;      //一个粒子的颜色blue 能改变的范围
    rocket.spinRange		= M_PI;		// slow spin//子旋转角度范围
    rocket.emissionLongitude=0;
    rocket.emissionLatitude=100;
    
    
    // 爆炸 the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel//粒子产生系数，默认为1.0
    burst.velocity			= 0;        //速度
    burst.scale				= 2.5;      //缩放比例
    burst.redSpeed			=-1.5;		// shifting粒子red在生命周期内的改变速度
    burst.blueSpeed			=+1.5;		// shifting粒子blue在生命周期内的改变速度
    burst.greenSpeed		=+1.0;		// shifting粒子green在生命周期内的改变速度
    burst.lifetime			= 0.35;     //生命周期
    
    // 火花 and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 400;      //粒子产生系数，默认为1.0
    spark.velocity			= 125;      //速度
    spark.emissionRange		= 2* M_PI;	// 360 deg//周围发射角度
    spark.yAcceleration		= 75;		// gravity//y方向上的加速度分量
    spark.lifetime			= 3;        //粒子生命周期
    
    spark.contents			= (id) [[UIImage imageNamed:@"FFTspark"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    spark.scaleSpeed		=-0.2;  //缩放比例速度
    spark.greenSpeed		=-0.1;  //粒子green在生命周期内的改变速度
    spark.redSpeed			= 0.4;  //粒子red在生命周期内的改变速度
    spark.blueSpeed			=-0.1;  //粒子blue在生命周期内的改变速度
    spark.alphaSpeed		=-0.25; //粒子透明度在生命周期内的改变速度
    spark.spin				= 2* M_PI;  //子旋转角度
    spark.spinRange			= 2* M_PI;  //子旋转角度范围
    
    
    
    // First traigles are emitted, which then spawn circles and star along their path
    self.dazLayer.emitterCells = [NSArray arrayWithObject:rocket];
    rocket.emitterCells = [NSArray arrayWithObjects:burst, nil];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:self.dazLayer];
    
    self.dazLayer2=[CAEmitterLayer layer];
    // Create the emitter layer
    
    // Cells spawn in a 50pt circle around the position
    self.dazLayer2.emitterPosition = CGPointMake(self.view.frame.size.width-60, self.view.frame.size.height);//发射源位置
    self.dazLayer2.emitterSize	= CGSizeMake(8, 0);//发射源尺寸大小
    self.dazLayer2.emitterMode	= kCAEmitterLayerVolume;//发射源模式
    self.dazLayer2.emitterShape	= kCAEmitterLayerLine;//发射源的形状
    self.dazLayer2.renderMode    = kCAEmitterLayerAdditive;//渲染模式
    self.dazLayer2.velocity      = 1;//发射方向
    self.dazLayer2.seed = (arc4random()%100)+1;//用于初始化随机数产生的种子
    
    // Create the rocket
    CAEmitterCell* rocket2 = [CAEmitterCell emitterCell];
    
    rocket2.birthRate		= 0.5;//粒子产生系数，默认1.0
    rocket2.emissionRange	= 0;  // some variation in angle//周围发射角度
    rocket2.velocity			= 500;//速度
    rocket2.velocityRange	= 10;//速度范围
    rocket2.yAcceleration	= 75;//粒子y方向的加速度分量
    rocket2.lifetime			= 1.03;	// we cannot set the birthrate < 1.0 for the burst//生命周期
    
    rocket2.contents			= (id) [[UIImage imageNamed:@"FFRing"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    rocket2.scale			= 0.2;//缩放比例
    rocket2.color			= [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];//[[UIColor redColor] CGColor];//粒子的颜色
    rocket2.greenRange		= 1.0;		// different colors//一个粒子的颜色green 能改变的范围
    rocket2.redRange			= 1.0;      //一个粒子的颜色red 能改变的范围
    rocket2.blueRange		= 1.0;      //一个粒子的颜色blue 能改变的范围
    rocket2.spinRange		= M_PI;		// slow spin//子旋转角度范围
    rocket2.emissionLongitude=0;
    rocket2.emissionLatitude=100;
    
    
    // 爆炸 the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst2 = [CAEmitterCell emitterCell];
    
    burst2.birthRate			= 1.0;		// at the end of travel//粒子产生系数，默认为1.0
    burst2.velocity			= 0;        //速度
    burst2.scale				= 2.5;      //缩放比例
    burst2.redSpeed			=-1.5;		// shifting粒子red在生命周期内的改变速度
    burst2.blueSpeed			=+1.5;		// shifting粒子blue在生命周期内的改变速度
    burst2.greenSpeed		=+1.0;		// shifting粒子green在生命周期内的改变速度
    burst2.lifetime			= 0.35;     //生命周期
    
    // 火花 and finally, the sparks
    CAEmitterCell* spark2 = [CAEmitterCell emitterCell];
    
    spark2.birthRate			= 400;      //粒子产生系数，默认为1.0
    spark2.velocity			= 125;      //速度
    spark2.emissionRange		= 2* M_PI;	// 360 deg//周围发射角度
    spark2.yAcceleration		= 75;		// gravity//y方向上的加速度分量
    spark2.lifetime			= 3;        //粒子生命周期
    
    spark2.contents			= (id) [[UIImage imageNamed:@"FFTspark"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    spark2.scaleSpeed		=-0.2;  //缩放比例速度
    spark2.greenSpeed		=-0.1;  //粒子green在生命周期内的改变速度
    spark2.redSpeed			= 0.4;  //粒子red在生命周期内的改变速度
    spark2.blueSpeed			=-0.1;  //粒子blue在生命周期内的改变速度
    spark2.alphaSpeed		=-0.25; //粒子透明度在生命周期内的改变速度
    spark2.spin				= 2* M_PI;  //子旋转角度
    spark2.spinRange			= 2* M_PI;  //子旋转角度范围
    
    
    
    // First traigles are emitted, which then spawn circles and star along their path
    self.dazLayer2.emitterCells = [NSArray arrayWithObject:rocket2];
    rocket2.emitterCells = [NSArray arrayWithObjects:burst2, nil];
    burst2.emitterCells = [NSArray arrayWithObject:spark2];
    [self.view.layer addSublayer:self.dazLayer2];

    [self creatUIView];
//    
    
}
- (void)creatUIView
{
    self.dataSourceArray = [NSMutableArray arrayWithObjects:
                            @"擦窗台和沙发加办公桌",
                            @"扫地",
                            @"我是VIP👍",
                            @"拖地",
                            @"刷门垫子",
                            @"擦窗台和沙发加办公桌",
                            @"扫地",
                            @"拖地",
                            @"刷门垫子",
                            @"扫地",
                            @"下周我给大家买糖吃🙂",
                            @"拖地",
                            @"拖地",
                            nil];
    
    self.scrollNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 100, 240, 200, 30)];
    _scrollNameLabel.backgroundColor = [UIColor clearColor];
    _scrollNameLabel.text = @"开始喽!";
    _scrollNameLabel.font = [UIFont systemFontOfSize:15.0];
    _scrollNameLabel.textAlignment = NSTextAlignmentCenter;
    _scrollNameLabel.layer.borderColor = [UIColor yellowColor].CGColor;
    _scrollNameLabel.layer.borderWidth = 0.5;
    _scrollNameLabel.layer.cornerRadius = 5.0;
    _scrollNameLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:_scrollNameLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(_scrollNameLabel.center.x - 50, CGRectGetMaxY(_scrollNameLabel.frame) + 66, 100, 30);
    btn.layer.borderColor = [UIColor purpleColor].CGColor;
    btn.layer.borderWidth = 0.5;
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitle:@"Start" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(buttonDIdClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

//响应按钮的点击事件
- (void)buttonDIdClicked:(UIButton *)sender {
    
    NSLog(@"数组个数为:%ld", [_dataSourceArray count]);
    
    
    //切换按钮的标题
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        //设置标题为stop
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        //启动定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeName) userInfo:nil repeats:YES];
    }else{
        
        if ([_dataSourceArray count] == 0) {
            return;
        }
        else
        {
            [sender setTitle:@"Start" forState:UIControlStateNormal];
            //关掉定时器
            
            [self.timer invalidate];
            //获取当前选中的人
            _scrollNameLabel.text = _tempName;

            if ([_tempName isEqualToString:@"我是VIP👍"]
                ||
                [_tempName isEqualToString:@"下周我给大家买糖吃🙂"])
            {
                urlpath1=[[NSBundle mainBundle] URLForResource:@"zjl" withExtension:@"wav"];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(urlpath1), &syssoundID1);
                AudioServicesPlaySystemSound(syssoundID1);
                [sender setTitle:@"Stop" forState:UIControlStateNormal];
                JKAlertDialog *jkView = [[JKAlertDialog alloc]initWithTitle:@"恭喜您, 中奖了:" message:_tempName];
                [jkView addButton:Button_OK withTitle:@"好尴尬呀!!!" handler:^(JKAlertDialogItem *item) {
                    _scrollNameLabel.text = @"开始喽!";
                    //删除数组中的元素
                    [_dataSourceArray removeObjectAtIndex:_index];
                    //启动定时器
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeName) userInfo:nil repeats:YES];
                    NSLog(@"数组个数为:%ld", [_dataSourceArray count]);

                }];
                [jkView show];
            }
            else
            {
                urlpath1=[[NSBundle mainBundle] URLForResource:@"zjl0" withExtension:@"wav"];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(urlpath1), &syssoundID1);
                AudioServicesPlaySystemSound(syssoundID1);
                JKAlertDialog *jkAlertV = [[JKAlertDialog alloc]initWithTitle:@"值日工作:" message:_tempName];
                [jkAlertV addButton:Button_OK withTitle:@"OK!我知道了!!!" handler:^(JKAlertDialogItem *item) {
                //删除数组中的元素
                [_dataSourceArray removeObjectAtIndex:_index];
                    _scrollNameLabel.text = @"开始喽!";
                    NSLog(@"数组个数为:%ld", [_dataSourceArray count]);

                }];
                [jkAlertV show];
            }
        }
    }
}
//定时器触发之后将来执行这个方法
- (void)changeName{
    
    //产生一个随机数
    if ([_dataSourceArray count] == 0) {
        NSLog(@"数组是空的了");
        [_timer invalidate];
        return;
    }
    else
    {
        int index = arc4random() % _dataSourceArray.count;
        //从数组里面去获取index对应的人的名字
        _tempName = [_dataSourceArray objectAtIndex:index];
        //将当前这个人的名字显示到滚动的label上
        self.scrollNameLabel.text = _tempName;
        _index = index;
    }
    
}

#pragma mark -- 全局封装返回按钮
-(void)settingReturnButtonAndImageName:(NSString *)returnImageName
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:returnImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:returnImageName] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *letBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = letBtn;
    
    [btn addTarget:self action:@selector(returnButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -- 返回按钮触发事件
- (void)returnButtonAction:(UIButton *)button
{
    //定义一个动画变换类型, 类方法获取动画对象
    CATransition *amin = [CATransition animation];
    //设置动画的时间长度
    amin.duration = 1;
    //设置动画的类型,决定动画的效果形式
    amin.type = @"rippleEffect";
    //设置动画的子类型,例如动画的方向.
    amin.subtype = kCATransitionFromRight;
    //设置动画的轨迹模式.
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //将动画设置对象添加到动画上
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

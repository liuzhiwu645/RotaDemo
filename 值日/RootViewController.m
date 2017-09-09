//
//  RootViewController.m
//  值日
//
//  Created by 刘志武 on 2017/9/8.
//  Copyright © 2017年 zhiwuLiu. All rights reserved.
//

#import "RootViewController.h"
#import <FBShimmeringView.h>
#import "ViewController.h"
#import <Toast/UIView+Toast.h>
#import "JXPopoverView.h"

@interface RootViewController ()

@property (nonatomic, strong) UIImageView *imaView;
@property (nonatomic, strong) FBShimmeringView *fbView;
@property (nonatomic, strong) UITextField *labTitle;
@property (nonatomic, strong) FBShimmeringView *FBLabel;

@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                      }];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"网药软件";
    [self creatUI];
    
}
#pragma mark -- 创建UI
- (void)creatUI
{
    
    UIImageView *imageViewBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 667)];
    imageViewBottom.backgroundColor = [UIColor clearColor];
    imageViewBottom.image = [UIImage imageNamed:@"first"];
    [self.view addSubview:imageViewBottom];
    
    self.fbView = [[FBShimmeringView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 110, 100, 100)];
    
    self.imaView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75, 30, 150, 150)];
    self.imaView.layer.masksToBounds = YES;
    self.imaView.backgroundColor = [UIColor clearColor];
    self.imaView.layer.cornerRadius = 50;
    self.imaView.image = [UIImage imageNamed:@"666"];
    [self.view addSubview:_imaView];
    
    self.FBLabel = [[FBShimmeringView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75, CGRectGetMaxY(_imaView.frame) + 40, 150, 25)];
    self.FBLabel.shimmering = YES;
    self.FBLabel.shimmeringOpacity = 0.5;
    self.FBLabel.shimmeringBeginFadeDuration = 1;
    self.FBLabel.shimmeringSpeed = 200;
    self.FBLabel.shimmeringAnimationOpacity = 1.0;
    [self.view addSubview:_FBLabel];
    
//    self.labTitle = [[UITextField alloc]initWithFrame:self.FBLabel.bounds];
//    self.labTitle.placeholder = @"输入部门名称";
//    [self.labTitle setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    self.labTitle.textColor = [UIColor whiteColor];
//    self.labTitle.textAlignment = NSTextAlignmentCenter;
//    self.labTitle.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.labTitle.layer.borderWidth = 2;
//    self.labTitle.layer.masksToBounds = YES;
//    self.labTitle.font = [UIFont systemFontOfSize:13.0];
//    self.labTitle.layer.cornerRadius = 12.5;
//    self.labTitle.font = [UIFont systemFontOfSize:17 weight:1];
    UIButton *seletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seletedBtn setTitle:@"请选择您所在的部门" forState:UIControlStateNormal];
    [seletedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    seletedBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    seletedBtn.layer.borderWidth = 1.5;
    seletedBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    seletedBtn.backgroundColor = [UIColor clearColor];
    seletedBtn.layer.masksToBounds = YES;
    seletedBtn.tag = 20170909;
    seletedBtn.layer.cornerRadius = 12.5;
    _FBLabel.contentView = seletedBtn;
    
    [seletedBtn addTarget:self action:@selector(userSeletedDepartment:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonClick setTitle:@"进入" forState:UIControlStateNormal];
    buttonClick.frame = CGRectMake(self.view.frame.size.width / 2 - 50, CGRectGetMaxY(_FBLabel.frame) + 100, 100, 25);
    [buttonClick setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonClick.layer.masksToBounds = YES;
    buttonClick.layer.cornerRadius = 12.5;
    buttonClick.backgroundColor = [UIColor clearColor];
    buttonClick.layer.borderColor = [UIColor whiteColor].CGColor;
    buttonClick.layer.borderWidth = 1.0;
    buttonClick.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:buttonClick];
    
    [buttonClick addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -- 选择所在部门
- (void)userSeletedDepartment:(UIButton *)button
{
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    JXPopoverAction *actionJava = [JXPopoverAction actionWithTitle:@"Java技术部" handler:^(JXPopoverAction *action) {
        [button setTitle:@"Java技术部" forState:UIControlStateNormal];
    }];
    JXPopoverAction *actionShop = [JXPopoverAction actionWithTitle:@"网药商城" handler:^(JXPopoverAction *action) {
        [button setTitle:@"网药商城" forState:UIControlStateNormal];

    }];
    
    [popoverView showToView:button withActions:@[actionJava,actionShop]];
}

#pragma mark --- 按钮点击事件
- (void)buttonClickAction:(UIButton *)button
{
    UIButton *buttonSeleted = [self.view viewWithTag:20170909];
    
    if ([[buttonSeleted currentTitle] isEqualToString:@"请选择您所在的部门"]) {
        [self.view makeToast:@"请选择你所在的部门" duration:1.0 position:CSToastPositionCenter];
    }
    else
    {
        [self pushNextVcTitle:[buttonSeleted currentTitle]];
    }
    

}
- (void)pushNextVcTitle:(NSString *)title
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
    ViewController *viewVc = [[ViewController alloc]init];
    //当前的Vcpush到下一个Vc
    viewVc.partName = title;
    [self.navigationController pushViewController:viewVc animated:YES];
}

#pragma mark -- (颜色转换一张图片)
-(UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

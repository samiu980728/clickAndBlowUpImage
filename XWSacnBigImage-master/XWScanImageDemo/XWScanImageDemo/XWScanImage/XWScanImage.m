//
//  XWScanImage.m
//  XWScanImageDemo
//
//  Created by 邱学伟 on 16/4/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWScanImage.h"

@implementation XWScanImage

//原始尺寸
static CGRect oldframe;


//UIWindow *window = [UIApplication sharedApplication].keyWindow;
////背景
//UIView *backgroundView = [[UIView alloc] init];
//
//[self.view addSubview:backgroundView];
//[window addSubview:backgroundView];

/**
 浏览大图 - 如果图片不是在imageView上可用此方法.
 
 @param image 查看的图片对象
 @param pOldframe 当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值 [currentImageview convertRect:currentImageview.bounds toView:window];
 */
+(void)scanBigImageWithImage:(UIImage *)image frame:(CGRect)pOldframe {
    oldframe = pOldframe;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [backgroundView setBackgroundColor:[UIColor yellowColor]];
    
    //[backgroundView setBackgroundColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:99/255.0 alpha:0.6]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:1024];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
#pragma mark Question: 为什么不在self.view上添加这个view 而在UIWindow上添加？ 因为在这个类中无法得到self.view
    [window addSubview:backgroundView];
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
#pragma mark take care: 此时并没有使用该方法：hideImageView:  只有当在backgroundView上点击该收拾时，才会触发该方法
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  浏览大图
 *
 *  @param currentImageview 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self scanBigImageWithImage:currentImageview.image frame:[currentImageview convertRect:currentImageview.bounds toView:window]];
    //convertRect:<#(CGRect)#> toView:<#(nullable UIView *)#>
    //算出currentImageview 相对于窗口的位置
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    //查找tag值为1024的imageView
    UIImageView *imageView = [tap.view viewWithTag:1024];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

@end

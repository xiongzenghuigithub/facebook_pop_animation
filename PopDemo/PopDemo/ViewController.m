/** POPAnimatableProperty.mm: 定义了所有动画样式 */

#import "ViewController.h"
#import "PopUpAndDecayMoveController.h"
#import "FlyInViewController.h"

#import <pop/POP.h>

@interface ViewController () {
    
    UIView * springView;
    UIView * popView;
    UILabel * label;
    UIButton * PopUpAndDecayMoveBtn;
    UIButton * FlyInBtn;
    
    CGRect popView_hide_frame;
    CGRect popView_show_frame;
    BOOL isOpened;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initSpringview];
    [self initBarnutton];
    [self initOther];
    [self PopUpAndDecayMove];
    [self FlyIn];
    
}

- (void)initSpringview {
    
    springView = [[UIView alloc] init];
    springView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    springView.bounds = CGRectMake(0, 0, 100, 100);
    springView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:springView];
    
    //PopSpringAnimation: view的放大、缩小
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(changeSize:)];
    [springView addGestureRecognizer:tap];
    
    //PopSpringAnimation: view的point移动
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] init];
    [tap1 addTarget:self action:@selector(move:)];
    [springView addGestureRecognizer:tap1];
}

- (void)initBarnutton{
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(popBox)];
    self.navigationItem.rightBarButtonItem = right;
    
    popView_hide_frame = CGRectMake(self.view.bounds.size.width, 64, 0, 0);
    popView_show_frame = CGRectMake(100, 64, 150, 150);
    
    popView = [[UIView alloc] init];
    popView.backgroundColor = [UIColor blueColor];
    popView.frame = popView_hide_frame;
    [self.view addSubview:popView];
    
    isOpened = NO;
}

#pragma makr - 改变大小动画
- (void)changeSize:(UITapGestureRecognizer *)tap {
    
    //用POPSpringAnimation 让viewBlue实现弹性放大缩小的效果
    POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    
    CGRect rect = springView.frame;
    if (rect.size.width==100) {
        animation.toValue = [NSValue valueWithCGSize:CGSizeMake(300, 300)];//改变kPOPLayerSize
        
    }
    else{
        animation.toValue = [NSValue valueWithCGSize:CGSizeMake(100, 100)];//改变kPOPLayerSize
        
    }
    
    //弹性值
    animation.springBounciness = 20.0;
    
    //弹性速度
    animation.springSpeed = 20.0;
    
    [springView.layer pop_addAnimation:animation forKey:@"changeSize"];
}

#pragma mark - 移动位置动画
- (void)move:(UITapGestureRecognizer *)tap {
    
    POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    CGPoint point = springView.center;
    if (point.y == self.view.bounds.size.height/2) {
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 120)];//移动kPOPLayerPosition
    }else {
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];//移动kPOPLayerPosition
    }
    animation.springBounciness = 20.0;
    animation.springSpeed = 20.0;
    
    //动画回调代码块
    [animation setCompletionBlock:^(POPAnimation * animation, BOOL isFnished) {
        if (isFnished) {
            NSLog(@"animation is finished!");
        }
    }];
    [springView pop_addAnimation:animation forKey:@"move"];
}

#pragma mark - 弹出框的动画
- (void)popBox {
    
    if (isOpened == NO) {
        
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        positionAnimation.fromValue = [NSValue valueWithCGRect:popView_hide_frame];
        positionAnimation.toValue = [NSValue valueWithCGRect:popView_show_frame];
        positionAnimation.springBounciness = 15.0f;
        positionAnimation.springSpeed = 20.0f;
        [popView pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
        
        isOpened = YES;
        
    }else {
        
        POPSpringAnimation * positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        positionAnimation.fromValue = [NSValue valueWithCGRect:popView_show_frame];
        positionAnimation.toValue = [NSValue valueWithCGRect:popView_hide_frame];
        positionAnimation.springBounciness = 15.0f;
        positionAnimation.springSpeed = 20.0f;
        [popView pop_addAnimation:positionAnimation forKey:@"frameAnimation"];
        
        isOpened = NO;
    }
}

- (void)initOther {

    label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.frame  = CGRectMake(20, 64, 200, 40);
    label.text = @"ease-in-out";
    [self.view addSubview:label];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(labelEaseInOut)];
    [label addGestureRecognizer:tap];
}

#pragma mark - 从1到100的计数动画
- (void)labelEaseInOut {
    
    POPBasicAnimation * basicAnima = [POPBasicAnimation animation];
    basicAnima.duration = 10.0;
    basicAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPAnimatableProperty * property = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        
        //1. block中的参数obj: 被添加动画的对象
        
        //2. 先把 动画的值 写入到 UILabel.text
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            //把values[0]值，写入label.text
            [obj setText:[NSString stringWithFormat:@"%.2f", values[0]]];
        };
        
        //3. 从 UILabel的值 读入到 动画保存
        prop.readBlock = ^(id obj, CGFloat values[]) {
            //把label的值读入values[0]
            values[0] = [[obj description] floatValue];
        };
        
        prop.threshold = 0.01;
    }];
    
    basicAnima.property = property;
    basicAnima.fromValue = @(0.0);
    basicAnima.toValue = @(100.0);
    
    [label pop_addAnimation:basicAnima forKey:@"EaseInOut"];
}

- (void)PopUpAndDecayMove {
    
    //推冰壶的效果
    PopUpAndDecayMoveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PopUpAndDecayMoveBtn.frame = CGRectMake(20, 400, 100, 40);
    [PopUpAndDecayMoveBtn addTarget:self action:@selector(PopUpAndDecayMoveAction) forControlEvents:UIControlEventTouchUpInside];
    [PopUpAndDecayMoveBtn setTitle:@"推冰壶的效果" forState:UIControlStateNormal];
    [PopUpAndDecayMoveBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:PopUpAndDecayMoveBtn];
}

- (void)PopUpAndDecayMoveAction {
    PopUpAndDecayMoveController * vc = [[PopUpAndDecayMoveController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)FlyIn {
    
    FlyInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    FlyInBtn.frame = CGRectMake(10 + CGRectGetMaxX(PopUpAndDecayMoveBtn.frame), 400, 100, 40);
    [FlyInBtn addTarget:self action:@selector(FlyInBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [FlyInBtn setTitle:@"Fly In 效果" forState:UIControlStateNormal];
    [FlyInBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:FlyInBtn];

}

- (void)FlyInBtnAction {
    
    FlyInViewController * vc = [[FlyInViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

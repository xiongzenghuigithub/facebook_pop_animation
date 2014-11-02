/** POPAnimatableProperty.mm: 定义了所有动画样式 */

#import "ViewController.h"
#import <pop/POP.h>

@interface ViewController () {
    
    UIView * springView;
    UIView * popView;
    
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

- (void)changeSize:(UITapGestureRecognizer *)tap {
    
    //用POPSpringAnimation 让viewBlue实现弹性放大缩小的效果
    POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    
    CGRect rect = springView.frame;
    if (rect.size.width==100) {
        animation.toValue = [NSValue valueWithCGSize:CGSizeMake(300, 300)];
        
    }
    else{
        animation.toValue = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
        
    }
    
    //弹性值
    animation.springBounciness = 20.0;
    
    //弹性速度
    animation.springSpeed = 20.0;
    
    [springView.layer pop_addAnimation:animation forKey:@"changeSize"];
}

- (void)move:(UITapGestureRecognizer *)tap {
    
    POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    CGPoint point = springView.center;
    if (point.y == self.view.bounds.size.height/2) {
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 120)];
    }else {
        animation.toValue = [NSValue valueWithCGSize:CGSizeMake(point.x, 240)];
    }
    animation.springBounciness = 20.0;
    animation.springSpeed = 20.0;
    [springView pop_addAnimation:animation forKey:@"move"];
}

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


@end

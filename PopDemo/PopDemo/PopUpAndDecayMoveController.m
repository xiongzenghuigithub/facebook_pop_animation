
#import "PopUpAndDecayMoveController.h"
#import <POP.h>

@interface PopUpAndDecayMoveController () <UIGestureRecognizerDelegate>{
    
    UIView * circle;
    UIPanGestureRecognizer * pan;//拖动手势
}

@end

@implementation PopUpAndDecayMoveController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCircle];
}

- (void)initCircle{
    circle = [[UIView alloc] init];
    circle.frame = CGRectMake(20, 74, 50, 50);
    circle.backgroundColor = [UIColor redColor];
    [self.view addSubview:circle];
    
    pan = [[UIPanGestureRecognizer alloc] init];
    [pan setDelegate:self];
    [pan addTarget:self action:@selector(handleGesture:)];
    
    [circle addGestureRecognizer:pan];
}

#pragma mark - Gesture Action
- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    
    //获取手势执行的状态
    UIGestureRecognizerState state = [gesture state];
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            [circle.layer removeAllAnimations];
            CGPoint translation = [gesture  translationInView:self.view];
            CGPoint center = circle.center;
            center.x += translation.x;
            center.y += translation.y;
            circle.center = center;
            [gesture setTranslation:CGPointZero inView:circle];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint velocity = [pan velocityInView:self.view];
            [self addDecayPositionAninamtionWithVelocity:velocity];
            break;
        }
    }
}

- (void)addDecayPositionAninamtionWithVelocity:(CGPoint)velocity {
    POPDecayAnimation * anima = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
    anima.velocity = [NSValue valueWithCGPoint:CGPointMake(velocity.x, velocity.y)];
    [circle pop_addAnimation:anima forKey:@"Decay"];
}

#pragma UIGestureRecognizerDelegate

- (void)dealloc {
    circle = nil;
    [circle removeGestureRecognizer:pan];
    pan = nil;
}

@end

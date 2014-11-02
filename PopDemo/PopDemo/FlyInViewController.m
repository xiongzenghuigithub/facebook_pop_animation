
#import "FlyInViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <POP.h>

@interface FlyInViewController () {
    UIView * circle;
    POPSpringAnimation * anima;
    
    CAShapeLayer * progressLayer;
    UIBezierPath * progressLine;
}

@end

@implementation FlyInViewController

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
    
    [self initCirecle];
    [self initAnination];
    [self initProgress];
}

- (void)initCirecle {
    circle = [[UIView alloc] init];
    circle.frame = CGRectMake(200, 74, 60, 60);
    circle.backgroundColor = [UIColor redColor];
    [self.view addSubview:circle];
}

- (void)initAnination {
    
    //Spring Animation实现了卡片下落的效果
    anima = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anima.fromValue = @(-200);
    anima.toValue = @(self.view.center.y);
    
    //Basic Animation实现了卡片的渐入效果
    POPBasicAnimation * opacityAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnima.toValue = @(1.0);
    
    //Basic Animation则实现了卡片倾斜的效果
    POPBasicAnimation * rotationAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnima.beginTime = CACurrentMediaTime() + 0.1;
    rotationAnima.toValue = @(0);
    
    [circle.layer pop_addAnimation:anima forKey:@"FallDown"];
    [circle.layer pop_addAnimation:opacityAnima forKey:@"opacity"];
    [circle.layer pop_addAnimation:rotationAnima forKey:@"rotation"];
}

- (void)initProgress {
    
    //1. 使用CAShapeLayer与UIBezierPath画出想要的图形
    progressLayer = [CAShapeLayer layer];
    progressLayer.strokeColor = [[UIColor colorWithWhite:1.0 alpha:0.98] CGColor];
    progressLayer.lineWidth  = 26.0;
    
    progressLine = [UIBezierPath bezierPath];
    [progressLine moveToPoint:CGPointMake(25, 25)];
    [progressLine addLineToPoint:CGPointMake(300, 25)];
    progressLayer.path = progressLine.CGPath;
    
    //将Layer添加到view.layer
    [self.view.layer addSublayer:progressLayer];
    
    //2. 动画
    POPSpringAnimation * boundsAnima = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    boundsAnima.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 800, 50)];
    [boundsAnima setCompletionBlock:^(POPAnimation * anim , BOOL isFinished) {
        
        UIGraphicsBeginImageContextWithOptions(circle.frame.size, NO, 0.0);
        POPBasicAnimation * progressBoundsAnima = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        progressBoundsAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        progressBoundsAnima.toValue = @1.0;
        
        __weak POPBasicAnimation * weakProgressBoundsAnima = progressBoundsAnima;
        [progressBoundsAnima setCompletionBlock:^(POPAnimation * anima, BOOL isFinished) {
            if (isFinished) {
                UIGraphicsPopContext();
            }
            [progressLayer pop_addAnimation:weakProgressBoundsAnima forKey:@"AnimateBounds"];
        }];
        
    }];
    
    [progressLayer pop_addAnimation:boundsAnima forKey:@"boundsAnima"];
}


@end

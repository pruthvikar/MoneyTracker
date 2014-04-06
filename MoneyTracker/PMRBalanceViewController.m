//
//  PMRBalanceViewController.m
//  MoneyTracker
//
//  Created by Pruthvikar Reddy on 06/04/2014.
//  Copyright (c) 2014 Pruthvikar Reddy. All rights reserved.
//

#import "PMRBalanceViewController.h"
#import "PMRNavigationController.h"
#import "PMRAppDelegate.h"
@interface PMRBalanceViewController ()
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property ( nonatomic) CGPoint center;
@property (strong,nonatomic) NSTimer* timer;
@property (strong,nonatomic) NSLocale *priceLocale;
@property (strong,nonatomic) NSNumberFormatter *currencyFormatter;
@property (strong,nonatomic) CAGradientLayer* gradient;
@property (nonatomic) NSInteger actualBalance;
@end

@implementation PMRBalanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getBalance];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.balanceLabel.textColor=[UIColor whiteColor];

    
    
    
    
    
//    self.tabBarController.tabBar.alpha=.1;
    self.tabBarController.tabBar.translucent=YES;
    _priceLocale = [NSLocale currentLocale];
    _currencyFormatter=[[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setLocale:_priceLocale];



    

    
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pgr];
    
    // Do any additional setup after loading the view.
}

-(void)getBalance{
    
    NSManagedObjectContext *moc = [(PMRAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Transaction" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...

    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"time" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];

    NSInteger theSum = [[array valueForKeyPath:@"@sum.amount"] integerValue];

            [self animateBalance:theSum];
    
}

-(void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    if (pgr.state == UIGestureRecognizerStateBegan) {
        [self addView];
        _center = self.tabBarController.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        CGPoint center = CGPointMake(_center.x,
                             _center.y + translation.y);
        self.tabBarController.view.center = center;
        [pgr setTranslation:CGPointZero inView:pgr.view];
    }
    else if (pgr.state == UIGestureRecognizerStateChanged) {
        CGPoint center = self.tabBarController.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        center = CGPointMake(center.x,
                             center.y + translation.y);
        self.tabBarController.view.center = center;
        [pgr setTranslation:CGPointZero inView:pgr.view];
        if (center.y-_center.y>150) {
            [self performSegueWithIdentifier:@"TransactionView" sender:@"Income"];
        }
        else if (center.y-_center.y<-150) {
            [self performSegueWithIdentifier:@"TransactionView" sender:@"Expense"];
        }
    }
    else if (pgr.state == UIGestureRecognizerStateEnded || pgr.state==UIGestureRecognizerStateCancelled
             || pgr.state==UIGestureRecognizerStateFailed)
    {
        CGPoint center=self.tabBarController.view.center;
        if (center.y-_center.y>75) {
            [self performSegueWithIdentifier:@"TransactionView" sender:@"Income"];
        }
        else if (center.y-_center.y<-75) {
            [self performSegueWithIdentifier:@"TransactionView" sender:@"Expense"];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            
        
        
        self.tabBarController.view.center = _center;
        }];
        [pgr setTranslation:CGPointZero inView:pgr.view];
    
    }
    
    if (pgr.state == UIGestureRecognizerStateEnded)
    {
    
    
    }
    
}

-(CGFloat)getScreenWidth
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) return [UIScreen mainScreen].bounds.size.height;
    return [UIScreen mainScreen].bounds.size.width;
}

-(CGFloat)getScreenHeight
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) return [UIScreen mainScreen].bounds.size.width;
    return [UIScreen mainScreen].bounds.size.height;
}


-(void)addView
{
    UILabel* add=[[UILabel alloc]initWithFrame:CGRectMake(0, -100.0, [self getScreenWidth], 100.0)];
    add.text=@"Earned Money";
    add.textAlignment=NSTextAlignmentCenter;
    add.textColor=[UIColor whiteColor];
    [self.view.superview.superview.superview addSubview:add];
    
    UILabel* remove=[[UILabel alloc]initWithFrame:CGRectMake(0, [self getScreenHeight], [self getScreenWidth], 100.0)];
    remove.text=@"Spent Money";
    remove.textAlignment=NSTextAlignmentCenter;
    remove.textColor=[UIColor whiteColor];
    [self.view.superview.superview.superview addSubview:remove];

}

-(void)animateBalance:(NSInteger)balance
{

    if (_timer) {

        [self setBalance:[self.timer.userInfo[@"target"] integerValue]];
        [_timer invalidate];
    }
    _timer = [NSTimer timerWithTimeInterval:.01
                                             target:self
                                           selector:@selector(changeLabelText)
                                           userInfo:@{@"target":[NSNumber numberWithInteger:balance]}
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    


}

- (void)changeLabelText {

    NSInteger target=[self.timer.userInfo[@"target"] integerValue];

    self.actualBalance+=(target-self.actualBalance)/7;
    NSInteger absVal=target - self.actualBalance;
    if (absVal<0) {
        absVal*=-1;
    }
    if (absVal<=100) {
        self.actualBalance=target;
        [self.timer invalidate];
        self.timer=nil;
    }
    NSString *currencyString = [_currencyFormatter currencySymbol]; // EUR, GBP, USD...
    NSString *format = [_currencyFormatter positiveFormat];
    format = [format stringByReplacingOccurrencesOfString:@"¤" withString:currencyString];

    [_currencyFormatter setPositiveFormat:format];

    [self setBGColour:self.actualBalance];
    if (self.actualBalance>=0) {
        
        
        self.balanceLabel.text=[_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.actualBalance/100.0 ]];
    }
    else
    {
        self.balanceLabel.text=[@"-" stringByAppendingString:[_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:-1*self.actualBalance/100.0 ]] ];
        
    }
    

}
-(void)setBGColour:(NSInteger)balance
{
    double num=MAX(MIN(balance/100, 255),0);
    if (!_gradient) {
        
    
    _gradient = [CAGradientLayer layer];
        _gradient.frame = self.view.bounds;
        [self.view.layer insertSublayer:_gradient atIndex:0];
    }
    
    _gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:(255-num)/255.0 green:num blue:0.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:(255-num)/255.0 green:num blue:0.0 alpha:0.7].CGColor, nil];
    
    self.tabBarController.tabBar.barTintColor=[UIColor colorWithRed:(255-num)/255.0 green:num blue:0.0 alpha:0.7];



}
-(void)setBalance:(NSInteger)balance
{
    
    [self setBGColour:balance];
    
    
    
    self.actualBalance=balance;
    
    NSString *currencyString = [_currencyFormatter currencySymbol]; // EUR, GBP, USD...
    NSString *format = [_currencyFormatter positiveFormat];
    
    format = [format stringByReplacingOccurrencesOfString:@"¤" withString:currencyString];
    
    [_currencyFormatter setPositiveFormat:format];
    if (self.actualBalance>=0) {
        
    
    self.balanceLabel.text=[_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.actualBalance/100.0 ]];
    }
    else
    {
    self.balanceLabel.text=[@"-" stringByAppendingString:[_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:-1*self.actualBalance/100.0 ]] ];
    
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TransactionView"]) {
        [(PMRNavigationController*)segue.destinationViewController setTitleText:sender];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

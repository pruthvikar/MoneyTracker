//
//  PMRGraphViewController.m
//  MoneyTracker
//
//  Created by Pruthvikar Reddy on 07/04/2014.
//  Copyright (c) 2014 Pruthvikar Reddy. All rights reserved.
//

#import "PMRGraphViewController.h"
#import "JBLineChartView.h"
#import "PMRAppDelegate.h"
#import "Transaction.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "JBChartInformationView.h"
#import "JBChartTooltipTipView.h"
#import "JBChartTooltipView.h"
CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 6.0f;

@interface PMRGraphViewController ()<JBLineChartViewDataSource,JBLineChartViewDelegate>
@property (nonatomic,strong) JBLineChartView *lineChartView;
@property (nonatomic,strong) NSArray *transactions;
@property (nonatomic, strong) JBChartTooltipView *tooltipView;
@property (nonatomic, strong) JBChartTooltipTipView *tooltipTipView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (strong,nonatomic) NSNumberFormatter *currencyFormatter;
@property (strong,nonatomic) NSLocale *priceLocale;
@property (nonatomic, assign) BOOL tooltipVisible;
@property (nonatomic,strong) JBLineChartFooterView *footerView;

// Settres
- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated atTouchPoint:(CGPoint)touchPoint;
- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated;

@end

@implementation PMRGraphViewController

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
    
    [self.lineChartView setState:JBChartViewStateExpanded animated:YES callback:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
[self loadTransactions];
[self.lineChartView setState:JBChartViewStateCollapsed animated:NO callback:nil];
    
}

-(void)loadTransactions
{
    NSManagedObjectContext *moc = [(PMRAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Transaction" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"time" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    _transactions= [moc executeFetchRequest:request error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    _footerView.leftLabel.text = [dateFormatter stringFromDate:[[_transactions firstObject] time]];
    
    _footerView.rightLabel.text = [dateFormatter stringFromDate:[[_transactions lastObject] time]];
    
    [self.lineChartView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor darkGrayColor];
    
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;

    
    [self.view addSubview:self.lineChartView];


    
    _footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartFooterHeight)];
    _footerView.backgroundColor = [UIColor clearColor];
   
    _footerView.leftLabel.textColor = [UIColor whiteColor];
   
    _footerView.rightLabel.textColor = [UIColor whiteColor];
    _footerView.sectionCount = [_transactions count];
    self.lineChartView.footerView = _footerView;
    
    [self.view addSubview:self.lineChartView];
    
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    [self.informationView setTitleTextColor:[UIColor whiteColor]];
    [self.informationView setTextShadowColor:nil];
    [self.informationView setSeparatorColor:[UIColor darkGrayColor]];
    [self.view addSubview:self.informationView];


    _priceLocale = [NSLocale currentLocale];
    _currencyFormatter=[[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setLocale:_priceLocale];


    // Do any additional setup after loading the view.
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    CGFloat value=[self lineChartView:self.lineChartView verticalValueForHorizontalIndex:horizontalIndex atLineIndex:lineIndex];

    NSString *currencyString = [_currencyFormatter currencySymbol]; // EUR, GBP, USD...
    NSString *format = [_currencyFormatter positiveFormat];
    
    format = [format stringByReplacingOccurrencesOfString:@"¤" withString:currencyString];
    
    [_currencyFormatter setPositiveFormat:format];
    if (value>=0) {
        
        
        [self.informationView setValueText:[_currencyFormatter
                                            stringFromNumber:[NSNumber numberWithDouble:value/100.0 ] ]
                                 unitText:@"" ];
        [self.tooltipView setText:[_currencyFormatter
                                   stringFromNumber:[NSNumber numberWithDouble:value/100.0 ]]];
    }
    else
    {
        [self.informationView setValueText:[@"-" stringByAppendingString:[_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:-1*value/100.0 ]]]
                                  unitText:@"" ];

        [self.tooltipView setText:[@"-" stringByAppendingString:[_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:-1*value/100.0 ]] ]];

    }
    [self.informationView setTitleText:[_transactions[horizontalIndex] category]];
    


    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];

}

- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.informationView setHidden:YES animated:YES];
    [self setTooltipVisible:NO animated:YES];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [_transactions count]; // number of values for a line
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    CGFloat sum=0;
    for (int i=0; i<=horizontalIndex; i++) {
        sum+=[[(Transaction*)_transactions[i] amount] integerValue];
    }
    return sum; // y-position (y-axis) of point at horizontalIndex (x-axis)
}

- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated atTouchPoint:(CGPoint)touchPoint
{
    _tooltipVisible = tooltipVisible;
    
    JBChartView *chartView = [self lineChartView];
    
    if (!chartView)
    {
        return;
    }
    
    if (!self.tooltipView)
    {
        self.tooltipView = [[JBChartTooltipView alloc] init];
        self.tooltipView.alpha = 0.0;
        [self.view addSubview:self.tooltipView];
    }
    
    if (!self.tooltipTipView)
    {
        self.tooltipTipView = [[JBChartTooltipTipView alloc] init];
        self.tooltipTipView.alpha = 0.0;
        [self.view addSubview:self.tooltipTipView];
    }
    
    dispatch_block_t adjustTooltipPosition = ^{
        CGPoint originalTouchPoint = [self.view convertPoint:touchPoint fromView:chartView];
        CGPoint convertedTouchPoint = originalTouchPoint; // modified
        JBChartView *chartView = [self lineChartView];
        if (chartView)
        {
            CGFloat minChartX = (chartView.frame.origin.x + ceil(self.tooltipView.frame.size.width * 0.5));
            if (convertedTouchPoint.x < minChartX)
            {
                convertedTouchPoint.x = minChartX;
            }
            CGFloat maxChartX = (chartView.frame.origin.x + chartView.frame.size.width - ceil(self.tooltipView.frame.size.width * 0.5));
            if (convertedTouchPoint.x > maxChartX)
            {
                convertedTouchPoint.x = maxChartX;
            }
            self.tooltipView.frame = CGRectMake(convertedTouchPoint.x - ceil(self.tooltipView.frame.size.width * 0.5), CGRectGetMaxY(chartView.headerView.frame), self.tooltipView.frame.size.width, self.tooltipView.frame.size.height);
            
            CGFloat minTipX = (chartView.frame.origin.x + self.tooltipTipView.frame.size.width);
            if (originalTouchPoint.x < minTipX)
            {
                originalTouchPoint.x = minTipX;
            }
            CGFloat maxTipX = (chartView.frame.origin.x + chartView.frame.size.width - self.tooltipTipView.frame.size.width);
            if (originalTouchPoint.x > maxTipX)
            {
                originalTouchPoint.x = maxTipX;
            }
            self.tooltipTipView.frame = CGRectMake(originalTouchPoint.x - ceil(self.tooltipTipView.frame.size.width * 0.5), CGRectGetMaxY(self.tooltipView.frame), self.tooltipTipView.frame.size.width, self.tooltipTipView.frame.size.height);
        }
    };
    
    dispatch_block_t adjustTooltipVisibility = ^{
        self.tooltipView.alpha = _tooltipVisible ? 1.0 : 0.0;
        self.tooltipTipView.alpha = _tooltipVisible ? 1.0 : 0.0;
	};
    
    if (tooltipVisible)
    {
        adjustTooltipPosition();
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            adjustTooltipVisibility();
        } completion:^(BOOL finished) {
            if (!tooltipVisible)
            {
                adjustTooltipPosition();
            }
        }];
    }
    else
    {
        adjustTooltipVisibility();
    }
}

- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated
{
    [self setTooltipVisible:tooltipVisible animated:animated atTouchPoint:CGPointZero];
}

- (void)setTooltipVisible:(BOOL)tooltipVisible
{
    [self setTooltipVisible:tooltipVisible animated:NO];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

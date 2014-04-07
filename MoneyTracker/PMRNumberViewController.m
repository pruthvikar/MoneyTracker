//
//  PMRNumberViewController.m
//  MoneyTracker
//
//  Created by Pruthvikar Reddy on 06/04/2014.
//  Copyright (c) 2014 Pruthvikar Reddy. All rights reserved.
//

#import "PMRNumberViewController.h"
#import "PMRNumberPadViewController.h"
#import "PMRNavigationController.h"
#import "PMRTypeViewController.h"
@interface PMRNumberViewController ()<PMRNumberPadDelegate>
@property (strong, nonatomic) IBOutlet UILabel *transactionNumber;
@property (nonatomic) NSInteger value;
@property (strong,nonatomic) NSLocale* priceLocale;
@property (strong,nonatomic) NSNumberFormatter* currencyFormatter;
@property (strong,nonatomic) UIBarButtonItem *nextButton;
@end

@implementation PMRNumberViewController


-(void)addPressed
{
}

-(void)numberPressed:(NSInteger )number
{
    _value*=10;
    _value+=number;
    [self reloadValue];
}

-(void)clearPressed
{
    self.value=0;
    [self reloadValue];
}

-(void)reloadValue
{
    if (self.value==0) {
        [_nextButton setEnabled:NO];
        
    }
    else{
        [_nextButton setEnabled:YES];
    }



    NSString *format = [_currencyFormatter positiveFormat];
    format = [format stringByReplacingOccurrencesOfString:@"¤" withString:@""];
    [_currencyFormatter setPositiveFormat:format];
    

    self.transactionNumber.text=[_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.value/100.0]];
    
}

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
    
    _nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    [_nextButton setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f],
                                         } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = _nextButton;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [cancelButton setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f],
                                         } forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.view.backgroundColor=[UIColor darkGrayColor ];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor darkGrayColor];
    
    
        UILabel *titleView = (UILabel *)self.navigationItem.titleView;
        if (!titleView) {
            titleView = [[UILabel alloc] initWithFrame:CGRectZero];
            titleView.backgroundColor = [UIColor clearColor];
            titleView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];

            
            titleView.textColor = [UIColor whiteColor]; // Change to desired color
            
            self.navigationItem.titleView = titleView;
       
        }
    titleView.text = [(PMRNavigationController*)self.navigationController titleText];
        [titleView sizeToFit];
    self.navigationItem.titleView.tintColor=[UIColor whiteColor];

    
    _priceLocale = [NSLocale currentLocale];
    _currencyFormatter=[[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setLocale:_priceLocale];
    
    self.navigationController.navigationBar.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.navigationController.navigationBar.layer.borderWidth=2.0f;
    
    [self reloadValue];


    
    
    // Do any additional setup after loading the view.
}

-(void)next:(id)sender
{
    [self performSegueWithIdentifier:@"selectType" sender:self];
}
-(void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    if ([segue.identifier isEqualToString:@"numberPad"]) {
        [(PMRNumberPadViewController*)segue.destinationViewController setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"selectType"]) {
        if (![[(PMRNavigationController*)self.navigationController titleText] isEqualToString:@"Income"]) {
                    [(PMRTypeViewController*)segue.destinationViewController setAmount:-1*_value ];
        }
        else
        {
                    [(PMRTypeViewController*)segue.destinationViewController setAmount:_value ];
        }

    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

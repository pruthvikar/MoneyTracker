//
//  PMRTypeViewController.m
//  MoneyTracker
//
//  Created by Pruthvikar Reddy on 06/04/2014.
//  Copyright (c) 2014 Pruthvikar Reddy. All rights reserved.
//

#import "PMRTypeViewController.h"
#import "PMRNavigationController.h"
#import "UIImage+PMRRecolor.h"
#import "Transaction.h"
#import "PMRAppDelegate.h"
@interface PMRTypeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UIBarButtonItem *nextButton;
@property (strong,nonatomic) NSArray* categories;
@property (nonatomic) NSIndexPath* selectedIndex;
@end

@implementation PMRTypeViewController

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
    _categories=@[@"bank",@"bills",@"books",@"clothes",@"medical"];
    self.collectionView.backgroundColor=[UIColor darkGrayColor];
    _nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    [_nextButton setTitleTextAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f],
                                          } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = _nextButton;
    
    
    
 
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 27, 0, 27)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[(PMRNavigationController*)self.navigationController titleText] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [cancelButton setTitleTextAttributes:@{
                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f],
                                           } forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=cancelButton;
    
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
    titleView.text = @"Category";
    [titleView sizeToFit];
    self.navigationItem.titleView.tintColor=[UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;

    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-125);

    
    // Do any additional setup after loading the view.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_categories count];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 0.5, 0.0, 0.5);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"typeCell" forIndexPath:indexPath];
    UILabel* number=[[UILabel alloc]initWithFrame:CGRectMake(0.0, 70.0, 100.0, 30.0)];
    [cell addSubview:number];
    
    
    number.text=[_categories objectAtIndex:indexPath.item];
    number.textColor=[UIColor whiteColor];
    number.textAlignment=NSTextAlignmentCenter;
    number.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
    number.tag=1;
    
    UIImage* img=[[UIImage imageNamed:[_categories objectAtIndex:indexPath.item]]colorAnImage:[UIColor whiteColor]];
    UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(30.0, 15.0, 40.0, 40.0)];
    imgView.image=img;
    imgView.tag=2;
    [cell addSubview:imgView];
    
    cell.backgroundColor=[UIColor darkGrayColor];
//    cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
//    cell.layer.borderWidth=1.0f;
    return cell;
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex=indexPath;
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    UILabel*lbl=(UILabel*)[cell viewWithTag:1];
    lbl.textColor=[UIColor grayColor];
    UIImageView*img=(UIImageView*)[cell viewWithTag:2];
    img.image=[img.image colorAnImage:[UIColor grayColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    UILabel*lbl=(UILabel*)[cell viewWithTag:1];
    lbl.textColor=[UIColor whiteColor];
    UIImageView*img=(UIImageView*)[cell viewWithTag:2];
    img.image=[img.image colorAnImage:[UIColor whiteColor]];
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(106.0, 100.0);
    
}

-(void)next:(id)sender
{
    NSManagedObjectContext *moc = [(PMRAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    // Set example predicate and sort orderings...
    Transaction *trans = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Transaction"
                                    inManagedObjectContext:moc];
    trans.time=[NSDate date];
    trans.amount=[NSNumber numberWithInteger:_amount ];
    trans.category=_categories[_selectedIndex.item];
    NSError* error;
    [moc save:&error];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

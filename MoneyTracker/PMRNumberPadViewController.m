//
//  PMRNumberPadViewController.m
//  MoneyTracker
//
//  Created by Pruthvikar Reddy on 06/04/2014.
//  Copyright (c) 2014 Pruthvikar Reddy. All rights reserved.
//

#import "PMRNumberPadViewController.h"

@interface PMRNumberPadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSArray *values;
@end

@implementation PMRNumberPadViewController

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
//    self
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor=[UIColor darkGrayColor];
    self.collectionView.dataSource=self;

    self.collectionView.delegate=self;
    self.collectionView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-125);
    _values=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"C",@"0",@"+"];



    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-43, 0.0, 0.0, 0.0);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* number=[[UILabel alloc]initWithFrame:cell.bounds];
    [cell addSubview:number];
    number.text=_values[indexPath.item];
    number.textColor=[UIColor whiteColor];
    number.textAlignment=NSTextAlignmentCenter;
    number.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:32.0f];
    cell.backgroundColor=[UIColor darkGrayColor];
//    cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
//    cell.layer.borderWidth=1.0f;
    return cell;


}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.item<=8) {
        [_delegate numberPressed:indexPath.item+1];
    }
    else if (indexPath.item==10)
        [_delegate numberPressed:0];
    else if (indexPath.item==9)
    {
        [_delegate clearPressed];
    }
    else{
        [_delegate addPressed];
    }

}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((self.collectionView.contentSize.width/3.0), (self.collectionView.contentSize.height/4));

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

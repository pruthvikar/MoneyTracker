//
//  PMRNumberPadViewController.h
//  MoneyTracker
//
//  Created by Pruthvikar Reddy on 06/04/2014.
//  Copyright (c) 2014 Pruthvikar Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMRNumberPadDelegate <NSObject>
@required
-(void)numberPressed:(NSInteger)number;
-(void)clearPressed;
-(void)addPressed;
@end

@interface PMRNumberPadViewController : UICollectionViewController
@property (nonatomic,weak) id <PMRNumberPadDelegate> delegate;
@end

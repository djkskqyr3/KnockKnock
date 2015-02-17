//
//  KKTimeVC.h
//  KnockKnock
//
//  Created by JinJoUn on 1/25/15.
//  Copyright (c) 2015 JamesChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKTimeVCDelegate <NSObject>

@optional

- (void)finishedTimer:(id)sender;

@end

@interface KKTimeVC : UIViewController

@property (nonatomic, strong) id<KKTimeVCDelegate> delegate;

- (void)startTimer;
- (void)stopTimer;

- (BOOL)isRunning;

@end

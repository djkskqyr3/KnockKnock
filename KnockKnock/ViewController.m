//
//  ViewController.m
//  KnockKnock
//
//  Created by JamesChan on 1/23/15.
//  Copyright (c) 2015 JamesChan. All rights reserved.
//

#import "ViewController.h"
#import "KKTimeVC.h"
#import "knockDetector.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController () <KnockDetectorDelegate, KKTimeVCDelegate>
{
    knockDetector   *theDetector;
    
    int             currentTimer;
    
    KKTimeVC        *CurrentTimeVC;
    
    AVAudioPlayer   *audioPlayer;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    currentTimer = 0;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    KKTimeVC *timeVC = [[KKTimeVC alloc] init];
    timeVC.view.tag  = currentTimer;
    timeVC.delegate  = self;
    [self.scrollView addSubview:timeVC.view];
    
    CurrentTimeVC = timeVC;
    
    theDetector = [[knockDetector alloc] init];
    theDetector.delegate = self;
    [theDetector.listener collectMotionInformationWithInterval:(10)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detectorDidDetectKnock:(knockDetector*) detector
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if ([CurrentTimeVC isRunning])
    {
        notification.alertBody = @"Stop Timer";
        
        [CurrentTimeVC stopTimer];
    }
    else
    {
        notification.alertBody = @"Start Timer";
        
        [CurrentTimeVC startTimer];
    }
    
    notification.soundName = @"short_double_low.wav";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)finishedTimer:(id)sender
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;

    if (app.isBackgroundMode)
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.soundName = @"alert.m4a";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        return;
    }
    
    if (audioPlayer)
    {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    NSError *err;
    NSURL* musicFile  = [NSURL URLWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/alert.m4a"]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:&err];
    if (err == nil)
    {
        audioPlayer.numberOfLoops = 0;
        [audioPlayer setVolume:1.0];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
}

@end

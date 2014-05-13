//
//  MyViewController.h
//  Hello
//
//  Created by Talha Ansari on 1/29/14.
//  Copyright (c) 2014 Talha Ansari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ResultTableViewController.h"

@interface MyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *responseData;
@property NSArray *mainArray;
@property NSDictionary *res;
@property NSString *serverURL;

@property (strong, nonatomic)ResultTableViewController *resultView;
@property IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property BOOL flag;
@property NSString *status;

@property (strong, nonatomic) IBOutlet UIButton *testButton;
- (IBAction)Hit:(id)sender;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *processButton;
@property (strong, nonatomic) IBOutlet UIImageView *processImage;
- (IBAction)processAudio:(id)sender;
- (IBAction)recordAudio:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)stopAudio:(id)sender;

@end

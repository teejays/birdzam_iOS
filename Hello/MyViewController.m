//
//  MyViewController.m
//  Hello
//
//  Created by Talha Ansari on 1/29/14.
//  Copyright (c) 2014 Talha Ansari. All rights reserved.
//

#import "MyViewController.h"
#import "ResultTableViewController.h"

@implementation MyViewController

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
    
    // Declare ad initiate class variables
    _mainArray = [[NSArray alloc] initWithObjects:@"one", @"two", @"three", @"four", @"five", nil];
    _serverURL = @"http://127.0.0.1:5000/classify";
    
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_1_bw.jpg"]]];
    _label.textAlignment = NSTextAlignmentCenter;
    _message.textAlignment = NSTextAlignmentCenter;
    [_message setText:@""];
    _testButton.enabled = NO;
    [ self ResetState];

    // define touch action for process image - other buttons have touch actions linked through storyboard
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [_processImage addGestureRecognizer:singleTap];
    _processImage.userInteractionEnabled = YES;
    
    // Audio recording retup
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.wav"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ResetState {
    _status = @"CLEAN";
    [_label setText:@"Record"];
    UIImage *image = [UIImage imageNamed: @"logo_2.png"];
    [_processImage setImage:image];
    _recordButton.enabled = YES;
    _playButton.enabled = NO;
    _stopButton.enabled = NO;
    _processButton.enabled = NO;
}

- (IBAction)Hit:(id)sender {
    NSLog(@"Hello World");
    if(self.flag) {
        [self.label setText:@"Hi!"];
    }
    else {
        [self.label setText:@"Hello!"];
    }
    self.flag = !self.flag;
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue....");
    if ([segue.identifier isEqualToString:@"showPredictions"]) {
        NSLog(@"prepareForSegue: identifier found..");
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ResultTableViewController *destViewController = (ResultTableViewController *)navController.topViewController;
        destViewController.res = _res;
    }
}

- (IBAction)recordAudio:(id)sender {
    if (!_audioRecorder.recording)
    {
        NSLog(@"Button: Start recording...");
        [_label setText:@"Stop"];
        [_message setText:@"Recording..."];
        _playButton.enabled = NO;
        _stopButton.enabled = YES;
        _processButton.enabled = NO;
        _status = @"RECORDING";
        UIImage *image = [UIImage imageNamed: @"logo_5.png"];
        [_processImage setImage:image];
        [_audioRecorder record];
    }
}

- (IBAction)playAudio:(id)sender {
    if (!_audioRecorder.recording)
    {
        _stopButton.enabled = YES;
        _recordButton.enabled = NO;
        _processButton.enabled = YES;
        _processImage.userInteractionEnabled = YES;
        [_message setText:@"Playing..."];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:_audioRecorder.url
                        error:&error];
        [_audioPlayer setDelegate:self];
        NSLog(@"%@",_audioPlayer.url.path);
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [_audioPlayer play];
    }
}

- (IBAction)stopAudio:(id)sender {
    NSLog(@"Button: Stop recording.");
    [_label setText:@"Identify"];
    [_message setText:@"Recording complete."];
    _stopButton.enabled = NO;
    _playButton.enabled = YES;
    _recordButton.enabled = YES;
    _processButton.enabled = YES;
    if (_audioRecorder.recording)
    {
        [_audioRecorder stop];
    } else if (_audioPlayer.playing) {
        [_audioPlayer stop];
    }
    _status = @"RECORDED";
    UIImage *image = [UIImage imageNamed: @"logo_3.png"];
    [_processImage setImage:image];
}

-(void)processTapDetected{
    NSLog(@"single Tap on processImage");
    
    if ([_status  isEqual: @"CLEAN"])
    {
        // RECORD!
        if (!_audioRecorder.recording)
        {
            NSLog(@"start recording");
            [_label setText:@"Stop"];
            [_message setText:@"Recording..."];
            _playButton.enabled = NO;
            _stopButton.enabled = YES;
            _processButton.enabled = NO;
            [_audioRecorder record];
            _status = @"RECORDING";
            UIImage *image = [UIImage imageNamed: @"logo_5.png"];
            [_processImage setImage:image];
        }
    }
    
    else if ([_status  isEqual: @"RECORDING"])
    {
        // STOP RECORDING!
        NSLog(@"stop recording");
        [_label setText:@"Identify"];
        [_message setText:@"Recording complete."];
        _stopButton.enabled = NO;
        _playButton.enabled = YES;
        _recordButton.enabled = YES;
        _processButton.enabled = YES;
        
        if (_audioRecorder.recording)
        {
            [_audioRecorder stop];
        } else if (_audioPlayer.playing) {
            [_audioPlayer stop];
        }
        _status = @"RECORDED";
        UIImage *image = [UIImage imageNamed: @"logo_3.png"];
        [_processImage setImage:image];
    }
    
    else if ([_status  isEqual: @"RECORDED"])
    {
        NSLog(@"Processing happening");
        _status = @"IDENTIFYING";
        [_label setText:@"Identifying..."];
        [_message setText:@"Processing..."];
        
        _recordButton.enabled = NO;
        _playButton.enabled = NO;
        _stopButton.enabled = NO;
        _processButton.enabled = NO;
        
//        NSData *audioData = [NSData dataWithContentsOfFile:@"/Users/talhajansari/Library/Application Support/iPhone Simulator/7.1/Applications/E1061366-05C2-4412-B381-39023F3C6C18/Documents/sound.wav"];
        NSString *soundpath = [_audioRecorder.url path];
        NSLog(@"%@",soundpath);
        NSData *audioData = [NSData dataWithContentsOfFile:soundpath];

        if (audioData != nil)
        {
            NSString *filenames = [NSString stringWithFormat:@"SoundLabel"];
            NSLog(@"%@", filenames);
//            NSString *urlString = @"http://127.0.0.1:5000/classify";
            NSString *urlString = _serverURL;
            NSLog(@"%@", urlString);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".wav\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:audioData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            // now lets make the connection to the web
            //NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            //NSLog(returnString);
            
            [request setTimeoutInterval:30.0];
            NSLog(@"about to establish connection...");
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else {
        NSLog(@"no audio data detected");
            [_message setText:@"No audio found"];
        }
//        _recordButton.enabled = YES;
//        _playButton.enabled = YES;
//        _stopButton.enabled = YES;
//        _processButton.enabled = YES;
        
    }
    
    else if ([_status  isEqual: @"IDENTIFYING"])
    {
        [_message setText:@"Cancelled. Start afresh."];
        [self ResetState];
    }
}

- (IBAction)processAudio:(id)sender {
//    NSLog(@"Processing happening");
//    
//    _recordButton.enabled = NO;
//    _playButton.enabled = NO;
//    _stopButton.enabled = NO;
//    _processButton.enabled = NO;
//    _processImage.userInteractionEnabled = NO;
//    
//    NSData *audioData = [NSData dataWithContentsOfFile:@"/Users/talhajansari/Library/Application Support/iPhone Simulator/7.1/Applications/E1061366-05C2-4412-B381-39023F3C6C18/Documents/sound.wav"];
//    
//    if (audioData != nil)
//    {
//        NSString *filenames = [NSString stringWithFormat:@"SoundLabel"];      //set name here
//        NSLog(@"%@", filenames);
//        NSString *urlString = @"http://127.0.0.1:5000";
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString:urlString]];
//        [request setHTTPMethod:@"POST"];
//        
//        NSString *boundary = @"---------------------------14737809831466499882746641449";
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//        
//        NSMutableData *body = [NSMutableData data];
//        
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".wav\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[NSData dataWithData:audioData]];
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        // setting the body of the post to the reqeust
//        [request setHTTPBody:body];
//        // now lets make the connection to the web
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        NSLog(returnString);
//        NSLog(@"finish");
//    }
//    
//    _recordButton.enabled = YES;
//    _playButton.enabled = YES;
//    _stopButton.enabled = YES;
//    _processButton.enabled = YES;
//    _processImage.userInteractionEnabled = YES;
//    
}


// AV Framework methods

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _recordButton.enabled = YES;
    _stopButton.enabled = NO;
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}


// Pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    NSLog(@"URL: Received response");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSLog(@"URL: Received data");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    NSLog(@"URL: connection...");
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    
    // convert to JSON
    NSError *myError = nil;
    _res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in _res) {
        
        id value = [_res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [_res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    [_message setText:@"Processing complete."];
    
    NSLog(@"URL: Connection finish loading");
    
    //UIViewController *controler = [[UIViewController alloc] init];
    //[self.navigationController pushViewController:controler animated:YES];
    [self.tableView reloadData];
    _testButton.enabled = YES;
    [self ResetState];
    [self performSegueWithIdentifier:@"showPredictions" sender:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"URL: Error");
    [_message setText:@"Error: Try again."];
    [self ResetState];
    
}


// TABLE VIEW FUNCTIONS

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    NSLog(@"numberOfSectionsInTableView");
//    return [self.res count];
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSLog(@"titleForHeaderInSection");
//    return [[self.res allKeys] objectAtIndex:section];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection");
//    NSString *rank = [self tableView:tableView titleForHeaderInSection:section];
//    return [[self.res valueForKey:rank] count];
    NSInteger numRows = [_res count];
    NSString *numRowsString = [NSString stringWithFormat:@"%d",numRows];
    NSLog(@"%@",numRowsString);
    return numRows;

}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"something" forIndexPath:indexPath];
     
     // Configure the cell...
         NSLog(@"cellForRowAtIndexPath");
         static NSString *CellIdentifier = @"specieCell";
         
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         if (cell == nil) {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         
         // Configure the cell...
         //NSString *rank = [self tableView:tableView titleForHeaderInSection:indexPath.section];
         NSString *key = [NSString stringWithFormat:@"%d",(indexPath.row + 1)];
         NSLog(@"%@",key);
//         NSString *species = [[self.res valueForKey:rank2] objectAtIndex:indexPath.row];
         NSString *value = [self.res valueForKey:key];
         NSString *valueAsString = (NSString *)value;
         NSLog(@"%@",valueAsString);
         cell.textLabel.text = valueAsString;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specieCell"];
//     cell.textLabel.text = [_mainArray objectAtIndex:indexPath.row];
     
//     for(id key in _res) {
//         
//         id value = [_res objectForKey:key];
//         
//         NSString *keyAsString = (NSString *)key;
//         NSString *valueAsString = (NSString *)value;
//         
//         NSLog(@"key: %@", keyAsString);
//         NSLog(@"value: %@", valueAsString);
//     }
     return cell;
     
 }


@end



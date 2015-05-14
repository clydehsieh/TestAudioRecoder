//
//  ViewController.m
//  TestRecordVoice
//
//  Created by Chin-Hui Hsieh  on 5/13/15.
//  Copyright (c) 2015 Chin-Hui Hsieh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic)    AVAudioRecorder *audioRecorder;
@property (strong, nonatomic)    AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *recordState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_btnStop setEnabled:NO];
    [_btnPlay setEnabled:NO];
    
    //set the audio file
    NSArray *pathComponent = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"myAudioMemo.m4a", nil];
    NSURL  *outputFileURL = [NSURL fileURLWithPathComponents:pathComponent];
    
    
    //set audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //錄音設定
    NSMutableDictionary *recordString = [[NSMutableDictionary alloc]init];
    
    _audioRecorder = [[AVAudioRecorder alloc]initWithURL:outputFileURL settings:recordString error:nil];

    _audioRecorder.delegate = self;
    
    _audioRecorder.meteringEnabled = YES;
    
    [_audioRecorder prepareToRecord];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recordTapping:(id)sender {

    if (_audioPlayer.playing) {
        [_audioPlayer stop];
    }
    
    if (!_audioRecorder.recording) {
        AVAudioSession *session=[AVAudioSession sharedInstance];
        
        [session setActive:YES error:nil];
        
        [_audioRecorder record];
        [_btnRecord setTitle:@"Record" forState:UIControlStateNormal];
        _recordState.text = @"Recording!!";
                                
    }else
    {
        [_audioRecorder record];
        [_btnRecord setTitle:@"Record" forState:UIControlStateNormal];
        _recordState.text = @"Recording!!";
    }
    
    [_btnStop setEnabled:YES];
    [_btnPlay setEnabled:NO];
    
    
}

- (IBAction)stopTapping:(id)sender {
    
    [_audioRecorder stop];
    
    AVAudioSession *session=[AVAudioSession sharedInstance];
    
    [session setActive:NO error:nil];
    
}

- (IBAction)playTapping:(id)sender {
    
    if (!_audioRecorder.recording) {
        
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:_audioRecorder.url error:nil];
        
        [_audioPlayer setDelegate:self];
        
        [_audioPlayer play];
        
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [_btnRecord setTitle:@"Record" forState:UIControlStateNormal];
    [_btnStop setEnabled:NO];
    [_btnPlay setEnabled:YES];
    _recordState.text = @"Recording fisished!!";
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"Done" message:@"Finish playing the recording" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [showAlert show];
    _recordState.text = @"playing done!!";
}


@end











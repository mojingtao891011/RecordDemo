//
//  ViewController.m
//  Record
//
//  Created by 莫景涛 on 14-3-25.
//  Copyright (c) 2014年 莫景涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (sessionError) {
        NSLog(@"%@",sessionError);
    }
    [session setActive:YES error:nil];

	[self creatRecord];
   
}
- (void)creatRecord
{
    self.pathFile = [[NSString alloc]initWithFormat:@"%@%@" , NSTemporaryDirectory() , @"recorder.wav"];
    NSURL *pathUrl = [NSURL URLWithString:self.pathFile];
    NSError *error ;
    self.recorder = [[AVAudioRecorder alloc]initWithURL:pathUrl settings:nil error:&error];
    if (error) {
        NSLog(@"creat record error %@" , error);
    }
    self.recorder.meteringEnabled = YES ;
    self.recorder.delegate = self ;
    [self.recorder prepareToRecord];
    [self.recorder record];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updatelabel) userInfo:nil repeats:YES];

}
- (void)updatelabel
{
    [self.recorder updateMeters];
    self.averagelabel.text = [NSString stringWithFormat:@"%f",[self.recorder averagePowerForChannel:10]];
    [self.averagelabel sizeToFit];
    self.peaklabel.text =[NSString stringWithFormat:@"%f" ,[self.recorder peakPowerForChannel:0]];
    [self.peaklabel sizeToFit];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)record:(id)sender {
    NSLog(@"click record");
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    else
    {
        [self.recorder record];
        [self.recordButton setTitle:@"stop" forState:UIControlStateNormal];
    }
}

- (IBAction)play:(id)sender {
    NSLog(@"click play");
    if (self.player.playing) {
        [self.player stop];
        [self.playButton setTitle:@"play" forState:UIControlStateNormal];
    }
    else if (_newRecordingAvaiable){
        NSURL *url = [[NSURL alloc]initFileURLWithPath:self.pathFile];
        NSError *error ;
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if (!error) {
            [self.player setDelegate:self];
            [self.player play];
        }else{
            NSLog(@"creat play error %@",error);
        }
        [self.playButton setTitle:@"Puase" forState:UIControlStateNormal];
        _newRecordingAvaiable = NO ;
    }else if (self.player){
        [self.player play];
        [self.playButton setTitle:@"puase" forState:UIControlStateNormal];
    }
    
}
#pragma mark------AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    _newRecordingAvaiable = flag ;
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
}
#pragma mark------AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}
@end

//
//  ViewController.h
//  Record
//
//  Created by 莫景涛 on 14-3-25.
//  Copyright (c) 2014年 莫景涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate , AVAudioRecorderDelegate>
{
    BOOL _newRecordingAvaiable ;
}
@property (weak, nonatomic) IBOutlet UILabel *averagelabel;
@property (weak, nonatomic) IBOutlet UILabel *peaklabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property(nonatomic , retain)AVAudioPlayer * player ;
@property(nonatomic , retain)AVAudioRecorder *recorder ;
@property(nonatomic , copy)NSString *pathFile ;

- (IBAction)record:(id)sender;
- (IBAction)play:(id)sender;

@end

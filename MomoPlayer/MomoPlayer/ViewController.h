//
//  ViewController.h
//  MomoPlayer
//
//  Created by Mikito Yoshiya on 12/02/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <SocketIODelegate, MPMediaPickerControllerDelegate>{
    //NSMutableArray *mediaItems;
    IBOutlet UITableView *playlistView;
    MPMediaItemCollection *playlist;
}

-(IBAction) showPicker;

@property (nonatomic, retain) MPMediaItemCollection *playlist;

@end
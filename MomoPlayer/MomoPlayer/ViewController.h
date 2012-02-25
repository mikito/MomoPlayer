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

#define HOST @"10.0.1.10"
#define PORT 3000

@interface ViewController : UIViewController <SocketIODelegate, MPMediaPickerControllerDelegate>{
    //NSMutableArray *mediaItems;
    IBOutlet UITableView *playlistView;
    MPMediaItemCollection *playlist;
    NSArray *playlists;
    SocketIO *socket;
}

-(IBAction) showPicker;

@property (nonatomic, retain) MPMediaItemCollection *playlist;
@property (nonatomic, retain) NSArray *playlists;

@end
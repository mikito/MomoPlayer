//
//  PlayListViewController.h
//  MomoPlayer
//
//  Created by 吉谷 幹人 on 12/02/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayListViewController : UIViewController <MPMediaPickerControllerDelegate>{
    IBOutlet UITableView *playlistView;
    MPMediaItemCollection *playlist;
    NSArray *items;
}

@property (nonatomic, retain) MPMediaItemCollection *playlist;

@end

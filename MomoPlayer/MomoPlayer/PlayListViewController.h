//
//  PlayListViewController.h
//  MomoPlayer
//
//  Created by 吉谷 幹人 on 12/02/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#define ITUNESURL @"http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=music&restrict=true&submit=media&term="

@protocol PlayListViewControllerDelegate
-(void) play:(int)index;
-(void) exitPlay;
@end

@interface PlayListViewController : UIViewController <MPMediaPickerControllerDelegate>{
    id delegate;
    IBOutlet UITableView *playlistView;
    MPMusicPlayerController *iPodMusicPlayer;
    NSMutableArray *playlist;
    int playIndex;
    BOOL join;
}
-(void) setPlaylist:(NSArray *)items;
-(IBAction) pushBackButton;
-(void) playMusic:(int)index;

//@property (nonatomic, retain) MPMediaItemCollection *playlist;
@property (nonatomic, retain) id delegate;
@property (nonatomic) int playIndex;

@end

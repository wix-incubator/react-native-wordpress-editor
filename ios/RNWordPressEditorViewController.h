//
//  RNWordPressEditorViewController.h
//  ReactNativeControllers
//
//  Created by Artal Druk on 30/05/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPEditorViewController.h"
#import "RCCExternalViewControllerProtocol.h"

/*
 RNWordPressEditorViewController
 
 The editor ViewController which inherits from the WordPress one. Implements RCCExternalViewControllerProtocol so it can be pushed by react-native-controllers
 */


extern NSString* const EditorDidPressMediaNotification;

@interface RNWordPressEditorViewController : WPEditorViewController <WPEditorViewControllerDelegate, RCCExternalViewControllerProtocol>

@property (nonatomic, strong) NSArray *pendingImagesToAdd;

+(RNWordPressEditorViewController*)getActiveInstance;

-(void)setInitialTitleAndBody;
-(BOOL)initialPostChanged;
-(NSDictionary*)coverImageData;
-(void)addImages:(NSArray*)images;
-(void)setBottomToolbarHidden:(BOOL)hidden;

@end

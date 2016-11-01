/*
 * This file is part of the react-native-wordpress-editor project.
 *
 * Copyright (C) 2016 Wix.com Ltd
 *
 * react-native-wordpress-editor is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 2 of the License.
 *
 * react-native-wordpress-editor is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with react-native-wordpress-editor. If not, see <http://www.gnu.org/licenses/>
 */

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
-(void)setBottomToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)dismissKeyboardIfEditing;
-(void)showKeyboardIfEditing;

@end

//
//  RNWordPressEditorViewController.h
//  ReactNativeControllers
//
//  Created by Artal Druk on 30/05/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "WPEditorViewController.h"
#import "RCTBridgeModule.h"
#import "RCCExternalViewControllerProtocol.h"

@interface RNWordPressEditorViewController : WPEditorViewController <WPEditorViewControllerDelegate, RCCExternalViewControllerProtocol>
@end

@interface BlogEditorManager : NSObject <RCTBridgeModule>
@end

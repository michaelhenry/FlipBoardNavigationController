//
//  FlipBoardNavigationController.h
//  iamkel.net
//
//  Created by Michael henry Pantaleon on 4/30/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FlipBoardNavigationControllerCompletionBlock)(void);

@interface FlipBoardNavigationController : UIViewController

@property(nonatomic, retain) NSMutableArray *viewControllers;

- (id) initWithRootViewController:(UIViewController*)rootViewController;

- (void) pushViewController:(UIViewController *)viewController;
- (void) pushViewController:(UIViewController *)viewController completion:(FlipBoardNavigationControllerCompletionBlock)handler;
- (void) popViewController;
- (void) popViewControllerWithCompletion:(FlipBoardNavigationControllerCompletionBlock)handler;
@end

@interface UIViewController (FlipBoardNavigationController)
@property (nonatomic, retain) FlipBoardNavigationController *flipboardNavigationController;
@end





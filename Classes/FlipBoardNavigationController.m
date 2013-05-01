//
//  FlipBoardNavigationController.m
//  iamkel.net
//
//  Created by Michael henry Pantaleon on 4/30/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "FlipBoardNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define ANIMATION_DURATION 0.5f
#define ANIMATION_DELAY 0
#define OFFSET_TRIGGER 3.0
#define MAX_BLACK_MASK_ALPHA 0.8f


typedef enum {
    PanDirectionNone = 0,
    PanDirectionLeft = 1,
    PanDirectionRight = 2
} PanDirection;


@interface FlipBoardNavigationController ()<UIGestureRecognizerDelegate>{
    NSMutableArray *_gestures;
    UIView *_blackMask;
    CGPoint _panOrigin;
    BOOL _animationInProgress;
}

- (void) addPanGestureToView:(UIView*)view;
- (CGRect) getSlidingRectForOffset:(CGFloat)offset ;
- (void) rollBackViewController;
- (void) completeSlidingAnimationWithDirection:(PanDirection)direction;

- (UIViewController *)currentViewController;
- (UIViewController *)previousViewController;
@end

@implementation FlipBoardNavigationController

- (id) initWithRootViewController:(UIViewController*)rootViewController {
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray arrayWithObject:rootViewController];
        rootViewController.flipboardNavigationController =  self;
        UIView * rootView = rootViewController.view;
        CGSize viewSize = self.view.frame.size;
        rootView.frame = CGRectMake(0.0f, 0.0f, viewSize.width, viewSize.height);
        [self.view addSubview:rootView];
    }
    return self;
}

- (void) dealloc {
    self.viewControllers = nil;
    _gestures  = nil;
    _blackMask = nil;
}

- (void) loadView {
    [super loadView];
    CGSize viewSize = self.view.frame.size;
    _blackMask = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, viewSize.width, viewSize.height)];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0;
    [self.view insertSubview:_blackMask atIndex:0];
}

#pragma mark - PushViewController With Completion Block
- (void) pushViewController:(UIViewController *)viewController completion:(FlipBoardNavigationControllerCompletionBlock)handler {
    _animationInProgress = YES;
    viewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
    viewController.flipboardNavigationController = self;
    _blackMask.alpha = 0.0;
    [self.view bringSubviewToFront:_blackMask];
    [self.view addSubview:viewController.view];
    [UIView animateWithDuration:ANIMATION_DURATION delay:ANIMATION_DELAY options:0 animations:^{
        CGAffineTransform transf = CGAffineTransformIdentity;
        [self currentViewController].view.transform = CGAffineTransformScale(transf, 0.9f, 0.9f);
        viewController.view.frame = self.view.bounds;
        _blackMask.alpha = MAX_BLACK_MASK_ALPHA;
    }   completion:^(BOOL finished) {
        if (finished) {
            [self.viewControllers addObject:viewController];
            _animationInProgress = NO;
            _gestures = [[NSMutableArray alloc] init];
            [self addPanGestureToView:[self currentViewController].view];
            handler();
        }
    }];
}

- (void) pushViewController:(UIViewController *)viewController {
    [self pushViewController:viewController completion:^{}];
}

#pragma mark - PopViewController With Completion Block
- (void) popViewControllerWithCompletion:(FlipBoardNavigationControllerCompletionBlock)handler {
    _animationInProgress = YES;
    if (self.viewControllers.count < 2) {
        return;
    }
    
    [UIView animateWithDuration:ANIMATION_DURATION delay:ANIMATION_DELAY options:0 animations:^{
        [self currentViewController].view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
        CGAffineTransform transf = CGAffineTransformIdentity;
        [self previousViewController].view.transform = CGAffineTransformScale(transf, 1.0, 1.0);
        [self previousViewController].view.frame = self.view.bounds;
        _blackMask.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view bringSubviewToFront:[self previousViewController].view];
            [self.viewControllers removeLastObject];
            _animationInProgress = NO;
            handler();
        }
    }];
    
}

- (void) popViewController {
    [self popViewControllerWithCompletion:^{}];
}

- (void) rollBackViewController {
    _animationInProgress = YES;
    
    UIViewController * vc = [self currentViewController];
    UIViewController * nvc = [self previousViewController];
    CGRect rect = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
    self.view.transform = self.view.transform;
    [UIView animateWithDuration:((vc.view.frame.origin.x *ANIMATION_DURATION)/self.view.frame.size.width) delay:ANIMATION_DELAY options:0 animations:^{
        CGAffineTransform transf = CGAffineTransformIdentity;
        nvc.view.transform = CGAffineTransformScale(transf, 0.9f, 0.9f);
        vc.view.frame = rect;
        _blackMask.alpha = MAX_BLACK_MASK_ALPHA;
    }   completion:^(BOOL finished) {
        if (finished) {
            _animationInProgress = NO;
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ChildViewController
- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>0) {
        result = [self.viewControllers lastObject];
    }
    return result;
}

#pragma mark - ParentViewController
- (UIViewController *)previousViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>1) {
        result = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    return result;
}

#pragma mark - Add Pan Gesture
- (void) addPanGestureToView:(UIView*)view
{
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(gestureRecognizerDidPan:)];
    panGesture.cancelsTouchesInView = YES;
    panGesture.delegate = self;
    [view addGestureRecognizer:panGesture];
    [_gestures addObject:panGesture];
    panGesture = nil;
}


#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIViewController * vc =  [self.viewControllers lastObject];
    _panOrigin = vc.view.frame.origin;
    gestureRecognizer.enabled = YES;
    return !_animationInProgress;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (void) gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture {
    if(_animationInProgress) return;
    CGPoint currentPoint = [panGesture translationInView:self.view];
    CGFloat x = currentPoint.x + _panOrigin.x;
    CGFloat offset = 0;
    
    UIViewController * vc ;
    vc = [self currentViewController];
    offset = CGRectGetWidth(vc.view.frame) - x;
    vc.view.frame = [self getSlidingRectForOffset:offset];
    
    CGAffineTransform transf = CGAffineTransformIdentity;
    CGFloat newTransformValue =  1 - (offset/(self.view.frame.size.width/10))/100;
    CGFloat newAlphaValue = (offset/self.view.frame.size.width)* MAX_BLACK_MASK_ALPHA;
    
    [self previousViewController].view.transform = CGAffineTransformScale(transf,newTransformValue,newTransformValue);
    
    _blackMask.alpha = newAlphaValue;
    
    PanDirection panDirection = PanDirectionNone;
    CGPoint vel = [panGesture velocityInView:self.view];
    if (vel.x > 0) {
        panDirection = PanDirectionRight;
    } else {
        panDirection = PanDirectionLeft;
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        [self completeSlidingAnimationWithDirection:panDirection];
    }
}

// This will complete the animation base on pan direction
- (void) completeSlidingAnimationWithDirection:(PanDirection)direction {
    if(direction==PanDirectionRight){
        [self popViewController];
    }else {
        [self rollBackViewController];
    }
}

// Get the current position for the visible viewcontrollers
- (CGRect) getSlidingRectForOffset:(CGFloat)offset {
    
    CGRect rectToReturn = CGRectZero;
    UIViewController * vc;
    vc = [self currentViewController];
    rectToReturn.size = vc.view.frame.size;
    CGFloat width = CGRectGetWidth(vc.view.frame);
    rectToReturn.origin = CGPointMake(MIN(MAX(width-offset,0),vc.view.frame.size.width), 0.0);
    return rectToReturn;
}

@end


#pragma mark - UIViewController Category
//For Global Access of flipViewController
@implementation UIViewController (FlipBoardNavigationController)
static char flipboardNavigationControllerKey;

- (void) setFlipboardNavigationController:(FlipBoardNavigationController *)flipboardNavigationController {
    [self willChangeValueForKey:@"flipboardNavigationController"];
    objc_setAssociatedObject( self,
                             &flipboardNavigationControllerKey,
                             flipboardNavigationController,
                             OBJC_ASSOCIATION_RETAIN );
    
    [self didChangeValueForKey:@"flipboardNavigationController"];
}

- (FlipBoardNavigationController*) flipboardNavigationController {
    id controller = objc_getAssociatedObject( self,
                                             &flipboardNavigationControllerKey );
    return controller;
}
@end
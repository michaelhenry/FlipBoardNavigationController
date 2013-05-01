//
//  ViewController.m
//  FlipViewControllerDemo
//
//  Created by Michael henry Pantaleon on 5/2/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "ViewController.h"
#import "FlipBoardNavigationController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)push:(UIButton *)sender {
    UIViewController * page = [self.storyboard instantiateViewControllerWithIdentifier:@"child_vc"];
    [self.flipboardNavigationController pushViewController:page];
}
@end

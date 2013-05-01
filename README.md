FlipBoardNavigationController
=============================

This is a new navigation controller inspired by Flipboard.


# Usage

## Creating your controller
Somewhere, for example in your app delegate, alloc and init the controller :

    _flipboardNavigationController = [[FlipBoardNavigationController alloc]initWithRootViewController:rootViewController];

Then, add it to the window

	self.window.rootViewController = _flipboardNavigationController;

or to a view 

	[self.view addSubview:_flipboardNavigationController.view];
	

You can add a navigation controller on top, for example : 

	MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    _flipboardNavigationController = [[FlipBoardNavigationController alloc]initWithRootViewController:rootViewController];
    self.window.rootViewController = _flipboardNavigationController;
    
## Pushing a controller
You have several options to push a controller
The easiest way is : 

	[self.flipboardNavigationController pushViewController:anotherViewController];

or you can also use the completion block if ever you need it.

	[self.flipboardNavigationController pushViewController:anotherViewController completion:^{
        NSLog(@"Complete");
    }];


## Popping
To go back to your parent view controller, you can pop :

	 [self.flipboardNavigationController popViewController];

or 

	[self.flipboardNavigationController popViewControllerWithCompletion:^{
        <#code#>
    }].


## Screenshots
![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/iOSSimulatorScreenshotMay22013123026AM_zps6ec41d74.png)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/iOSSimulatorScreenshotMay22013124719AM_zpsf0c95e63.png)




Please let me know if you have any questions. 

Cheers,  
[Michael Henry Pantaleon](http://www.iamkel.net)
  
http://www.iamkel.net
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



# Licensing

Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
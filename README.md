
DayToDay Application Instructions


These are the instructions to run the DayToDay application in your emulator. 

The finished version of this product is a phone app, so these instructions would simply be to download it to your phone.


However, for this working version, the instructions are:

	- Download and install flutter on your machine. https://docs.flutter.dev/get-started/install
		-There is a lot to this step. You have to install it, and then you have to add the variables to path so
		 they can be run from the command line. 

	- Download and install android studio on your machine. https://developer.android.com/studio#downloads
		-This is so that you can test the application on a virtual machine. You can download any virtual machine
		 you want, but we used the Pixel 5 for testing if you would like to use the same.

	- You can use android studio or visual studio code, but if you use vs code you have to hook up the virtual
	  machine to it.

	- In the terminal before running, write "flutter doctor"

	- Then do these commands in the following order:
		- flutter pub get
		- flutter packages get (this one may be unneccessary)
		- flutter pub run flutter_native_splash:create
		- flutter pub run flutter_native_icons:main

	- Now you should be able to run it in the virtual environment.

	- If you would like to download the application to your real phone, you can hook up your phone to your computer
	  and send it there through andoid studio. (This function might not work on apple products).
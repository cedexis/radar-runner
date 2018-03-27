# Cedexis Radar Runner for Apple OS X and iOS

### Quick Start

 * Copy either the Objective-C or Swift files to your project.
 * Add the new files to the build.
 * Create an instance of the Cedexis class.
 * Call the start method with your zoneId and customerId.
 * Call didReceiveMemoryWarning from your delegate of the same name.

### Swift

Step by step guide for Xcode 8 and Swift. We'll create the simplest possible
application with the Cedexis Radar client embedded.

 * Create a new iOS project as a "Single View Application". Give it a name and
   make sure the language option is set to "Swift".

 * CTRL-click in the project navigator and choose "Add files to...". Select 
   "Cedexis.swift" to be added.
    
 * Edit the ViewController class. Add the three lines containing "cedexis" so 
   it looks like the code below. You will need to use your real zone ID and
   customer ID for this to actually send data, but it's ok to test with 00000.

       class ViewController: UIViewController {

           let cedexis = Cedexis()

           override func viewDidLoad() {
               super.viewDidLoad()
               cedexis.start(zoneId: 1, customerId: 00000)
           }

           override func didReceiveMemoryWarning() {
               super.didReceiveMemoryWarning()
               cedexis.didReceiveMemoryWarning()
           }
       }

 * Run the program. You are done.

### Objective-C

Step by step guide for Xcode 8 and Objective-C. We'll create the simplest
possible application with the Cedexis Radar client embedded.

 * Create a new iOS project as a "Single View Application". Give it a name and
   make sure the language option is set to "Objective-C".

 * CTRL-click in the project navigator and choose "Add files to...". Select 
   "Cedexis.h" and "Cedexis.m" to be added.
    
 * Edit "ViewController.m". Add the five lines containing "cedexis" so 
   it looks like the code below. You will need to use your real zone ID and
   customer ID for this to actually send data, but it's ok to test with 00000.

        #import "ViewController.h"
        #import "Cedexis.h"

        @interface ViewController ()
        { @private Cedexis *cedexis; }
        @end

        @implementation ViewController

        - (void)viewDidLoad {
            [super viewDidLoad];
            cedexis = [Cedexis new];
            [cedexis startForZoneId:1 customerId:00000];
        }

        - (void)didReceiveMemoryWarning {
            [super didReceiveMemoryWarning];
            [cedexis didReceiveMemoryWarning];
        }

        @end

 * Run the program. You are done.
 
### Using the API

`cedexis.start` may be called repeatedly. Every time you call this a new probing
session will run. Be aware that there is a waiting period between sessions
(currently 1 minute, subject to change).

`cedexis.didReceiveMemoryWarning` will free up all but a few bytes of memory. Note
that after calling this there is startup cost the next time `start` is called.

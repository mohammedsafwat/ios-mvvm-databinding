# todo-mvvm-databinding

This app is a small demonstration for the MVVM design pattern, and is based on the [todo-mvvm-databinding](https://github.com/googlesamples/android-architecture/tree/todo-mvvm-databinding) sample from Google.

This app uses a [GitHub API endpoint](https://api.github.com/users/vladimirwrites) to get the user details by passing the username as a parameter to the GET request.

## Designing the app

The ViewModel in the MVVM architecture plays a similar role to the Presenter in the MVP architecture. The two architectures differ in the way that the View communicates with the ViewModel or Presenter respectively:
* When the app modifies the ViewModel in the MVVM architecture, the View is automatically updated by a library or framework. You can’t update the View directly from the ViewModel, as the ViewModel doesn't have access to the necessary reference.
* You can however update the View from the Presenter in an MVP architecture as it has the necessary reference to the View. When a change is necessary, you can explicitly call the View from the Presenter to update it.

## How to run the app

* Clone the repo at any place you like on your local machine.
* Navigate to the main directory of the project and run `pod install`.
* Open the `.xcworkspace` file. Hit CMD+R to run the project.
* If you want to run the unit tests bundle, you can hit CMD+U.

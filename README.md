# FidoApp
The is an iOS App Exercise.

**Aditional considerations:**

I decided to try and use TCA (The Composable Architecture) while building this project since I've recently added some React Development to my development
experience and I had read online that it was a good approach to use with SwiftUI and to keep thing organized. 

It was quite a challenge since the documentation and examples online are sometimes not "exactly" what you maybe looking for, outdated or behind a paywall. Overall I consider a nice architecture but not so good for unit testing as they say, or at least I found it had some wierd behaviors.
I also, opted for SwiftData for offline capabilities for its simplicity.

### THE CHALLENGE
We would like you to write an application using Swift that utilises the Dog API (https://
thedogapi.com/).
You can go nuts with the visual design of the application, there is only a few components that we
ask you to use. Don’t worry, we will only evaluate the code quality. Also, you are allowed to use
any library you want.

### THE REQUIREMENTS
Your Application should have the following functionalities:
1. Show a screen with a list of dog breeds images.
2. Show a screen with a list of dog breeds when you search by breed name.
3. Show a screen with the detailed view of a breed.

### THE REQUIREMENTS DESCRIPTION
We need you to use a Tab Bar in order to move from the the list of dog breeds(requirement #1)
and the search screen(requirement #2).

For each requirement:
1. You should be able to move from a list view into a grid view and take use of pagination.
  * Should be able to order alphabetically.
  * Should show only the dog breed image and the name.
  * Pressing on one of the list elements, should go to the details view (requirement #3)
2. The screen should:
  * Show a Search Bar where you can search by breed name
  * Show the list of results with the following Info per element:
    + Breed Name
    + Breed Group
    + Origin
3. Pressing one of the elements should go to the details view (requirement #3)
4. The detail view should contain the following info:
* Breed Name
*  Breed Category
*  Origin
*   Temperament

### BONUS POINTS
1. Unit tests coverage
2. Offline functionality
3. Error Handling

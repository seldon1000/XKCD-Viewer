# XKCD-Viewer
Simple yet cool XKCD Viewer, built entirely in SwiftUI.
  
<p align="center">
  <img src="https://img.shields.io/static/v1?label=XCode Version&message=13&color=blue" />
  <img src="https://img.shields.io/static/v1?label=Swift Version&message=5&color=blue" />
  <img src="https://img.shields.io/static/v1?label=UI Framework&message=SwiftUI&color=blue" />
  <img src="https://img.shields.io/static/v1?label=Built for&message=iOS 15&color=blue" />
  <img src="https://img.shields.io/static/v1?label=Tested on&message=iPhone 11&color=blue" />
</p>

## Screenshots
<img width=200 src="https://user-images.githubusercontent.com/55358113/168466948-19beeb89-da02-4482-ae45-f5a8708d1fd7.png" /> <img width=200 src="https://user-images.githubusercontent.com/55358113/168466952-a907ce22-d220-444e-afd9-fb702d12a006.png" /> <img width=200 src="https://user-images.githubusercontent.com/55358113/168466957-a6184d62-1e3f-45cd-b7f4-548f25723b08.png" /> <img width=200 src="https://user-images.githubusercontent.com/55358113/168466959-ee18e6ce-3f1b-4196-b022-a592c8ee8de9.png" />

## Overview
This little project is my attempt at completing a code challenge. The challenge asked to build a minimum viable product, capable of browsing comics from the XKCD website. The challenge granted total freedom of choice for platform, language and frameworks. I decided to build my XKCD Viewer using Swift & SwiftUI, for iOS 15.
The feature list is down below:

- [x] browse through the comics,
- [x] see the comic details, including its description,
- [ ] search for comics by the comic number as well as text,
- [ ] get the comic explanation
- [x] favorite the comics, which would be available offline too,
- [x] send comics to others,
- [ ] get notifications when a new comic is published,
- [x] support multiple form factors.

Even though the challenge goal is to prioritize the implementation of these features, and do as much as possible in a maximum of 16 hours of work, I also decided to play a bit with a custom navigation system, in order to implement a nice looking UI with a cool and intuitive UX, since I feel quite comfortable using the SwiftUI framework.

I ended up using approximately 14 hours, and a good amount of them was just about fixing bugs.

## Development
I had never heard of XKCD website, and I had very few experience with Swift HTTP requests handling, so the first hour was just about playing with XKCD API: URLs, requests, responses, JSON encode/decode and so on. I had already worked with HTTP request and JSON data handling in one of my previous personal projects (a cloud based password manager for Android devices), so it was pretty easy understanding what to do.

My main concern was writing clean and efficient code. I used Swift's concurrency tools to reduce workload on the main thread as much as possible. Every network request is done in a background task, as well as the JSON data handling. Once the data is fully ready, the main thread is called to make the changes final and update the UI accordingly.

Reading the text above, it's quite easy to guess that I've used some sort of view/model pattern. SwiftUI makes it quite natural to structure your codebase using an MVVM architecture, using tools like StateObject, ObservableObject and EnvironmentObject. There is a complete separation from data and UI management, making the codebase easier to work with and to expand further.

I spent most of the time working on the UI/UX. My navigation implementation took some hours to reach a usable state (more info in the next section).

Last couple of hours were used to do a great refactor: optimizing sensible operations, deleting useless code, fixing indentation and name convention... This is probably the most boring part of a coder's life, but also the most satisfying.

For specific details, you can refer to comments inide the code. There are tons of them and are pretty explanatory.

## Navigation System
It's so easy to build native looking applications in SwiftUI, since it offers several predefined tools and views anyone can use without effort. Well, I decided to play a bit with custom ideas. I decided not to use NavigationView/NavigationLink or sheet/fullScreenCover predefined patterns. Instead, I wanted to build a more minimal UI with a cooler UX. So I built a custom navigation system from scratch which works with a bottom toolbar.

Since the app is pretty simple, there's no need to have a full navigation stack, so there are just a current and a previous navigation page, with two function: one to navigate to a page, and the other to simply pop back.

The bottom toolbar has some cool features:

- Dynamic central title and info;
- Dynamic action buttons;
- Tap to automatically scroll at the start of the comic list;
- Hold the central title to navigate to different page.

## And now?
One thing I would like to implement is the search feature, which would be challenging since I would have to investigate how to make it blend with my current design and navigation system.

Also, I use UserDefaults to store favourites, including their fully loaded images offline. This works but gave me so many headackes during the development, so using a nicer and more powerful solution (CoreData?) could be a good point. An actuall error handling system would also be a great idea.

Finally, the app is still a bit ugly, I could use the help of a designer to style it better, and it still needs some testing, cause bugs are always somewhere to be found.

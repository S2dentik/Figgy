# Figgy

Giphy API based gifs displaying app.

All the code has been written by hand, mostly without checking any external resources. No code has been copied. Even though I wrote protocols like `StoryboardInstantiable` and `Identifiable` before, I wrote them again. Although I love Rx, and added it as a dependency at first, I don't think pros would counterweight cons for such a small project, so I left it out. For an example of a similar project I wrote using Rx see [Veil](https://github.com/s2dentik/Veil).

## Overview
* **.gif/.mp4/.webp** - As far as I know gifs are pretty battery consuming because of the way they are encoded, as they are mostly made of raw images. This is why a simple `AVPlayer` sounds like it'd do the job with `.mp4` files. As for `.webp`, they are not supported by `AVPlayer` as far as I know, so I left this choice out.
* **Architecture** - Although I personally prefer a hybrid between MVVM and VIPER, it sounded like an overkill for such a small project so I went with a simple MVP.
* **Dependency injection** - For small objects like `Fetcher` that only perform small task, I usually simply inject them, rather than make them globally available to everyone. For objects like `Network` that are used by almost everyone I usually write a God object called `AppEnvironment`, but here it sounded like an overkill too.
* **IB** - Usually I like to have my layout in the XIBs(for cells and other views) / Storyboards(for view controllers), and all of the other UI related setup like setting a font or color in code. Here, to save time, I set some flags using IB.

## // TO-DOs
* The app requires more tests. I wrote the code as testable as I could, and provided a strong foundation and some tests of how I would proceed with testing. Everything is testable, from small services and helpers to the view models, everything except the view controller. For that I would have to write some snapshot tests, but I don't think it's critical now.

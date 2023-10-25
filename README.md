# Simple Book Search App with Swift Concurrency

This is a simple app that displays the top ten results of a call to the OpenLibrary book search API. The app was created to showcase the use of a `UICollectionView` with the new Swift concurrency.

<div align="center">
  <video width="250" height="275" src="https://github.com/dman-github/BookSearch/assets/18173068/90672a8a-5fc1-44fb-9836-bbfcc8b305a5" frameborder="0" allowfullscreen></video>
</div>

## Features

- **CollectionView**: The app utilizes a `UICollectionView` to display information about the books returned in the search results. Each cell in the collection view includes details such as the book cover image and author information. The cover image is downloaded asynchronously, as it is a time-consuming task.

- **Caching**: All search results are cached in 'CoreData' with the search term to allow for faster retrieval of matching searches in subsequent requests. Images are cached in 'NSCache'

- **Architecture**: The app follows the MVVM (Model-View-ViewModel) architectural pattern. The `UICollectionView` on the ViewLayer observes changes to the data model using RxSwift. There is a repository layer responsible for fetching data from the network or cache, the repository is owned by the view model.

- **Async/Await Pattern**: The project uses the Async/Await pattern to improve code readability and avoid passing completion closures across domain boundaries. This pattern is particularly useful in complex code.

- **Parallel Processing**: The app uses the `async let` when parallel processing is required. Cached data and network data retrieval occur in parallel, but the cached data is always "awaited" first, followed by the networked data.

- **MainActor Attribute**: The `MainActor` attribute is used to ensure that code related to the View is executed on the main queue. This attribute replaces the old-style GCD (Grand Central Dispatch) calls to the main dispatch queue in many places.

This app demonstrates how to build a responsive and efficient book search application with Swift concurrency.




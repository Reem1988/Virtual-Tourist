# Virtual-Tourist-Reem-
The Virtual Tourist app downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.
VirtualTourist is the final project for [iOS Developer Nanodegree](https://www.udacity.com/course/ios-developer-nanodegree--nd003) Program in Udacity.
### Overview
The Virtual Tourist app downloads and stores images from [Flickr](https://www.flickr.com). The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.
### Requirements
It was built using :
- Xcode Version 10.2 
- Swift 4.
 - IOS 11.
 ### Libraries
 - MapKit,CoreData
 ## Description App 
 ### The app have two view controller :
- Map View : Allows the user to drop pins around the world
- Photo Album View : Allows the users to download and edit an album for a location
#### Map View 
 <img width="464" alt="Screen Shot 1441-04-23 at 7 24 59 PM" src="https://user-images.githubusercontent.com/47195049/71269205-cd36b000-235f-11ea-84c7-073faf0ded46.png">
 When the app first starts it will open to the map view.Users will be able to zoom and scroll around the map using standard pinch and drag gestures.<br/><br/> 
The center of the map and the zoom level should be persistent. If the app is turned off, the map should return to the same state when it is turned on again.<br/><br/>
Tapping and holding the map drops a new pin. Users can place any number of pins on the map.
When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.<br/><br/>
 <b> Edit pins screen to delete existing pins of tourist locations: <b>
<img width="464" alt="Screen Shot 1441-04-23 at 8 09 28 PM" src="https://user-images.githubusercontent.com/47195049/71272820-c2cae500-2364-11ea-8934-313d7682257e.png">

#### Photo Album View 

<img width="464" alt="Screen Shot 1441-04-23 at 7 25 30 PM" src="https://user-images.githubusercontent.com/47195049/71270439-9f9f3600-2362-11ea-9bf4-0f085b1ad0fd.png"><br/>

If the user taps a pin that does not yet have a photo album, the app will download Flickr images associated with the latitude and longitude of the pin.<br/><br/>
If no images are found a “No Images” label will be displayed.
If there are images, then they will be displayed in a collection view.<br/>
While the images are downloading, the photo album is in a temporary “downloading” state in which the New Collection button is disabled.<br/><br/>
Once the images have all been downloaded, the app enable the New
Collection button at the bottom of the
page. Tapping this button empty the photo album and fetch a new set of images.
Users able to remove photos from an album by tapping them. Pictures will flow up to fill the space vacated by the removed photo.Tapping the back button return the user to the Map view.<br/>

 
### Features
  - Downloading data from network resources [Flickr API](https://www.flickr.com/services/api/).
 - Building polished user interfaces with UIKit components.
- Store media on the device file system Use Core Data
 - Using MapKit.
### New Features!

  - The ability to delete Pin
  

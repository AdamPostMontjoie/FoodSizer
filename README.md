Temporary architectural notes
- 
Rendering of Scenes
- 
 The .merge in the ScanReviewFeature reducer kicks off two .runs that await the extraction of the face and object nodes in the background by handing them the urls. These scan nodes, when they are extracted from storage and unwrapped from the usdz files, are sent by the reducer back to the main thread. The reducer then saves that pointer to state, which lets the UIViewRepresentable know that it's time to create a new scene. The UIViewRepresentable then creates a new scene and adds the node and a camera, and lets ScanReviewFeature know it's ready to be displayed. At that point, the loading spinner for the scan is replaced with the UIViewRepresentable. We also attach a cancelable id to the pointers to the scenes, and we destroy all UIViewRepresentables and Scenes rendered or currently rendering on disappear.

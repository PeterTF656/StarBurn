// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract StarBurn {
    string public name = "StarBurn";

//image counter
   uint public imageCount = 0;
    //mapping images to indexes
    mapping (uint => Image) public images;
    // mapping (uint => Post) public posts;

    //struct types
    struct Image {
        uint id;
        string hash;
        string description;
        uint tipAmount; 
        address payable author;
    } 

    struct Post {
        uint id;
        uint hash;
        string title;
        string body;
        uint tipAmount;
        Image postImage;
        address payable author;
    }

    //event emitted when an image is created 
    event ImageCreated(
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
    ); 

    //CRUD posts
    //create a new image -> next get dynamic image id using a counter
    function uploadImage(string memory _imageHash, string memory _imageDescription) public {
        imageCount ++;
        images[imageCount] = Image(imageCount, _imageHash, _imageDescription, 0, payable (msg.sender)); //ignore warning...
    } 
    //reward posts (interactions)

    
}
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract StarBurn {
    string public name = "StarBurn";

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

    //CRUD posts
    //create a new image -> next get dynamic image id using a counter
    function uploadImage() public {
        images[1] = Image(1, 'abc123', 'something', 0, address(0x0));
    } 
    //reward posts (interactions)

    
}
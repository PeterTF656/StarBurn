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

    event ImageTipped(
        uint id,
        string hash,
        string description,
        uint tipAmount,
        address payable author
  );

    //CRUD posts
    //create a new image -> next get dynamic image id using a counter
    function uploadImage(string memory _imageHash, string memory _imageDescription) public {

        //add a content check using require(); _imageHash, _imageDescription and sender address should be non-empty

        require(bytes(_imageHash).length > 0, 'Fatal: blank image');

        //
        require(bytes(_imageDescription).length > 0, 'Fatal: blank description');

        //
        require(msg.sender != address(0x0), 'Fatal: blank image');

        //
        imageCount ++;
        //add image to contract
        images[imageCount] = Image(imageCount, _imageHash, _imageDescription, 0, payable (msg.sender)); //ignore warning...
        //Trigger an event
        emit ImageCreated(imageCount, _imageHash, _imageDescription, 0, payable (msg.sender));
    } 
    //reward posts (interactions) ** tip image owner
    function tipImageOwner(uint _id) public payable {
    //need to tip in range
    require(_id>0 && _id <= imageCount, 'the image tipped not exist');
    //fetch image to local variable
     Image memory _image = images[_id];   
     // payable address of author
     address payable _author = _image.author;
     //send the amount of tips
     _author.transfer(msg.value);
    // showing total amount of tips
    _image.tipAmount += msg.value;
    //update image info
    images[_id] = _image;
    // Trigger an event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);  
    }
 
}
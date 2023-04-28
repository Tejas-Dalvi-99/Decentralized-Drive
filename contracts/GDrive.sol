// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GDrive {
    struct Access{
        address user; 
        bool HaveAccess; 
    }

    mapping(address=>string[]) Files;  // Mapping to store URL of Images/files
    mapping(address=>mapping(address=>bool)) ownership;  // Nested mapping For giving Access to other Users, nested mapping workd like 2D array
    mapping(address=>mapping(address=>bool)) previousData; // Nested mapping to Keep previous data of Access to other users
    mapping(address=>Access[]) accessList;   // Mapping to Stpre List of People who have Access to yur Drive

    function UploadImage(address _user, string memory url) external{
        Files[_user].push(url);   // Pushing Our new Image/File URL in our Files Mapping
    } 

    function allowAccess(address user) external{       // function to Give Access to other Users
        ownership[msg.sender][user] = true;        // make ownership to true
        if(previousData[msg.sender][user]==true){  // check if previously we have given and revoked access to that user or or not from previousData mapping
             for(uint i=0; i<accessList[msg.sender].length; i++){  // iterate for loop for as many time as no of people having access for that particular msg.sender  
                if(accessList[msg.sender][i].user == user){  // if the user is found
                    accessList[msg.sender][i].HaveAccess = true;  // make access true again for that user 
                }
            }
        }
        else{
        accessList[msg.sender].push(Access(user, true));  // make HaveAccess true for that user in Access Struct
        previousData[msg.sender][user]==true;  // also update the previousData mapping to true for that user 
        }
    }

    function RevokeAccess(address user) public{       // function to revoke access from other users
        ownership[msg.sender][user]=false;      // nested mapping works like 2D array , revoke access from that user 
        for(uint i=0; i<accessList[msg.sender].length;i++){  // for loop to iterate for that particular msg.sender as many time as he have given access to how many people
            if(accessList[msg.sender][i].user == user){  // if the user is found then we will change his access to false
                accessList[msg.sender][i].HaveAccess=false; 
            }
        }
    }

    function Display(address _user) external view returns(string[] memory){  //function to display the images/files for your own or that user who's address we are passing
        require(_user == msg.sender || ownership[_user][msg.sender] == true,"You Don't Have Access to these Files" ); // we check that if the user is the current logged in user or if the user is granted Access by that person who's Address he is passing
        return Files[_user]; 
    }

    function DisplayAccessList() public view returns(Access[] memory){  // function to display the address of users with whom we have shared our drive 
        return accessList[msg.sender];   // return the accesslist for the User who is calling this function 
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "contracts/NewYearPromise.sol";
contract MakePromise{
    address owner=msg.sender;
    mapping (address=>NewYearPromise) promiseMap;
    event newPromise(address promiseAddress);
    function makePromise(string memory promiseName,string memory description,uint amountToParticipate,uint maxMistakes)public {
        NewYearPromise nyp=new NewYearPromise(promiseName,description,amountToParticipate,maxMistakes);
        promiseMap[nyp.getAddress()]=nyp;
        emit newPromise(nyp.getAddress());
    }
    //this may also be doable with the child contract directly
    // function joinPromise(address promiseAddress) public payable{
    //     try promiseMap[promiseAddress].join(){//IT IS BETTER TO VALIDATE THE ADDRESS WITH THE APP


    //     }
    //     catch {


    //     }
    // }
    function validationCheck(address promiseAddress) public{
        require(msg.sender==owner);
        try promiseMap[promiseAddress].validationCheck(){


        }
        catch{


        }
    }
    function distributePromiseCash(address promiseAddress) public{
        require(msg.sender==owner);
        try promiseMap[promiseAddress].distribute(){


        }
        catch{


        }
    }
}


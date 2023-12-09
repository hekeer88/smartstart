// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract NewYearPromise{
    string promiseName;
    string description;
    uint creationTime;
    uint endTime;
    address owner;
    mapping(address=>bool) isParticipant;
    address[] participants;
    mapping(address=>uint) finalBalance;
    uint totalBalance;
    uint participantCount;
    uint requiredAmountToParticipate;
    mapping(address=>uint) addressMistakes;
    uint maxMistakes;
    constructor(string memory _promiseName,string memory _desc, uint _requiredAmountToParticipate, uint _maxMistakes){
        promiseName=_promiseName;
        description=_desc;
        creationTime=block.timestamp;
        endTime=creationTime+31536000;
        owner=msg.sender;//NOT SURE ABOUT THIS ONE(CURRENTLY THE OWNER IS THE PARENT CONTRACT)
        totalBalance=0;
        participantCount=0;
        requiredAmountToParticipate=_requiredAmountToParticipate;
        maxMistakes=_maxMistakes;
    }
    function getAddress() view public returns(address){
        return address(this);
    }
    function getTotalBalance() view public returns(uint){
        return totalBalance;
    }
    function getParticipantCount() view public returns(uint){
        return participantCount;
    }
    function getDescription() view public returns(string memory){
        return description;
    }
    function join() external payable {
        address sender=msg.sender;
        uint msgValue=msg.value;
        require(msgValue==requiredAmountToParticipate,"Everyone needs to deposit the same value");
        require(isParticipant[sender]==false, "Each address can join only once");
        participants.push(sender);
        isParticipant[sender]=true;
        participantCount+=1;
        totalBalance+=msgValue;
    }
    function removeParticipant(address participant) private {
        isParticipant[participant]=false;
        participantCount-=1;
    }
    function distribute() external payable {
    require(msg.sender==owner,"only parent contract can do this");//DISTRIBUTED BY THE PARENT CONTRACT ONLY?
    //require(block.timestamp>=endTime,"this function can only be called after the promise end time");
    //DISABLED FOR TESTING
    require(participants.length > 0, "No participants");
    require(totalBalance > 0, "No balance to distribute");
    uint amountToSend = totalBalance * 100 / participants.length / 100;
    require(amountToSend > 0, "Amount to distribute is zero");
    for (uint i = 0; i < participants.length; i++) {
        address payable participant = payable(participants[i]);
        if (isParticipant[participant]) {
            // Ensure that the transfer is successful
            require(participant.send(amountToSend), "Transfer failed");
        }
    }
   
    }
    struct Validation{
        bool isValidated;
        address[] validators;
    }
    mapping(address => Validation) participantValidation;
 
    function validateParticipant(address participant) external  {
        //require(msg.sender==owner,"only parent contract can do this");
        address sender=msg.sender;
        require(isParticipant[sender],"you are not a participant");
        require(isParticipant[participant],"destination address is not a participant");
        for (uint i = 0; i < participantValidation[participant].validators.length; i++) {
            if (participantValidation[participant].validators[i] == sender) {
                return;
            }
        }
        participantValidation[participant].validators.push(sender);
        if (participantValidation[participant].validators.length == participantCount) {
            participantValidation[participant].isValidated = true;
        }
    }
    function validationCheck() external  {//IS CALLED BY THE PARENT CONTRACT ONCE A WEEK/MONTH/OTHER PREDETIRMINED TIME
        require(msg.sender==owner,"only parent contract can do this");
        for(uint i=0;i<participants.length;i++){
            address participant=participants[i];
            if(participantValidation[participant].isValidated)//CLEANS THE VALIDATION STRUCT IN PREPARATION FOR NEXT WEEK
            {
                participantValidation[participant].isValidated=false;
                delete participantValidation[participant].validators;
            }
            else{
                addressMistakes[participant]+=1;
                if(addressMistakes[participant]>maxMistakes)
                {
                    removeParticipant(participant);
                }
            }
        }
    }
}



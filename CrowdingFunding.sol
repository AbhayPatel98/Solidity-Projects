// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

contract CrowdFunding {
        address public owner;
        mapping (address => uint) public funders;
        uint public goal;
        uint public miniAmount;
        uint public noOfFunders;
        uint public fundsRaised;
        uint public timePeriod; //timestamp

        constructor (uint _goal, uint _timeperiod) {
            goal = _goal;
            timePeriod = block.timestamp + _timeperiod;
            owner = msg.sender;
            miniAmount = 1000 wei;
        }

        function Contribution() public payable {
            require(block.timestamp < timePeriod, "funding time is over!");
            require(msg.value>= miniAmount, "Minimum amount criteria not satisfy");

            if(funders[msg.sender]== 0){
                noOfFunders++;
            }

            funders[msg.sender]+= msg.value;
            fundsRaised += msg.value;
        }

        receive () payable external {
            Contribution();
        }

        function getRefund() public {
            require(block.timestamp>timePeriod, "funding is still on!");
            require(fundsRaised<goal, "funding was successful");
            require(funders[msg.sender]>0, "Not a funder");

            payable(msg.sender).transfer(funders[msg.sender]);
            fundsRaised-= funders[msg.sender];
            funders[msg.sender] = 0;
        }

        struct Request {
            string description;
            uint amount;
            address payable receiver;
            uint noOfVoters;
            mapping(address=>bool) votes;
            bool completed;
        }

        mapping(uint=>Request) public AllRequest;
        uint public numReq;

        modifier isOwner() {
            require(msg.sender==owner, "You are not the owner");
            _;
        }

        function CreateRequest(string memory _description, uint _amount, address payable _receiver) public isOwner {
            Request storage newRequest = AllRequest[numReq];
            numReq++;

            newRequest.description = _description;
            newRequest.amount = _amount;
            newRequest.receiver = _receiver;
            newRequest.completed = false;
            newRequest.noOfVoters = 0;

        }

        function VotingForRequest(uint reqNum) public{
            require(funders[msg.sender]>0, "Not a funder");
            Request storage thisRequest = AllRequest[reqNum];
            require(thisRequest.votes[msg.sender]==false, "already voted");
            thisRequest.votes[msg.sender]= true;
            thisRequest.noOfVoters++;
        }

        function makePayment(uint reqNum) isOwner public{
            Request storage thisRequest = AllRequest[reqNum];
            require(thisRequest.completed==false, "completed");
            require(thisRequest.noOfVoters>=noOfFunders, "voting not in favour");
            thisRequest.receiver.transfer(thisRequest.amount);
            thisRequest.completed=true;

        }
}
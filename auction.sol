// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;   

struct Bidder{            //Bidder information
         string name;
         uint age;
         address payable account;
         uint balance;
        
 
     }
contract AUCTION {
    address payable public auctioneer;
    //bidder information
    Bidder public bidder;
    //setTime interval
    uint public startTimeBlock; // 1 hour auction time period(1 min = 4blocks, 1 hour*4=240blocks)
    uint public endTimeBlock;
    //auction states
    enum AuctionState {Started, Running, Ended, Cancelled} //
    AuctionState public auctionstate;

    uint public highestPayableBid;
    uint public bidIncrement;

    address payable public highestBidder; //Receive money from bidder

    mapping (address=>uint) public bids;
    Bidder[] public bidders;
   

    constructor () {
        auctioneer = payable (msg.sender);
        auctionstate =  AuctionState.Running;
        startTimeBlock = block.number;
        endTimeBlock = startTimeBlock + 240;
        bidIncrement = 1 ether;
        
    }
       
       modifier notOwner() {
       require(msg.sender != auctioneer, "owner can not bid"); 
       _;
       }
        modifier Owner() {
       require(msg.sender == auctioneer, "owner can not bid"); 
       _;
        }
         modifier Started() {
       require(block.number>startTimeBlock); 
       _;
         }
         modifier beforeEnding() {
       require(block.number<endTimeBlock); 
       _;
         }

         function CancelAuc() public Owner{
          auctionstate = AuctionState.Cancelled; 
         }

         //BidderInformation
         
         function bidderInfo() payable public {
            Bidder memory bidder1 = Bidder ({name:"abhay", age:23, account:payable (msg.sender), balance:msg.value});
            bidders.push(bidder1);

         }
           
           function EndAuc() public Owner{   //succesfully run and end.
                auctionstate = AuctionState.Ended; 
         } 

          function minimum(uint a, uint b) private pure returns(uint) {
            if (a<=b)
            return a;
            else
            return b;
        }

        function bid() payable public notOwner Started beforeEnding{
            require(auctionstate == AuctionState.Running, "Not in running state");
            require(msg.value>=1 ether, "value is not getter than and not equal to 1"); //minimum bid
        
        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid>highestPayableBid);
        bids[msg.sender] = currentBid;
        if(currentBid<bids[highestBidder]) {
            highestPayableBid = minimum(currentBid+bidIncrement, bids[highestBidder]);
        } else {
            highestPayableBid = minimum(currentBid, bids[highestBidder]+ bidIncrement);
            highestBidder = payable (msg.sender);
        }
        }
          function finalizeAuction() public {
              require(auctionstate == AuctionState.Cancelled||auctionstate == AuctionState.Ended|| block.number>endTimeBlock);
              require(msg.sender == auctioneer|| bids[msg.sender]>0);

          address payable person;

          uint value;

          if (auctionstate == AuctionState.Cancelled) {
              person = payable (msg.sender);
              value = bids[msg.sender];
          }
          else if (msg.sender == auctioneer){
               person = auctioneer;
              value = highestPayableBid;
          }
              else if (msg.sender == highestBidder) {
                  person = highestBidder;
                  value = bids[highestBidder] - highestPayableBid;
              }
              else {
                  person = payable (msg.sender);
                  value = bids[msg.sender];
              }
            
            bids[msg.sender] = 0;
            person.transfer(value);
   }
}   

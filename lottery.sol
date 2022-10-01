// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;    

contract Lottery{               
    address public manager ;
    address payable[] public players;

    constructor (){
        manager = msg.sender;   //set Manager 
    }

    function alreadyEntered() view private returns (bool) {
        for (uint i=0;i<players.length;i++){
            if (players[i] == msg.sender)
            return true;
        }
        return false;
    }


    function enter() payable public {

        require(msg.sender!= manager, "manager can't enter "); //Manager Can not Enter to the lottery.
        require(alreadyEntered() == false, "player already entered");  //player can not enter twice.   
        require (msg.value >= 1 ether, "Minimun amount to get entry"); //minimun amount must be payed.
        players.push(payable(msg.sender));
    }

    function random () view private returns(uint){
        return uint (sha256(abi.encodePacked(block.difficulty, block.number,players)));
    }


    function pickWinner() public {
        require (msg.sender == manager, "only pick winner"); //manager can only pick winner.
        uint index = random()%players.length; //Winner Player index.

        players[index].transfer(address(this).balance); //transfer winning amount.
        players = new address payable[](0); //clear previous data //Reset lottery
    }

   function getplayers() view public returns (address payable[] memory){

       return players;
   }
       

    
}


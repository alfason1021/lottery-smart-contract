// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    // declaring state variables
    address payable[] public players; // dyna,ic array of type address payable.
    address public manager;

    constructor() {
        // initializing the manager that deploys the contract
        manager = msg.sender;
    }

    // the receive function ensures the contract receives eth
    receive() external payable {
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));
    }

    // to return the contract balance only by the manager in wei
    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    // helper function that returns a large random integer
    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager); // for only manager to pick winner when players is more than 3
        require(players.length >= 3);

        uint r = random();
        address payable winner;

        uint index = r % players.length; // getting a random index of the array

        winner  = players[index]; // winner

        winner.transfer(getBalance()); // transferring the balance to the winner

        players = new address payable[](0); // reset the lottery for next round.
    }
}

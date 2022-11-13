
// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.10;

import { DSTest } from 'ds-test/test.sol';
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract User{}

contract Token is ERC20("My Token", "BI", 18){
    function mintTo(address to, uint256 amount) public payable{
        _mint(to, amount);
    }
}

contract TestReceiver is FlashBorrower, DSTest{


}


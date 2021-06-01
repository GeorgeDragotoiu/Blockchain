// SPDX-License-Identifier: Unlincensed
pragma solidity 0.8.4;

import '../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract BEP20_Token is ERC20 {
    constructor()
    ERC20('BEP20_Token', 'BTK')
     {
         _mint(msg.sender, 1000000 * 10 ** decimals());
     }    
        
    }


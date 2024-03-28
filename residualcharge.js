//create an ethereum smart contract that charges 10 percent residual on each sales transaction, out of the 10 percent charge, that residual is then divided and paid to every seller on the blockchain 

pragma solidity ^0.8.0;

contract ResidualCharge {
    mapping (address => uint) balances;
    mapping (address => bool) sellers;
    address payable owner;
    uint residualCharge = 10;

    constructor() public {
        owner = msg.sender;
    }

    function registerSeller(address payable _seller) public {
        require(msg.sender == owner);
        sellers[_seller] = true;
    }

    function unregisterSeller(address payable _seller) public {
        require(msg.sender == owner);
        sellers[_seller] = false;
    }

    function makeSale(address payable _seller, uint _value) public payable {
        require(sellers[_seller] == true);
        uint residual = _value * (residualCharge / 100);
        _seller.transfer(residual);
        distributeResidual(residual);
    }

    function distributeResidual(uint _residual) private {
        for (address payable seller in sellers) {
            if (sellers[seller]) {
                uint share = _residual / address(this).balance;
                seller.transfer(share);
            }
        }
    }
}

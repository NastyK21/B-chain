        
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./priceconv.sol";

error NotOwner();

contract FundMe {


    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    
    address public  i_owner;
    
    
    constructor() {
        i_owner = msg.sender;
    }

    
    bool p=true;
    function fund() public payable {
      
        addressToAmountFunded[msg.sender] += msg.value;
       
        for(uint i=0;i<funders.length;i++)
        {
            if(msg.sender==funders[i])
            { 
                p=false;

            }
        }
        if(p)
        {
        funders.push(msg.sender);
        }
        

    }
    function  changeowner( address newowner) public  {
        i_owner=newowner;

    }
    
    
    
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}

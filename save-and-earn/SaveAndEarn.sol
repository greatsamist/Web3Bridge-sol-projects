// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* A contract where people save and earn +15% of total deposit after 6 months.
 */

contract SaveAndEarn {
    struct SAE{
        address[] savers;
        uint deposit;
        uint savingPeriod;
        uint interest;

        mapping (address => uint) saversTotalBalance;
    }

    struct SAEWITHOUTBALANCE{
        address[] savers;
        uint deposit;
    }


    mapping (uint => SAE) SAES;

    uint saversIndex = 0;
    address owner = msg.sender;

    constructor(address _owner) payable{
        owner = _owner;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only owner");
        _;
    }

    // Function to join the save and earn programme.
    function joinSAE() external payable returns(bool sucess){
        saversIndex++;
        SAE storage storeSAE = SAES[saversIndex];
        storeSAE.savers.push(msg.sender);
        // The fixed saving period will be 6 months.
        storeSAE.savingPeriod = block.timestamp + 180 days;  // 
        storeSAE.deposit = storeSAE.saversTotalBalance[msg.sender] += msg.value;
        storeSAE.interest = (storeSAE.deposit / 100) * 15;
        sucess = true;

    }

    // Check balance for single user
    function checkBalance(uint Id) external view returns(uint){
        SAE storage storeSAE = SAES[Id];
        // return storeSAE.saversTotalBalance[_address];
        return storeSAE.deposit;
        
    }

    // User withdrawal function
    function withdrawSAE(address _address, uint Id) public {
        SAE storage storeSAE = SAES[Id];
        require(block.timestamp >= storeSAE.savingPeriod, "saving not ripe");
        require(_address == msg.sender, "not owner");

       payable(_address).transfer(storeSAE.deposit + storeSAE.interest);
        // resetting user balance to zero after succesful withdrawal
        storeSAE.deposit = 0;

    }

    // Check users plus balance
    function saeTotBal(uint[] memory _id) external view onlyOwner returns(SAEWITHOUTBALANCE[] memory SAEBal){
      SAEBal = new SAEWITHOUTBALANCE[](_id.length);
        for(uint i = 0; i < _id.length; i++){
             SAE storage storeSAE = SAES[_id[i]];
            SAEWITHOUTBALANCE memory cc = SAEBal[i];
            cc.savers = storeSAE.savers;
            cc.deposit = storeSAE.deposit;
        }
    }

    // Check contract balance
    function checkConBal() external view onlyOwner returns(uint){
        return address(this).balance;
    }

}
pragma solidity ^0.4.10;

//Selling a fixed number of tickets 
contract Conference{

  address public organizer;
  mapping (address => uint) public registrantsPaid;
  uint public numRegistrants;
  uint public quota;

  // Log transactions
  event Deposit(address _from, uint _amount); 
  event Refund(address _to, uint _amount);
  
  //Set limit and initialize count
  function Conference(){
    organizer = msg.sender;
    quota = 100;
    numRegistrants = 0;
  }
  
  //Purchase tickets
  function buyTicket() public returns (bool success){ 
    if (numRegistrants >= quota){
        return false;
    }
    registrantsPaid[msg.sender] = msg.value;
    numRegistrants++;
    Deposit(msg.sender, msg.value);
    return true;
  }
  
  // Change limit
  function changeQuota(uint newquota) public{
    if (msg.sender != organizer){
        return;
    }
    quota = newquota;
  }
  
  //Refund tickets
  function refundTicket(address recipient, uint amount) public{
    if (msg.sender != organizer){
        return;
    }
    if (registrantsPaid[recipient] == amount){
      address myAddress = this;
      if (myAddress.balance >= amount){
        recipient.send(amount);
        registrantsPaid[recipient] = 0;
        numRegistrants--;
        Refund(recipient, amount);
      }
    }
  }
  
  //Send funds back to organizer
  function destroy(){
    if (msg.sender == organizer){
      suicide(organizer);
    }
  }
}

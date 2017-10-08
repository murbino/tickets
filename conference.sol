pragma solidity ^0.4.10;

//Manny Urbino
//October 7, 2017
//Contract for a conference where registrants can buy tickets, and the
//organizer can set a maximum quota of attendees as well as provide refunds.

//Sell a fixed number of tickets 
contract Conference{

  address public organizer;
  mapping (address => uint) public registrantsPaid;
  uint public numRegistrants;
  uint public quota;

  // Log transactions
  event Deposit(address _from, uint _amount); 
  event Refund(address _to, uint _amount);
  
  //Set ticket limit and initialize count
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
  
  // Change ticket limit
  function changeQuota(uint newquota) public{
    if (msg.sender != organizer){
        return;
    }
    quota = newquota;
  }
  
  //Refund Payment
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
  
  //Send funds back to organizer and make contract unusable
  function destroy(){
    if (msg.sender == organizer){
      suicide(organizer);
    }
  }
}

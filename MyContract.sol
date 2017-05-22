pragma solidity ^0.4.4;

// This is a simple contract that keeps track of balances and allows withdrawals only after a week from the deposit.
// 1. In your opinion, does withdraw() function work as expected?
// 2. Implement the missing deposit() function that will allow only a single deposit from any address

contract MyContract {
  mapping (address => uint) balances;
  mapping (address => uint) deposits;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  function withdraw(uint amount) returns(bool) {
    uint depositTime = deposits[tx.origin];
    uint balance = balances[tx.origin];

    if (now > depositTime + 7 days) {
      return false;
    }
    if (balance <= amount) return false;

    if(msg.sender.call.value(balance)()) {
      balances[msg.sender] -= amount;
    }

    Transfer(this, msg.sender, amount);
    return true;
  }

}
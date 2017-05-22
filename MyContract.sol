pragma solidity ^0.4.4;

// This is a simple contract that keeps track of balances and allows withdrawals only after a week from the deposit.
// 1. In your opinion, does withdraw() function work as expected?
// 2. Implement the missing deposit() function that will allow only a single deposit from any address

contract MyContract {
  mapping (address => uint) balances;
  mapping (address => uint) deposits;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  function withdraw(uint amount) returns(bool) {
    // tx.origin will be deprecated with the release of Serenity
    // https://ethereum.stackexchange.com/questions/196/how-do-i-make-my-dapp-serenity-proof
    // let's use msg.sender instead
    uint depositTime = deposits[msg.sender];
    uint balance = balances[msg.sender];

    if (now > depositTime + 7 days) {
      return false;
    }
    if (balance <= amount) return false;

    // We should decrease the balance first, to avoid vulnerability to recursive calls
    balances[msg.sender] -= amount;
    // Also it's safer to use send() for sending ether instead of call.value()()
    // Little amount of gas provided won't let the receiver do any other calls upon receiving the send
    if (msg.sender.send(balance)) {
      Transfer(this, msg.sender, amount);
      return true;
    } else {
      // If sending fails, we'll just revert the user's balance to what it previously was
      balances[msg.sender] = balance;
      return false;
    }
  }

  function deposit() payable returns(bool) {
    // Making sure there is only one deposit from any address
    if (deposits[msg.sender] > 0) {
      return false;
    }
    // Recording the deposit
    deposits[msg.sender] = now
    balances[msg.sender] = msg.value
    Transfer(msg.sender, this, msg.value);
    return true;
  }

}
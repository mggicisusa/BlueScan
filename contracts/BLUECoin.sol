pragma solidity ^0.4.4;

//
// BLUECoin
// Welcome To The Future of CryptoCurrency
//

import './BasicToken.sol';
import './Ownable.sol';

contract BLUECoin is StandardToken, Ownable {

  string public constant name = "Ethereum Blue";
  string public constant symbol = "BLUE";
  uint8 public constant decimals = 8;

  uint256 public constant SUPPLY_CAP = 42000000 * (10 ** uint256(decimals));

  address NULL_ADDRESS = address(0);

  uint public nonce = 0;

  event NonceTick(uint nonce);
  function incNonce() {
    nonce += 1;
    if(nonce > 100) {
        nonce = 0;
    }
    NonceTick(nonce);
  }

  // Note intended to act as a source of authorized messaging from development team
  event NoteChanged(string newNote);
  string public note = "Welcome to the future of cryptocurrency.";
  function setNote(string note_) public onlyOwner {
      note = note_;
      NoteChanged(note);
  }
  
  event PerformingDrop(uint count);
  function drop(address[] addresses, uint256 amount) public onlyOwner {
    uint256 amt = amount * 10**8;
    require(amt > 0);
    require(amt <= SUPPLY_CAP);
    PerformingDrop(addresses.length);
    
    // Maximum drop is 1000 addresses
    assert(addresses.length <= 1000);
    assert(balances[owner] >= amt * addresses.length);
    for (uint i = 0; i < addresses.length; i++) {
      address recipient = addresses[i];
      if(recipient != NULL_ADDRESS) {
        balances[owner] -= amt;
        balances[recipient] += amt;
        Transfer(owner, recipient, amt);
      }
    }
  }

  /**
   * @dev Constructor that gives msg.sender all of existing tokens..
   */
  function BLUECoin() {
    totalSupply = SUPPLY_CAP;
    balances[msg.sender] = SUPPLY_CAP;
  }
}
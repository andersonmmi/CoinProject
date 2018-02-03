pragma solidity ^0.4.18;

import "./HadeCoin.sol";
import "./lib/SafeMath.sol";


/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a adminMultiSig
 * as they arrive. The contract requires a MintableToken that will be
 * minted as contributions arrive, note that the crowdsale contract
 * must be owner of the token in order to be able to mint it.
 */
contract HadeCrowdSale {

  using SafeMath for uint256;

  // The token being sold
  HadeCoin public token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTime;
  uint256 public endTime;

  // address where funds are collected
  address public adminMultiSig;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  // check if token is deployed and connected
  bool public isTokenDeployed = false;

  // check if crowd sale is active
  bool public isSaleActive = false;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  modifier onlyAdmin() {
      require(msg.sender == adminMultiSig);
      _;
  }

  function HadeCrowdSale() public {
    rate = 7500;
    adminMultiSig = msg.sender;
  }

  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }


  function setTokenAddress(address _tokenAddress)

  external
  onlyAdmin
  {
    require(isTokenDeployed == false && _tokenAddress != address(0));
    token = HadeCoin(_tokenAddress);
    isTokenDeployed = true;
  }

  // start sale
  function startSale(uint256 _days) external onlyAdmin {
      require(_days > 0);
      startTime = now;
      endTime = now + _days * 1 days;
      isSaleActive = true;
      assert(endTime > startTime);
  }

  // end sale
  function end() external onlyAdmin {
      if (now > endTime) {
          isSaleActive = false;
      }
  }

  // low level token purchase function
  function buyTokens(address _beneficiary) public payable {
    require(_beneficiary != address(0));
    require(_validPurchase());

    uint256 _weiAmount = msg.value;

    // calculate token amount to be created
    uint256 _tokens = _getTokenAmount(_weiAmount);

    // update state
    weiRaised = weiRaised.add(_weiAmount);

    token.transferFrom(adminMultiSig, _beneficiary, _tokens);
    _forwardFunds();
    
    TokenPurchase(msg.sender, _beneficiary, _weiAmount, _tokens);
  }

  // flush funds in case contract holds them
  function flush() public {
    adminMultiSig.transfer(this.balance);
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    return now > endTime;
  }

  // Override this method to have a way to add business logic to your crowdsale when buying
  function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
    return weiAmount.mul(rate);
  }

  // send ether to the fund collection adminMultiSig
  // override to create custom fund forwarding mechanisms
  function _forwardFunds() internal {
    adminMultiSig.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function _validPurchase() internal view returns (bool) {
    bool withinPeriod = now >= startTime && now <= endTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }

}

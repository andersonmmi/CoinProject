pragma solidity ^0.4.15;

import './helpers/BasicToken.sol';
import './lib/safeMath.sol';

contract HadeCoin is BasicToken {

    using SafeMath for uint256;

    /*
       STORAGE
    */

    // name of the token
    string public name = "HADE Platform";

    // symbol of token
    string public symbol = "HADE";

    // decimals
    uint8 public decimals = 18;

    // total supply of Hade Tokens
    uint256 public totalSupply = 150000000 * 10**18;

    // multi sign address of founders which hold
    address public adminMultiSig;


    /*
       EVENTS
    */

    event ChangeAdminWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);

    /*
       CONSTRUCTOR
    */
    function HadeCoin () public {

        adminMultiSig = msg.sender;
        balances[adminMultiSig] = totalSupply;
    }

    /*
       MODIFIERS
    */

    modifier nonZeroAddress(address _to) {
        require(_to != 0x0);
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == adminMultiSig);
        _;
    }

    /*
       FUNCTIONS
    */

    function mintTo(address _to, uint256 _value) external onlyAdmin {

        require(_to != address(0));
        require(_value > 0);
        totalSupply += _value;
        balances[_to] += _value;
        Transfer(address(0), _to, _value);
    }

    function burn(uint256 _value) external onlyAdmin {

        require(_value > 0 && balances[msg.sender] >= _value);
        totalSupply -= _value;
        balances[msg.sender] -= _value;
    }

    function changeAdminAddress(address _newAddress)

    external
    onlyAdmin
    nonZeroAddress(_newAddress)
    {
        adminMultiSig = _newAddress;
        ChangeAdminWalletAddress(now, adminMultiSig);
    }

    function() public {
        revert();
    }
}

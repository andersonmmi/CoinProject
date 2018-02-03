/* Rinkeby testnet */

/*
   Access the contract through myEtherWallet
   or through geth console.

   For geth console:
   geth --verbosity 1 console --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0x0E9DD26Af82Df34Ef3cFCd26880c82c71Ecf5faB"
*/

/////// USER ///////

/* My metamask address for rinkeby */

/* Other accts */
var acct = eth.accounts[0];
var acct2 = eth.accounts[1];
var metaMask = "0xBAE2175539624c861920C9566486DA79b582D362";
var acct4 = "0x26835D13fCd692A0324de339000e9d45eEB247Ad";
var windowsMetaMask = "0xD622b3353Ed44c45ebE139bF63df1EDa3288A5ea";

// sends 2 ETH to fund new accts
//web3.eth.sendTransaction({to: acct4, from: acct, value: 2000000000000000000, gasPrice: 3141592});

/////// TOKEN ///////

/* Token ABI */
var memCoin_ABI_raw = [{
  "constant": false,
  "inputs": [
    {
      "name": "_to",
      "type": "address"
    },
    {
      "name": "_value",
      "type": "uint256"
    }
  ],
  "name": "mintTo",
  "outputs": [],
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "function"
},{
  "constant": false,
  "inputs": [
    {
      "name": "_value",
      "type": "uint256"
    }
  ],
  "name": "burn",
  "outputs": [],
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "function"
},{
  "constant": false,
  "inputs": [
    {
      "name": "_newAddress",
      "type": "address"
    }
  ],
  "name": "changeAdminAddress",
  "outputs": [],
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "function"
}, {
  "constant": false,
  "inputs": [
    {
      "name": "_to",
      "type": "address"
    },
    {
      "name": "_value",
      "type": "uint256"
    }
  ],
  "name": "transfer",
  "outputs": [],
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "function"
}];

/* Token address */
var memCoinAddr = "0x7BB8583A365b09A35fA92b0d4A0BC6b21e97AAeB";

/* Useable token abi */
var memABI = eth.contract(memCoin_ABI_raw);

/* Token address */
var memCoin = memABI.at(memCoinAddr);

/* params for transfer reward token */
var _to = windowsMetaMask;
var _value = 500000000000000000000000;

/* Data package (using appropriate method) */
var _data = memCoin.transfer.getData(_to, _value);

/* Transaction call */
web3.eth.sendTransaction({to: memCoinAddr, from: acct, data: _data, gasPrice: 3141592});

/////
var addresses = [metaMask, acct2, acct4];
var values = [33298782893000000000, 3298782893000000000, 93298782893000000000]

for (i=0;i<addresses.length ;i++) {
    var _to = addresses[i];
    var _value = values[i];
    var _data = memCoin.transfer.getData(_to, _value);
    web3.eth.sendTransaction({to: memCoinAddr, from: acct, data: _data, gasPrice: 3141592});
};
/////

// to migrate:
// 1) geth --verbosity 1 console --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0x0E9DD26Af82Df34Ef3cFCd26880c82c71Ecf5faB"
// 2) truffle migrate --network rinkeby

module.exports = {

  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
  },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0x0E9DD26Af82Df34Ef3cFCd26880c82c71Ecf5faB", // default address to use for any transaction Truffle makes during migrations
      network_id: 4,
      gas: 4612388 // Gas limit used for deploys
    }
  }

};

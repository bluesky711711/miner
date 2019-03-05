import Web3 from "web3";
import MetaHashArtifact from "../../build/contracts/MetaHash.json";

const App = {
  web3: web3 = null,
  account: null,
  meta: null,

  start: async function() {
    const { web3 } = this;

    try {
      // get contract instance
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = MetaHashArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        MetaHashArtifact.abi,
        deployedNetwork.address,
      );

      // get accounts
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];
    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
  },

  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },

  newDeligator: async function() {
    const { newDeligator } = this.meta.methods;
    const amount = document.getElementById("newDeligatorAmountId").value;
    const txid = document.getElementById("txidId").value;
    await newDeligator(amount,txid).send({from: this.account});
    var functionReturn_newDeligator = await newDeligator(amount,txid).call({from: this.account});
    App.setStatus("New Deligator is: " + this.account + " TX ID: " + functionReturn_newDeligator[9] + " Amount delegated: " +functionReturn_newDeligator[2] );

  },

  unDeligate: async function() {
    const { unDeligate } = this.meta.methods;
    await unDeligate().send({from: this.account});
    App.setStatus("Undeligated account is " + this.account + ".");
  },

  getServerAddress: async function() {
    const { getServerAddress } = this.meta.methods;
 
    await getServerAddress().send({from: this.account});
    App.setStatus("Server Address is " + this.account + ".");
  },

  lookupDeligate: async function() {
    const { lookupDeligate } = this.meta.methods;
    var functionReturn = await lookupDeligate().call({from: this.account});
    //await lookupDeligate().send({from: this.account});
    App.setStatus("**** User TX ID:  " + functionReturn[9] + " **** Wallet Account:  " + functionReturn[1] + "**** Reward Owed:  " + functionReturn[8]);
  },

  authorise: async function() {
    const { authorise } = this.meta.methods;
    let payAddress = document.getElementById("DeligatorAddressId").value;
    await authorise(payAddress).send({from: this.account});
    App.setStatus("Rewards sent too: " + payAddress + ".");
  },

  createStar: async function() {
    const { createStar } = this.meta.methods;
    const name = document.getElementById("starName").value;
    const id = document.getElementById("starId").value;
    await createStar(name, id).send({from: this.account});
    App.setStatus("New Star Owner is " + this.account + ".");
  },

  // Implement Task 4 Modify the front end of the DAPP
  lookUp: async function (){
    const { lookUptokenIdToStarInfo } = this.meta.methods;
    const id = document.getElementById("lookid").value;
    await lookUptokenIdToStarInfo(id).send({from: this.account});
    App.setStatus("Star Lookup is " + this.account + ".");
  }

};

window.App = App;

window.addEventListener("load", async function() {
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);
    await window.ethereum.enable(); // get permission to access accounts
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live",);
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    App.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:9545"),);
  }

  App.start();
});
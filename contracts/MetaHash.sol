pragma solidity >=0.4.22 <0.6.0;
// TASK 1 : Fix release reward function to allow input of a wallet address in front end
// TASK 2 : Make function to calculate reward based on a percent of the main reward awarded
// TASK 3 : Make the lookup process display a HREF to directly check proof of deligation
// TASK 4 : 
// TASK 5 : 
// TASK 6 : 


contract MetaHash {

    struct Delegated {
        bool live; // is currently deligated
        uint deligatedDate; // dete deligated
        uint undeligatedDate; //dete undeligated
        address delegate; //deligator ethaddress
        string txID;
        uint amount; //amount deligated
        bool verifiedDeligation; // Authorised deligation
        bool releasePayment; //Authorised payment
        uint timeDeligated; //Amount of time deligated
        uint rewardToPay; //caluclated reward to pay
    }
    
    address payable server; //Owner of contract
    
    mapping(address => Delegated) deligators; //list of deligated accounts
    Delegated[] delegatesArray;
  
    event newDeligateRequest(address _deligator, uint _tokenAmount, uint _currentdate); // Notify when new user registers
    event unDeligateRequest(address _deligator, uint _currentdate, uint timeOwed, uint reward); // Notify when new user registers

    constructor() public payable {
        server = msg.sender;
    }
    
    //Get server address
    function getServerAddress() public view returns (address) {
        require (msg.sender == server);
        return msg.sender;
    }
    
    //Add deligate
    ///hell testing
    function newDeligator(uint amount, string memory txID) public payable returns (bool, address, uint,uint,uint,bool,bool,uint,uint, string memory) {
        //require (msg.sender != deligators[msg.sender].delegate); //not already deligated
        address payable _deligator = msg.sender;
        
        deligators[_deligator].live = true;
        deligators[_deligator].delegate = msg.sender;
        deligators[_deligator].amount = amount;
        deligators[_deligator].deligatedDate = now;
        deligators[_deligator].undeligatedDate = 0;
        deligators[_deligator].verifiedDeligation = false;
        deligators[_deligator].releasePayment = false;
        deligators[_deligator].timeDeligated = 0;
        deligators[_deligator].rewardToPay = 0;
        deligators[_deligator].txID = txID;
        
        delegatesArray.push(Delegated({ //create deligator object and place within array
            live: true,
            delegate: _deligator,
            amount: amount,
            deligatedDate: now,
            undeligatedDate: 0,
            verifiedDeligation: false,
            releasePayment: false,
            timeDeligated: 0,
            rewardToPay: 0,
            txID: txID
            }));
        
        return (deligators[_deligator].live, 
                deligators[_deligator].delegate, 
                deligators[_deligator].amount, 
                deligators[_deligator].deligatedDate,
                deligators[_deligator].undeligatedDate,
                deligators[_deligator].verifiedDeligation,
                deligators[_deligator].releasePayment,
                deligators[_deligator].timeDeligated,
                deligators[_deligator].rewardToPay,
                deligators[_deligator].txID);
                
        emit newDeligateRequest(_deligator, amount, now);
                
    }
    
    //Undeligate.  Reset all data in mapping.
    function unDeligate(address _deligator) public payable {
        require (msg.sender == server);
        
        deligators[_deligator].live = false;
        deligators[_deligator].delegate = 0x0000000000000000000000000000000000000000;
        deligators[_deligator].amount = 0;
        deligators[_deligator].deligatedDate = now;
        deligators[_deligator].undeligatedDate = 0;
        deligators[_deligator].verifiedDeligation = false;
        deligators[_deligator].releasePayment = false;
        deligators[_deligator].timeDeligated = 0;
        deligators[_deligator].rewardToPay = 0;
        deligators[_deligator].txID = "";
        
         for (uint d = 0; d < delegatesArray.length; d++) {
            if (delegatesArray[d].delegate == _deligator) {
                if (delegatesArray[d].live == true) {
                    delete delegatesArray[d];
                }
            }
        }
    }
    
    //deligate lookup
    function lookupDeligate() public view returns (bool, address, uint,uint,uint,bool,bool,uint,uint, string memory){
        require (msg.sender == server);
        for (uint d = 0; d < delegatesArray.length; d++) {
            if (delegatesArray[d].live == true) {
            
            return (delegatesArray[d].live, 
            delegatesArray[d].delegate, 
            delegatesArray[d].amount,
            delegatesArray[d].deligatedDate, 
            delegatesArray[d].undeligatedDate, 
            delegatesArray[d].verifiedDeligation, 
            delegatesArray[d].releasePayment, 
            delegatesArray[d].timeDeligated,
            delegatesArray[d].rewardToPay,
            delegatesArray[d].txID);
            }
        } 
    }

//   function searchByTXID(string memory toAuthTXID) public returns (address) {
 //       for (uint d = 0; d < delegatesArray.length; d++) {
 //           if (delegatesArray[d].live == true) { // live deligate
 //               if (delegatesArray[d].releasePayment == false) { // not yet paid
 //                   string memory test =delegatesArray[d].txID;
 //                   if(test == toAuthTXID) {
 //                       address payable walletToPay =  delegatesArray[d].delegate;
 //                   }
 //               }
 //           }
 //       
 //       }
//
//   }

    //Authorise the release of payment to an inputted address: subject to some safety checks within
    function authorise(address payable toAuth) public payable returns (address, string memory, bool) {
        require (msg.sender == server);
        require (toAuth == deligators[toAuth].delegate);
        
        deligators[toAuth].releasePayment = true;
        
        if (deligators[toAuth].releasePayment = true) {
            rewardDeligate(toAuth);
            unDeligate(toAuth);
        }
        return (deligators[toAuth].delegate,
                deligators[toAuth].txID,
                deligators[toAuth].releasePayment);
    }
    
    //Release the funds to an address.
    function rewardDeligate(address payable toReward) public payable returns (address, string memory, bool) {
        //require (msg.sender == server);
        uint value = 100;
        toReward.transfer(value);
        
    }

}
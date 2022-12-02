//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
contract Dvive_SignUp_logIn_ProfileSetUp_KYC
    {
        
        address[]  RegisteredUserAddress;//storing registered user wallet address
        address private Owner; 
    struct userDetailsStruct  
    {
        //user log in info
        string password;
        string mailID;
        //user profile set up details
        string FirstName;
        string MiddleName;
        string LastName;
        string gender;
        string Address;
        string ImageUrl;
        bool KYCisDone;
        bool IsLoggedIn;
    }
    struct KYCstruct
    {
        string CountryName;
        string FrontImageUrl;
        string BackImageUrl;
        string FaceImageUrl;
        string VerificationType;
    }
    //mail provided at sign up mapping to the user adress 
    mapping(address=>string) SignUpInfo;
    //mapping user's details to their  wallet address
    mapping(address=>userDetailsStruct) userDetails; 
    //when user signs up mapping to it's address true (checking if user is registered)
    mapping(address=>KYCstruct) KYCInfo;
    mapping(address=>bool) private IsRegistered;
    //when user log in mapping to it's address true (checking if user is logged in)
    mapping(address=>bool) private IsloggedIn;
   

    event eUserSignUpInfo(address user,string _mailId,string _password);
    event eLogInInfo(string _mailId, string  _password);
    event eProfileSetup(string _FirstName,string _MiddleName,string _LastName,string _gender,string _Address,string _ImageUrl);
    event eKYC(address _user,string _CountryName,string _FrontImageUrl,string _BackImageUrl,string _FaceImageUrl,string  _VerificationType);
    event eTransferOwnership(address,address); 
    event eEditName(address _userWalletAdd,string _FirstName,string _MiddleName,string _LastName);
    event eEditAddress(address _user,string _NewAddress);
    event eChangeImage(address _user,string _NewImageUrl);

    modifier mOwnerOnly
    {
               require(msg.sender==Owner,"only owner has access");
               _;
    }

    constructor()
    {  
               Owner=msg.sender;
    }
    function SignUp(string memory _mailId,string memory _password) public returns(bool)
    {
               
               SignUpInfo[msg.sender]=_mailId;
               userDetails[msg.sender].mailID=_mailId;
               userDetails[msg.sender].password=_password;
               RegisteredUserAddress.push(msg.sender);
               IsRegistered[msg.sender]=true;
               emit eUserSignUpInfo(msg.sender,_mailId,_password);
               return true;                      
    }
    function LogIn(string memory _mailId, string memory _password) public returns(string memory)
    {
          
               userDetails[msg.sender].mailID=_mailId;
               userDetails[msg.sender].password=_password;
               IsloggedIn[msg.sender]=true;
               emit eLogInInfo(_mailId,_password);
               return "True";
    }
    function ProfileSetUp(string memory _FirstName,string memory _MiddleName,string memory _LastName,string memory _gender,string memory _Address,string memory _ImageUrl) public
    {
               
               userDetails[msg.sender].FirstName=_FirstName;
               userDetails[msg.sender].MiddleName=_MiddleName;
               userDetails[msg.sender].LastName=_LastName;
               userDetails[msg.sender].gender=_gender;
               userDetails[msg.sender].Address=_Address;
               userDetails[msg.sender].ImageUrl=_ImageUrl;
               emit eProfileSetup(_FirstName,_MiddleName,_LastName,_gender,_Address,_ImageUrl);
    }
    function KYC(string memory _CountryName,string memory _FrontImageUrl,string memory _BackImageUrl,string memory _FaceImageUrl,string memory _VerificationType) public 
    {
              
               KYCInfo[msg.sender].CountryName=_CountryName;
               KYCInfo[msg.sender].FrontImageUrl=_FrontImageUrl;
               KYCInfo[msg.sender].BackImageUrl=_BackImageUrl;
               KYCInfo[msg.sender].FaceImageUrl=_FaceImageUrl;
               KYCInfo[msg.sender].VerificationType=_VerificationType;
               userDetails[msg.sender].KYCisDone=true;
               emit eKYC(msg.sender,_CountryName,_FrontImageUrl,_BackImageUrl,_FaceImageUrl,_VerificationType);
               
    }
    function ChangeName(string memory _FirstName,string memory _MiddleName,string memory _LastName) public 
    {
               userDetails[msg.sender].FirstName=_FirstName;
               userDetails[msg.sender].MiddleName=_MiddleName;
               userDetails[msg.sender].LastName=_LastName;
               emit eEditName(msg.sender,_FirstName,_MiddleName,_LastName);
    }
    function changeAddress(string memory _NewAddress) public 
    {
              userDetails[msg.sender].Address=_NewAddress;
              emit eEditAddress(msg.sender, _NewAddress);
    }
    function ChangeProfilePicture(string memory _NewImageUrl) public 
    {
               userDetails[msg.sender].ImageUrl=_NewImageUrl;
               emit eChangeImage(msg.sender,_NewImageUrl);

    }
               //only owner can transfer ownership to the desired address  
    function transferOwnership(address _newOwner) public mOwnerOnly returns(bool)
    {
               Owner=_newOwner;
               return true;
    }              
               //get all the details of the user mapped  to user's wallet address(key) just by providing wallet address 
    function getUserDetails(address _user) public  view mOwnerOnly returns(userDetailsStruct memory)
    {
               return userDetails[_user];
    }
              
    
    }
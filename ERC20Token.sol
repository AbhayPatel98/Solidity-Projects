// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;   

abstract contract ERC_stdTOKEN {

    function name() public virtual returns (string memory);
    function symbol() public virtual returns (string memory);
    function decimals() public  virtual returns (uint8);

   
    function totalSupply() public view virtual returns (uint256);
    function balanceOf(address _owner) public view virtual returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);


    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

                           

}

contract ownership {

    address public contractOwner;
    address public newOwner;

    event TransferOwner (address indexed _from, address indexed _to);

    constructor () {
        contractOwner = msg.sender;
    }

    function changeOwner(address _to) public {
        require(msg.sender == contractOwner, "ONLY OWNER CAN EXICUTE IT");
        newOwner = _to;
    }

    function acceptOwner() public{
        require(msg.sender == newOwner, "ONLY NEW OWNER CAN EXICUTE IT");
        emit TransferOwner(contractOwner, newOwner);
        contractOwner = newOwner;
        newOwner = address(0);
    }

}

contract MyERCtoken is ERC_stdTOKEN,ownership {
         string public _name;
         string public _symbol;
         uint8 public _decimals;
         uint256 public _totalSupply;
         address public _minter;

         mapping (address => uint256) tokenBalances;
         mapping (address=>mapping (address => uint256)) allowed;

         constructor (address Minter) {
             _name = 'abhay coin';
             _symbol = 'AP';
             _totalSupply = 10000000;
             _minter = Minter;
             tokenBalances[_minter] = _totalSupply;
         }

  function name() public view override returns(string memory){

             return _name;

         }

  function symbol() public view override returns (string memory){

              return _symbol;

          }

  function decimals() public view override returns (uint8){

               return _decimals;
           }

  function totalSupply() public view override returns (uint256){

                return _totalSupply;
            }

  function balanceOf(address _owner) public view override returns (uint256 balance){

                return tokenBalances[_owner];
            }
            
  function transfer(address _to, uint256 _value) public override returns (bool success){
      require(tokenBalances[msg.sender] >= _value, "Insufficient Token");
      tokenBalances[msg.sender] -= _value;
      tokenBalances[_to] += _value;
      emit Transfer(msg.sender, _to, _value);
      success=true;
  }
  function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
         uint256 allowedBalace = allowed[_from][msg.sender];
         require(allowedBalace >= _value, "Insufficient value");
         tokenBalances[_from] -= _value;
         tokenBalances[_to] += _value;

         emit Transfer(_from, _to, _value);
         success=true;


  }


  function approve(address _spender, uint256 _value) public override returns (bool success){
      require(tokenBalances[msg.sender] >= _value, "Insufficient Token");
      allowed[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
  }


function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
         return allowed[_owner][_spender];

}

}
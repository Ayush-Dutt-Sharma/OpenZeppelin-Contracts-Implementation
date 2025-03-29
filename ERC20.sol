//SPDX-Identifier-License: MIT

pragma solidity ^0.8.0;

contract MyERC20 {

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    mapping(address account=> uint256) private _balances;
    mapping(address account=> mapping(address spender=> uint256)) private _allowances;

    event Transfer(address indexed from,address indexed to,uint256 value);
    event Approval(address owner,address spender,uint256 value);
    error ZeroAddress();
    error InsufficeientBalance();
    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns(string memory) {
        return _name;
    }

    function symbol() public view virtual returns(string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns(uint8) {
        return 18;
    }

    function totalSupply() public view virtual returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns(uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view virtual returns(uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 value) public virtual returns(bool){
        _transfer(msg.sender,to,value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public virtual returns (bool){
        _spendAllowance(from,msg.sender,value);
        _transfer(from,to,value);
        return true;
    }

    function approve(address spender, uint256 value) public virtual returns(bool){
        _approve(msg.sender,spender,value);
        return true;
    }

    function _update(address from, address to, uint256 value) internal virtual {
        if(from == address(0)){
            _totalSupply+=value;
        }else{
            uint256 fromBalance = _balances[from];
            if(fromBalance < value){
                revert InsufficeientBalance();
            }
            unchecked{
            _balances[from] = fromBalance - value;
            }
        }

        if(to == address(0)){
            unchecked{
                _totalSupply -= value;
            }
        } else {
            unchecked{
                _balances[to]+=value;
            }
        }

        emit Transfer(from,to,value);
    }

    function _approve(address owner, address spender, uint256 value) internal virtual {
        if(owner == address(0)){
            revert ZeroAddress();
        }
        if(spender == address(0)){
            revert ZeroAddress();
        }
        _allowances[owner][spender] = value;
        emit Approval(owner,spender,value);
    }

    function _mint(address to, uint256 value) internal {
        if(to == address(0)){
            revert ZeroAddress();
        }
        _update(address(0),to,value);
    }

    function _burn(address from, uint256 value) internal {
        if(from == address(0)){
            revert ZeroAddress();
        }
        _update(from, address(0), value);
    }

    function _transfer(address from, address to, uint256 value) internal virtual{
        if(to == address(0)){
            revert ZeroAddress();
        }
        if(from == address(0)){
            revert ZeroAddress();
        }
        _update(from,to,value);
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if(currentAllowance < type(uint256).max){
            if(currentAllowance < value){
                revert InsufficeientBalance();
            }
            unchecked{
                _approve(owner, spender, currentAllowance - value);
            }
        }
    }


}
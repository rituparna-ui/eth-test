pragma solidity ^0.8.0;
 
import "./IERC20.sol";
 
contract Token is IERC20 {
    string private _name; // Eg. Bitcoin
    string private _symbol; // Eg. BTC
 
    address private _owner;
 
    uint256 private _totalSupply; // Total supply (yet) of this token
 
    mapping (address => uint256) private _balances; // User balances
 
    mapping (address => mapping (address => uint256)) private _allowances; // Allowances per user
 
    // Initialize the contract
    constructor(string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
        _owner = msg.sender;
    }
 
    // Mint new tokens
    function mint(address account, uint256 amount) public returns (bool) {
        require(account != address(0), "Error: account cannot be 0 address");
 
        _totalSupply += amount;
        _balances[account] += amount;
 
        emit Transfer(address(0), account, amount);
        return true;
    }
 
    // Get total supply yet of the token
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }
 
    // Get balance of an address
    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }
 
    function transfer(address recipient, uint256 amount) public override returns (bool) {
 
        // Null checks
        require(msg.sender != address(0), "Error: Sender cannot be 0 address");
        require(recipient != address(0), "Error: Recipient cannot be 0 address");
 
        // Is sending money you actually have
        require(_balances[msg.sender] >= amount, "Error: Amount cannot exceed balance");
 
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
 
        emit Transfer(msg.sender, recipient, amount);
 
        return true;
    }
 
 
    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }
 
    function approve(address spender, uint256 amount) public override returns (bool) {
        // Null checks
        require(msg.sender != address(0), "Error: Owner cannot be 0 address");
        require(spender != address(0), "Error: Spender cannot be 0 address");
 
        // Update allowance
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
 
        return true;
    }
 
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        // Null checks
        require(sender != address(0), "Error: Sender cannot be 0 address");
        require(recipient != address(0), "Error: recipient cannot be 0 address");
 
        // Check my allowance >= amount i'm spending
        uint256 myAllowance = _allowances[sender][msg.sender];
        require(myAllowance >= amount, "Error: transfer amount exceeds allowance");
 
        // Actually transfer the money
        _balances[sender] -= amount;
        _balances[recipient] += amount;
 
        emit Transfer(sender, recipient, amount);
 
        // Decrease my allowance
        _allowances[sender][msg.sender] -= amount;
        emit Approval(sender, msg.sender, myAllowance - amount);
 
        return true;
    }
}

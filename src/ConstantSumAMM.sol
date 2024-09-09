// SPDX-License-Identifier: MIT 
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ConstantSumAMM {
    
    IERC20 public immutable token0; 
    IERC20 public immutable token1; 

    uint256 public reserve0; 
    uint256 public reserve1; 
    uint256 public totalSupply; 
    mapping(address => uint256) public balanceOf; 

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    // External and Public functions:  
    function swap(address _tokenIn, uint256 _amountIn) external returns(uint256 amountOut) {
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid token"); 
        require(_amountIn > 0, "Amount in is zero"); 
        bool isToken0 = _tokenIn == address(token0); 

        (IERC20 tokenIn, IERC20 tokenOut, uint256 reserveIn, uint256 reserveOut) = 
        isToken0 ? (token0, token1, reserve0, reserve1) : (token1, token0, reserve1, reserve0); 
        // _amountIn = 500, reserveIn = 1000, reserveOut = 1500 
        // so -> 500 + 1000 = 1500 
        // -> 1500 - 1000 = 500  
        // -> (500 * 997) / 1000 = 498.5  
        tokenIn.transferFrom(msg.sender, address(this), _amountIn); 
        uint256 amountIn = tokenIn.balanceOf(address(this)) - reserveIn;

        amountOut = (amountIn * 997) / 1000; // 0.3 % fee
        (uint256 res0, uint256 res1) = 
        isToken0 ? (reserveIn + amountIn, reserveOut - amountOut) : (reserveOut - amountOut, reserveIn + amountIn);
        
        _updateReserves(res0, res1);
        tokenOut.transfer(msg.sender, amountOut);
    }

    function addLiquidity(uint256 _amount0, uint256 _amount1) external returns(uint256 shares) {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        uint256 balance0 = token0.balanceOf(address(this));  
        uint256 balance1 = token1.balanceOf(address(this));  

        uint256 delta0 = balance0 - reserve0; 
        uint256 delta1 = balance1 - reserve1; 
         
        if(totalSupply > 0){
            shares = ((delta0 + delta1) * totalSupply) / (reserve0 + reserve1); 
        } else {
            shares = delta0 + delta1; 
        }

        require(shares > 0, "Shares is zero"); 
        _mint(msg.sender, shares);

        _updateReserves(balance0, balance1);
    }

    // Constant Sum AMM formula: 
    // x + y = k 
    // x = reserve0, y = reserve1, k = constant 

    // Internal and Private functions: 

    function _updateReserves(uint256 _res0, uint256 _res1) internal {
        reserve0 = _res0;
        reserve1 = _res1;
    }

    function _mint(address _to, uint256 _shares) internal {
        balanceOf[_to] += _shares;  
        totalSupply += _shares;
    }
}
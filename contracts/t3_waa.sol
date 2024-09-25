// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// 了解流动性的含义，即合约内可供交换的币对的存量。（样例只展示一个币对，2种代币）
// lp是ss合约的代币，代表注入流动性的人，所注入的流动性代币的凭证。

contract SimpleSwap is ERC20 {
    // 用于记录ss可接收的代币类型/编号？
    IERC20 public token0;
    IERC20 public token1;

    // 收到的代币数量
    uint public reserve0;
    uint public reserve1;

    constructor(IERC20 _token0, IERC20 _token1) ERC20("SimpleSwap", "SS"){
        token0 = _token0;
        token1 = _token1;
    }

    event Mint(address indexed sender, uint amount0, uint amount1);

    // 输入2种币， 得到合约代币lp
    // 因命名了返回参数名，所以，不需要在函数体里面使用return. 节约gas?
    function addLiquidity(uint amount0Input, uint amount1Input) public returns(uint liquidity) {
        // 先拿授权，且转入代币
        token0.transferFrom(msg.sender, address(this), amount0Input);
        token1.transferFrom(msg.sender, address(this), amount1Input);

        // 总供给
        uint _totalSupply = totalSupply();

        if(_totalSupply == 0) {
            liquidity = sqrt(amount0Input * amount1Input);
        } else {
            liquidity = min(amount0Input * _totalSupply / reserve0, amount1Input * _totalSupply/reserve1);
        }
        
        require(liquidity > 0, "INSUFFICIENT_LIQUIDITY_MINTED");

        // 通过ss的代币余额更新 状态变量（ss的链上变量）
        reserve0 = token0.balanceOf(address(this));
        reserve1 = token1.balanceOf(address(this));

        //
        _mint(msg.sender, liquidity);

        emit Mint(msg.sender, amount0Input, amount1Input);
    }

    event Burn(address indexed sender, uint amount0, uint amount1);

    // 输入lp，返还2种代币
    // 转出数量 = (liquidity / totalSupply_LP) * reserve
    function removeLiquidity(uint liquidity) external  returns (uint amount0, uint amount1) {
        // 获取ss里面2种代币的持有量
        uint _balance0 = token0.balanceOf(address(this));
        uint _balance1 = token1.balanceOf(address(this));

        // 总供给
        uint _totalSupply = totalSupply();
        amount0 = liquidity * _balance0 / _totalSupply;
        amount1 = liquidity * _balance1 / _totalSupply;

        require(amount0 > 0 && amount1 > 0, "INSUFFICIENT_LIQUIDITY_MINTED");

        // 销毁代币lp
        _burn(msg.sender, liquidity);
        // 转回给发起者
        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);

        // 更新状态变量
        reserve0 = token0.balanceOf(address(this));
        reserve1 = token1.balanceOf(address(this));

        emit Burn(msg.sender, amount0, amount1);
    }
    
    // 交易换的量 
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint amountOut) {
        require(amountIn > 0, "INSUFFICIENT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0 , "INSUFFICIENT_LIQUIDITY");

        amountOut = amountIn * reserveOut / (reserveIn + amountIn);
    }

    event Swap(address indexed sender, uint amountIn, address tokenIn, uint amountOut, address tokenOut);
    // 
    function swap(uint amountIn, IERC20 tokenIn, uint tokenOutMin) external returns (uint amountOut, IERC20 tokenOut) {
        require(amountIn > 0, "INSUFFICIENT_OUTPUT_AMOUNT");
        require(tokenIn == token0 || tokenIn == token1, "INVALID_TOKEN");

        if (tokenIn == token0) {
            tokenOut = token1;
            amountOut = getAmountOut(amountIn, reserve0, reserve1);
            require(amountOut > tokenOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
            tokenIn.transferFrom(msg.sender, address(this), amountIn);
            tokenOut.transfer(msg.sender, amountOut);
        } else {
            tokenOut = token0;
            amountOut = getAmountOut(amountIn, reserve1, reserve0);
            require(amountOut > tokenOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");
            tokenIn.transferFrom(msg.sender, address(this), amountIn);
            tokenOut.transfer(msg.sender, amountOut);
        }

        // 更新储备量
        reserve0 = token0.balanceOf(address(this));
        reserve1 = token1.balanceOf(address(this));

        emit Swap(msg.sender, amountIn, address(tokenIn), amountOut, address(tokenOut));
    }

    function sqrt(uint y) internal  pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function min(uint x, uint y) internal  pure returns (uint z) {
        z = x > y ? y : x ;
    }

    // function totalSupply() internal pure returns (uint total) {
    //     total = reserve0 * reserve1;
    // }
}
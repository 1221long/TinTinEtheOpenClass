// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract NFTSwap {

    struct Order {
        uint oId;
        // 系列
        uint seriesId;
        // Id
        uint tokenId;
        // 价格
        uint price;
        // 所有者address
        address owner;
        // 状态 0 = revert; 1 = valid; 2 = purchased
        uint status;
    }

    // mapping(uint => Order) public  Orders;
    Order[] public AllOrders;

    // 挂单
    function list(uint sId, uint tId, uint p) public {
        require(notExists(sId, tId), "only one valid NTF token with same series can be list. please refresh and check the orders.");
        uint l = AllOrders.length;
        AllOrders.push(Order({
            oId: l + 1,
            seriesId: sId,
            tokenId: tId,
            price: p,
            owner: msg.sender,
            status: 1
        }));
    }

    // 撤单
    function revoke(uint oIndex) public {
        require(AllOrders[oIndex].owner == msg.sender, "only the order's owner can revoke");

        AllOrders[oIndex].status = 0;
    }

    // 修改价格
    function update(uint oIndex, uint p) public {
        require(AllOrders[oIndex].owner == msg.sender, "only the order's owner can update");

        AllOrders[oIndex].price = p;
    }

    // 购买
    function purchase(uint oIndex) public payable {

        

        AllOrders[oIndex].owner = msg.sender;
        AllOrders[oIndex].status = 2;
    }

    // show list
    // uint pageIndex, uint pageSize
    function showList() public view returns (Order[] memory) {
        Order[] memory outOrders;
        uint tmpIndex = 0;

        for(uint i = 0; i < AllOrders.length; i++){
            // only valid order show
            if(AllOrders[i].status == 1){
                outOrders[tmpIndex] = AllOrders[i];
                tmpIndex++;
            }
        }

        return  outOrders;
    }
    // exist check
    function notExists(uint sId, uint tId) private view returns (bool) {
        bool notE = true;
        for(uint i = 0; i < AllOrders.length; i++){
            if(AllOrders[i].seriesId == sId && AllOrders[i].tokenId == tId && AllOrders[i].status == 1){
                notE = false;
                break ;
            }
        }
        return notE;
    }
}
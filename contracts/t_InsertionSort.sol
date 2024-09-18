// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract InsertSort {

    function resortUintArray(uint[] memory inArray) public pure returns (uint[] memory) {
        uint[] memory outArray;

        uint l = inArray.length;

        for(uint i = 0; i < l; i++) {
            outArray[i] = inArray[i];
            for(uint j = 0; j < l; j++) {
                if(outArray[i] > inArray[j] && (i == 0 || inArray[j] > outArray[i-1])) {
                    outArray[i] = inArray[j];
                }
            }
        }

        return  outArray;
    }

}
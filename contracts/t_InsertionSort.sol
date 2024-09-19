// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract InsertSort {

    function resortUintArray(uint[] memory inArray) public pure returns (uint[] memory) {
        uint[] memory outArray = new uint[](inArray.length);
        uint l = inArray.length;

        for(uint i = 0; i < l; i++) {
            outArray[i] = 0;
            for(uint j = 0; j < l; j++) {
                if(i == 0) {
                    outArray[i] = inArray[j];
                    if(outArray[i] > inArray[j]) {
                        outArray[i] = inArray[j];
                    }
                } else {
                    if(inArray[j] > outArray[i-1]) {
                        if (outArray[i] == 0) {
                            outArray[i] = inArray[j];
                        } else {
                            if(outArray[i] > inArray[j]) {
                                outArray[i] = inArray[j];
                            }
                        }
                    }
                }                
            }
        }

        return  outArray;
    }

}
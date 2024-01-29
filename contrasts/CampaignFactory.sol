// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "Campaign.sol";

contract CampaignFactory {
   Campaign[] public deployedCampaigns;

    function createCampaign(uint min) public {
        Campaign newCampaign = new Campaign(min, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (Campaign[] memory) {
       return deployedCampaigns;
    }
}
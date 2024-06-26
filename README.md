<p align="center">
    <h1 align="center">
      <picture>
        <img width="40" alt="Plurality icon." src="https://github.com/zain171m/AASRAA-DAO/blob/main/src/assets/aasraa.svg">
      </picture>
      AASRAA
    </h1>
</p>

| AASRAA (means Helper) is a Crowdfunding Decentralized Autonomous Organization which is governed by the donors. Donors are incentivised with AASRAA tokens upon donations.AASRAA tokens are primarily used in voting process for the campaigns approval. Using a robust platform which is governed by the donors where a scammer can not just fill up the platforms with campaigns rather campaigns needs to be approved through a voting process. |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |


## Live App
https://aasraa-dao.vercel.app/

## Smart Contract functions

1. **constructor(uint256 initialSupply)**: Initializes the contract by minting the initial supply of Aasraa tokens and assigning ownership to the deployer of the contract.

2. **mint(address account, uint256 amount)**: Allows the owner of the contract to mint additional Aasraa tokens and assign them to a specified account.

3. **requestCampaign**: Enables users to request the creation of a new campaign by providing details such as title, description, deadline, target amount, and image URL. Each campaign is added to the platform and assigned a unique ID.

4. **donateCampaign(uint _id)**: Allows users to donate Ether to a specified campaign. Donations are added to the campaign's total amount collected, and tokens equivalent to the donation amount are minted and assigned to the donor.

5. **getCampaigns**: Retrieves a list of all campaigns currently active on the platform, including their details.

6. **getDonors(uint256 _id)**: Retrieves a list of donors and their respective donation amounts for a specified campaign.

7. **castVote(uint campaignId, bool support)**: Allows donors to cast votes in favor of or against a campaign's approval. Each vote is weighted by the donor's token balance. If a campaign receives enough "yes" votes, it becomes approved for donations.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Aasraa is ERC20 {
 
    address public owner;

    /**
     * @notice constructor
     * @dev the name of the platform token, symbol and initial supply is assigned 
     */

    constructor(uint256 initialSupply) ERC20("Aasraa Token", "ASRA") {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
    }

    /**
     * @notice mint function
     * @dev later can be used by the owner or contract to mint tokens for donors 
     */

    function mint(address account, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        _mint(account, amount);
    }

     /** 
    * @dev A campaign is represented as a struct  
    */ 

    struct Campaign{
        address owner;
        string ownerName;
        string title;
        string description;
        uint256 deadline;
        uint256 amountGoal;
        uint256 amountCollected;
        string imageUrl;
        address[] donors;
        uint[] donations;
        uint256 noCount;
        uint256 yesCount;
        bool approved;
    }

     /** 
    * @dev Events when campaign is requested and approved  
    */ 


    event campaignRequested
    (
        uint256 campaignId
    );

    event campaignApproved
    (
        uint256 campaignId
    );

    /** 
    * @dev All campaigns is stored as mapping the uint256 acts as id of the campaign  
    */

    mapping(uint256 => Campaign) public campaigns;
    uint256 public numberOfCampaigns = 0;


    mapping(address => mapping(uint => bool)) public voters;




     /**
     * @notice request a campaign
     * @dev the campaign will be added to the platform interface 
     * @param _title : the title of the campaign
     * @param _description : the description or short story about campaign
     * @param _deadline : deadline for campaign to complete
     * @param _amountGoal : target amount to be collected
     * @param _imageUrl : image url to be displayed about campaign
     */
    function requestCampaign(string memory _ownerName, 
    string memory _title, 
    string memory _description, 
    uint256 _deadline,
    uint256 _amountGoal,
    string memory _imageUrl   
    ) public returns(uint256)
    {
        require(_deadline > block.timestamp, "The deadline should be a date in future");
        Campaign storage campaign = campaigns[numberOfCampaigns];

        campaign.owner = msg.sender;
        campaign.ownerName = _ownerName;
        campaign.title = _title;
        campaign.description = _description;
        campaign.deadline = _deadline;
        campaign.amountGoal = _amountGoal;
        campaign.amountCollected = 0;
        campaign.imageUrl = _imageUrl;
        campaign.approved = false;
        
        emit campaignRequested(numberOfCampaigns);

        numberOfCampaigns++;
        return numberOfCampaigns - 1;
    }

    /**
     * @notice donate a campaign
     * @dev the campaign will be donated and donation will be added to owner account 
     * @param _id : the id of the campaign(to access through mapping) id is not type in the campaign struct
     */ 
    function donateCampaign(uint _id)
    public payable
    {
        //Access struct campaign
        Campaign storage _campaign = campaigns[_id];
        require(_campaign.approved == true, "Only approved campaigns can accept donations");
        require(_campaign.amountGoal > _campaign.amountCollected, "Already received enough funds");
        uint amount = msg.value;

        //pay donations to the owner
        (bool success, ) = msg.sender.call{value : amount}("");

        //update collected amount if transaction successfull
        if (success){
            _campaign.amountCollected = _campaign.amountCollected + amount;        
            _mint(msg.sender, amount);
            //push donor to the donors list
            _campaign.donors.push(msg.sender);
            _campaign.donations.push(amount); 
        }
    }

    
     /**
     * @notice Get list of all campaign
     * @dev to access the list of all the available compaigns on the platform 
     */ 
    function getCampaigns() public view returns(Campaign[] memory)
    {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i < numberOfCampaigns;i++)
        {
            Campaign memory _campaign = campaigns[i];
            allCampaigns[i] = _campaign;
        }

        return allCampaigns;
    }

    /**
     * @notice get list of all donors of a campaign
     * @dev the list of the donors of a specific campaign will be accessed to display on platform 
     * @param _id : the id of the campaign(to access through mapping) id is not type in the campaign struct
     */
    function getDonors(uint256 _id) public view returns(address[] memory , uint256[] memory)
    {
        return(campaigns[_id].donors , campaigns[_id].donations);
    }


    /**
     * @notice Donors cast vote for campaign to approve the campaign
     * @dev (only approved campaign eligibe for donations) the campain approved after 10 yes vote counts
     * @param campaignId : id to retrieve the campaign
     * @param support : boolean to cast the vote. 
     */
    function castVote(uint campaignId, bool support) external 
    {
        require(campaignId < numberOfCampaigns, "the campaign does not exist corresponding to this id");
        require(campaigns[campaignId].approved == false, "the campaign already approved");
        require(!voters[msg.sender][campaignId], "Already voted for the campaign");
        Campaign storage campaign = campaigns[campaignId];
        
        uint256 voterBalance = balanceOf(msg.sender);  
        
        if(!support)
        {
            campaign.noCount += voterBalance;   
        }
        else
        {
            campaign.yesCount += voterBalance;
        }
        voters[msg.sender][campaignId] = true;  

        if(campaign.yesCount > campaign.noCount)
        {
            if(campaign.yesCount - campaign.noCount >= 10 * 10**18)
            {
            campaign.approved = true;
            emit campaignApproved(campaignId);
            }
        }
    }

}



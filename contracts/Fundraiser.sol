pragma solidity ^0.4.21;

import "./component/TokenSafe.sol";
import "./token/MintableToken.sol";
import "./token/BurnableToken.sol";
import "./fundraiser/MintableTokenFundraiser.sol";
import "./fundraiser/IndividualCapsFundraiser.sol";
import "./fundraiser/GasPriceLimitFundraiser.sol";
import "./fundraiser/CappedFundraiser.sol";
import "./fundraiser/RefundableFundraiser.sol";
import "./fundraiser/PresaleFundraiser.sol";
import "./fundraiser/TieredFundraiser.sol";


/**
 * @title EssenceToken
 */

contract EssenceToken is MintableToken, BurnableToken {
    constructor(address _minter)
        StandardToken(
            "Essence Token",   // Token name
            "XES", // Token symbol
            18  // Token decimals
        )
        
        MintableToken(_minter)
        public
    {
    }
}



/**
 * @title EssenceTokenSafe
 */

contract EssenceTokenSafe is TokenSafe {
  constructor(address _token)
    TokenSafe(_token)
    public
  {
    
    // Group "Core Team "
    init(
      1, // Group Id
      1577854800 // Release date = 2020-01-01 05:00 UTC
    );
    add(
      1, // Group Id
      0xc36CDfEB909f9AA993Fa553e4f880623C1583bD2,  // Token Safe Entry Address
      22500000000000000000000000  // Allocated tokens
    );
    
    // Group "The Essence Foundation "
    init(
      2, // Group Id
      1551416400 // Release date = 2019-03-01 05:00 UTC
    );
    add(
      2, // Group Id
      0x992f21Bee809F1eE7e67C0225185B29B04485b2e,  // Token Safe Entry Address
      22500000000000000000000000  // Allocated tokens
    );
  }
}



/**
 * @title EssenceTokenFundraiser
 */

contract EssenceTokenFundraiser is MintableTokenFundraiser, PresaleFundraiser, IndividualCapsFundraiser, CappedFundraiser, RefundableFundraiser, TieredFundraiser, GasPriceLimitFundraiser {
    EssenceTokenSafe public tokenSafe;

    constructor()
        HasOwner(msg.sender)
        public
    {
        token = new EssenceToken(
        
        address(this)  // The fundraiser is the minter
        );

        tokenSafe = new EssenceTokenSafe(token);
        MintableToken(token).mint(address(tokenSafe), 45000000000000000000000000);

        initializeBasicFundraiser(
            1547614800, // Start date = 2019-01-16 05:00 UTC
            1551329940,  // End date = 2019-02-28 04:59 UTC
            3000, // Conversion rate = 3000 XES per 1 ether
            0xB9f32508a8476640458ab2960f9BDc3E556fED53     // Beneficiary
        );

        initializeIndividualCapsFundraiser(
            (0.25 ether), // Minimum contribution
            (0 ether)  // Maximum individual cap
        );

        initializeGasPriceLimitFundraiser(
            0 // Gas price limit in wei
        );

        initializePresaleFundraiser(
            7500000000000000000000000,
            1546318800, // Start = 2019-01-01 05:00 UTC
            1547528340,   // End = 2019-01-15 04:59 UTC
            6000
        );

        initializeCappedFundraiser(
            (35000 ether) // Hard cap
        );

        initializeRefundableFundraiser(
            (3500 ether)  // Soft cap
        );

        
    }
    
    /**
      * @dev Define conversion rates based on the tier start and end date
      */
    function getConversionRate() public view returns (uint256) {
        uint256 rate = super.getConversionRate();
        if (now >= 1547614800 && now < 1548219540)
            return rate.mul(150).div(100);
        
        if (now >= 1548306000 && now < 1549515540)
            return rate.mul(130).div(100);
        

        return rate;
    }

    /**
      * @dev Disable minting upon finalization
      */
    function finalization() internal {
        super.finalization();
        MintableToken(token).disableMinting();
    }
}


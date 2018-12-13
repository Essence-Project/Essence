pragma solidity ^0.4.21;

import "./BasicFundraiser.sol";

/**
 * @title TieredFundraiser
 *
 * @dev A fundraiser that improves the base conversion precision to allow percent bonuses
 */

contract TieredFundraiser is BasicFundraiser {
    // Conversion rate factor for better precision.
    uint256 constant CONVERSION_RATE_FACTOR = 100;

    /**
      * @dev Define conversion rates based on the tier start and end date
      */
    function getConversionRate() public view returns (uint256) {
        return super.getConversionRate().mul(CONVERSION_RATE_FACTOR);
    }

    /**
     * @dev this overridable function that calculates the tokens based on the ether amount
     */
    function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
        return super.calculateTokens(_amount).div(CONVERSION_RATE_FACTOR);
    }

    /**
     * @dev this overridable function returns the current conversion rate factor
     */
    function getConversionRateFactor() public pure returns (uint256) {
        return CONVERSION_RATE_FACTOR;
    }
}
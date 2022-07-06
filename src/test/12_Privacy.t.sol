
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import { IPrivacy, PrivacySolution} from "src/12_Privacy/PrivacySolution.sol";

contract PrivacyTest is DSTest {
    IPrivacy privacy;
    PrivacySolution privacySolution;

    function setUp() public {
        privacy = IPrivacy(0xb4a58A90bb546693a719b61Fb3AFa3E8a4c3F2Bc);
        privacySolution = new PrivacySolution();
    }

    function testPrivacyBefore() public {
        bytes16 converted = privacySolution.convert(0x3436ca7c85b2c89f2f42ce7bb6cc5b965a58be78fdad01aaf5f4eb8fb596aa80);
        emit log_named_bytes32("converted", bytes32(converted));
        privacy.unlock(converted);
    }

}

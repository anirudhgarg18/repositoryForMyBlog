package com.org.test.coop.junit;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

import com.org.test.coop.master.junit.RetailBranchWSTest;

@RunWith(Suite.class)
@Suite.SuiteClasses({
	RetailBranchWSTest.class
})
public class RetailSvcWSTestSuite {
	
}
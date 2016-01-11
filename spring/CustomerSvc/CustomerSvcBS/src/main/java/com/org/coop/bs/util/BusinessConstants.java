package com.org.coop.bs.util;

public class BusinessConstants {
	public static final int OTP_VALIDITY = 15 * 60 * 1000;  //OTP will be valid for 15 minutes
	
	public static String RULE_LOGIN_OPTION 								= "LOGIN_OPTION";
	public static String RULE_LOCK_AFTER_NO_OF_ATTEMPTS 				= "LOCK_AFTER_NO_OF_ATTEMPTS";
	public static String RULE_NUMBER_OF_SECURITY_QUESTIONS_TO_ASK 		= "NUMBER_OF_SECURITY_QUESTIONS_TO_ASK";
	public static String RULE_NUMBER_OF_SECURITY_QUESTIONS_TO_ANSWER	= "NUMBER_OF_SECURITY_QUESTIONS_TO_ANSWER";
	public static String RULE_NUMBER_OF_TIMES_OTP_TO_BE_RESEND 			= "NUMBER_OF_TIMES_OTP_TO_BE_RESEND";
	public static int NUMBER_OF_TIMES_OTP_TO_BE_RESEND_VAL 				= 3;
	public static int RULE_LOCK_AFTER_NO_OF_ATTEMPTS_VAL 				= 3;
	
	public static enum RULE_LOGIN_OPTION_ENUM {
		ONE_STEP_LOGIN,OTP_BASED_LOGIN,SECURITY_QUESTION_BASED_LOGIN
	};
}
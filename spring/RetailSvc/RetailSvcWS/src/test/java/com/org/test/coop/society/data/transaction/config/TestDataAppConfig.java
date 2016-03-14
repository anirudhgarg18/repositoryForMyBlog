package com.org.test.coop.society.data.transaction.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.core.env.Environment;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.org.coop.retail.transaction.config.RetailDBConfig;
import com.org.test.coop.retail.transaction.config.RetailTestDBConfig;

@Configuration
@EnableTransactionManagement
//@ComponentScan(basePackages = "com.org.coop", excludeFilters = { @Filter(type = FilterType.ANNOTATION, value = Configuration.class) })
@PropertySource("classpath:applicationTest.properties")
@Import({RetailDBConfig.class, TestCoOperativeAdminDBConfig.class})
public class TestDataAppConfig {
	
	@Autowired
	private Environment env;

}

package com.org.coop.society.data.customer.transaction.config;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableJpaRepositories(basePackages = {"com.org.coop.society.data.customer.repositories"}, 
					entityManagerFactoryRef="customerEntityManagerFactory", 
					transactionManagerRef="customerTransactionManager")
@EnableTransactionManagement
@PropertySource("classpath:customerApplicationData.properties")
public class CoOperativeCustomerDBConfig {
	@Autowired
	private Environment env;

	@Bean(name = "customer1DataSource")
	@Qualifier("customer1DataSource")
	public DataSource customer1DataSource() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName(env.getProperty("db.driver"));
		dataSource.setUrl(env.getProperty("db.customer1.url"));
		dataSource.setUsername(env.getProperty("db.username"));
		dataSource.setPassword(env.getProperty("db.password"));
		return dataSource;
	}

	@Bean(name = "customer2DataSource")
	@Qualifier("customer2DataSource")
	public DataSource customer2DataSource() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName(env.getProperty("db.driver"));
		dataSource.setUrl(env.getProperty("db.customer2.url"));
		dataSource.setUsername(env.getProperty("db.username"));
		dataSource.setPassword(env.getProperty("db.password"));
		return dataSource;
	}
	
	/**
	 * This method selects database dynamically at runtime
	 * @return
	 */
	@Bean(name = "dataSource")
	@Qualifier("dataSource")
	public CustomerRoutingDataSource dataSource() {
		CustomerRoutingDataSource customerRoutingDataSource = new CustomerRoutingDataSource();
		customerRoutingDataSource.setDefaultTargetDataSource(customer1DataSource());
		Map<Object, Object> dsMap = new HashMap<Object, Object>();
		dsMap.put("coopadmin", customer1DataSource());
		dsMap.put("coopadmin1", customer2DataSource());
		
		customerRoutingDataSource.setTargetDataSources(dsMap);
		return customerRoutingDataSource;
	}
	
	@Bean(name = "customerEntityManagerFactory")
	@Qualifier("customerEntityManagerFactory")
	public LocalContainerEntityManagerFactoryBean customerEntityManagerFactory() {
		LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
		em.setDataSource(dataSource());
		em.setPackagesToScan(new String[] { "com.org.coop.society.data.customer" });

		JpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
		em.setJpaVendorAdapter(vendorAdapter);
		em.setJpaProperties(additionalProperties());

		return em;
	}
	
	@Bean(name="customerTransactionManager")
	@Qualifier("customerTransactionManager")
	public PlatformTransactionManager customerTransactionManager() {
		JpaTransactionManager transactionManager = new JpaTransactionManager();
		transactionManager.setEntityManagerFactory(customerEntityManagerFactory().getObject());
		return transactionManager;
	}
	

	@Bean
	public PersistenceExceptionTranslationPostProcessor exceptionTranslation() {
		return new PersistenceExceptionTranslationPostProcessor();
	}

	Properties additionalProperties() {
		Properties properties = new Properties();
		properties.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL5Dialect");
		properties.setProperty("hibernate.show_sql", "true");
		properties.setProperty("hibernate.format_sql", "true");
//		properties.setProperty("hibernate.use_sql_comments", "true");
		return properties;
	}
}

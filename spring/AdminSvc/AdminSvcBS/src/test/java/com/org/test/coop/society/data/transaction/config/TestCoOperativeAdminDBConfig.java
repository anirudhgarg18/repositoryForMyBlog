package com.org.test.coop.society.data.transaction.config;

import java.util.Properties;

import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceContextType;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.datasource.init.DatabasePopulator;
import org.springframework.jdbc.datasource.init.DatabasePopulatorUtils;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@ComponentScan(basePackages = "com.org.coop")
@EnableJpaRepositories(basePackages = {"com.org.coop.society.data.admin.repositories"}, 
					entityManagerFactoryRef="adminEntityManagerFactory", 
					transactionManagerRef="adminTransactionManager")
@EnableTransactionManagement
@PropertySource("classpath:applicationTest.properties")
public class TestCoOperativeAdminDBConfig {
	@Autowired
	private Environment env;
	
	@Value("classpath:truncate_db_proc.sql")
	private Resource schemaScript;

	@Bean(name = "adminDataSource")
	@Qualifier("adminDataSource")
	public DataSource adminDataSource() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName(env.getProperty("db.test.driver"));
		dataSource.setUrl(env.getProperty("db.test.admin.url"));
		dataSource.setUsername(env.getProperty("db.test.admin.username"));
		dataSource.setPassword(env.getProperty("db.test.admin.password"));
		if("true".equalsIgnoreCase(env.getProperty("clean.db"))) {
			DatabasePopulatorUtils.execute(getDatabasePopulator(), dataSource);
		}
		return dataSource;
	}
	
	public DataSource adminDataSource_h2db() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		// Create DB schema
		// mysqldump --compatible=ansi,no_table_options,no_field_options,no_key_options --hex-blob --skip-opt --no-data -uroot -p coopadmin > d:\\coopadmin_schema.sql
		
//		dataSource.setDriverClassName("org.h2.jdbcx.JdbcDataSource");
		dataSource.setDriverClassName("org.h2.Driver");
//		dataSource.setUrl("jdbc:h2:~/h2-testdb;MODE=MYSQL");
		dataSource.setUrl("jdbc:h2:mem:test;INIT=runscript from 'classpath:testdb/coopadmin_schema.sql'");
		dataSource.setUsername("sa");
		dataSource.setPassword("");
		
		//DatabasePopulatorUtils.execute(getDatabasePopulator(), dataSource);
		return dataSource;
	}

	private DatabasePopulator getDatabasePopulator() {
		ResourceDatabasePopulator rdp = new ResourceDatabasePopulator();
		rdp.addScript(schemaScript);
//		rdp.addScript(dataScript);
		//rdp.setContinueOnError(true);
		return rdp;
	}
	
	@Bean(name = "adminEntityManagerFactory")
	@Qualifier("adminEntityManagerFactory")
	public LocalContainerEntityManagerFactoryBean adminEntityManagerFactory() {
		LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
		em.setDataSource(adminDataSource());
		em.setPackagesToScan(new String[] { "com.org.coop.society.data.admin" });

		JpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
		em.setJpaVendorAdapter(vendorAdapter);
		//em.setJpaProperties(additionalProperties());

		return em;
	}
	
	@Bean(name="adminTransactionManager")
	@Qualifier("adminTransactionManager")
	public PlatformTransactionManager adminTransactionManager() {
		JpaTransactionManager transactionManager = new JpaTransactionManager();
		transactionManager.setEntityManagerFactory(adminEntityManagerFactory().getObject());
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
//		properties.setProperty("hibernate.enable_lazy_load_no_trans", "true");
		
//		properties.setProperty("hibernate.use_sql_comments", "true");
		return properties;
	}
}

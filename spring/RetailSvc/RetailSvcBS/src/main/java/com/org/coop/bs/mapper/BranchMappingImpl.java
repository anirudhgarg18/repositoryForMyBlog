package com.org.coop.bs.mapper;

import org.dozer.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.org.coop.bs.config.RetailDozerConfig;

@Component
public class BranchMappingImpl {
	@Autowired
	private RetailDozerConfig dozerConfig;
	
	public void mapBean(Object src, Object dest) {
		Mapper dozerBeanMapper = (Mapper) dozerConfig.dozerBean();
		dozerBeanMapper.map(src, dest, "branchMap");
	}
}
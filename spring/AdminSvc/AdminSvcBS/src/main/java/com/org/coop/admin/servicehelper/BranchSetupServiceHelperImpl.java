package com.org.coop.admin.servicehelper;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.org.coop.admin.service.MasterDataSetupServiceImpl;
import com.org.coop.bs.mapper.BranchMappingImpl;
import com.org.coop.canonical.beans.BranchBean;
import com.org.coop.canonical.beans.BranchModuleBean;
import com.org.coop.canonical.beans.UIModel;
import com.org.coop.canonical.master.beans.MasterDataBean;
import com.org.coop.canonical.master.beans.ModuleMasterBean;
import com.org.coop.society.data.admin.entities.BranchMaster;
import com.org.coop.society.data.admin.entities.CustomBranchModule;
import com.org.coop.society.data.admin.entities.User;
import com.org.coop.society.data.admin.entities.UserCredential;
import com.org.coop.society.data.admin.repositories.BranchMasterRepository;
import com.org.coop.society.data.admin.repositories.CustomBranchModuleRepository;
import com.org.coop.society.data.admin.repositories.UserCredentialRepository;
import com.org.coop.society.data.admin.repositories.UserRepository;

@Service
public class BranchSetupServiceHelperImpl {

	private static final Logger log = Logger.getLogger(BranchSetupServiceHelperImpl.class); 
	
	@Autowired
	private BranchMasterRepository branchMasterRepository;
	
	@Autowired
	private CustomBranchModuleRepository customBranchModuleRepository;
	
	@Autowired
	private BranchMappingImpl branchMappingImpl;
	
	@Autowired
	private MasterDataSetupServiceImpl masterDataSetupServiceImpl;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private UserCredentialRepository userCredentialRepository;
	
	@Transactional(value="adminTransactionManager")
	public UIModel addOrUpdateBranch(UIModel uiModel) {
		// Check if the branch already exists
		BranchMaster branch = null;
		if(uiModel.getBranchBean().getBranchId() == 0) {
			branch = branchMasterRepository.findByMicrCodeAndIfscCode(uiModel.getBranchBean().getMicrCode(), uiModel.getBranchBean().getIfscCode());
		} else {
			branch = branchMasterRepository.findOne(uiModel.getBranchBean().getBranchId());
		}
		if(branch != null && uiModel.getBranchBean().getBranchId() == 0) {
			uiModel.setErrorMsg("Branch already exists");
			return uiModel;
		}
		if(branch == null) {
			branch = new BranchMaster();
		}
		
		branchMappingImpl.mapBean(uiModel.getBranchBean(), branch);
		
		//************************************************
		// Check if new user getting saved. If yes then save the object without User_Credential data. Once user is saved then save user_credential data
		//*************************************************
		UserCredential userCredential = null;
		String userName = null;
		if(branch.getUsers() != null && branch.getUsers().size() > 0) {
			for(User u : branch.getUsers()) {
				if(u.getUserCredential() != null && u.getUserCredential().getUserId() == 0) { // New user
					userName = u.getUserName();
					userCredential = u.getUserCredential();
					u.setUserCredential(null);
				}
			}
		}
		
		
		branchMasterRepository.saveAndFlush(branch);
		
		//*********************************************
		// Save user credential separately
		//**********************************************
		if(userCredential != null) {
			User newUser = userRepository.findByUserName(userName);
			userCredential.setUser(newUser);
			userCredential.setUserId(newUser.getUserId());
			userCredentialRepository.saveAndFlush(userCredential);
			if(log.isDebugEnabled()) {
				log.debug("User credential is saved separately");
			}
		}
		
		uiModel.getBranchBean().setBranchId(branch.getBranchId());
		log.debug("A new branch has been created");
		return uiModel;
	}
	
	@Transactional(value="adminTransactionManager")
	public UIModel getBranch(int branchId) {
		UIModel uiModel = new UIModel();
		// Check if the branch already exists
		BranchMaster branch = branchMasterRepository.findOne(branchId);
		if(branch == null) {
			uiModel.setErrorMsg("Branch does not exist for Branch Id: " + branchId);
			return uiModel;
		}
		BranchBean branchBean = new BranchBean();
		branchMappingImpl.mapBean(branch, branchBean);
		uiModel.setBranchBean(branchBean);
		
		// Fetch branch modules
		List<CustomBranchModule> branchModules = customBranchModuleRepository.findByBranchId(branchId);
		List<BranchModuleBean> branchModuleBeans = new ArrayList<BranchModuleBean>();
		for(CustomBranchModule branchModule : branchModules) {
			BranchModuleBean bbm = new BranchModuleBean();
			branchMappingImpl.mapBranchModuleBean(branchModule, bbm);
			branchModuleBeans.add(bbm);
			
			// Retrieve module permission
			MasterDataBean masterDataBean = masterDataSetupServiceImpl.getModuleRulesAndPermissions(bbm.getModuleName());
			if(masterDataBean != null && masterDataBean.getModules() != null && masterDataBean.getModules().size() > 0) {
				ArrayList<ModuleMasterBean> lst = new ArrayList<ModuleMasterBean>();
				lst.addAll(masterDataBean.getModules());
				bbm.setBranchModulePermissions(lst.get(0).getModulePermissions());
			}
		}
		branchBean.setModules(branchModuleBeans);
		
		log.debug("Branch details has been retrieved from database for branchId: " + branchId);
		return uiModel;
	}
}

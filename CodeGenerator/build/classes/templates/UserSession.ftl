package ${package}.jbpm;

import java.util.LinkedList;
import java.util.List;

import org.jbpm.api.identity.Group;
import org.jbpm.api.identity.User;
import org.jbpm.pvm.internal.env.EnvironmentImpl;
import org.jbpm.pvm.internal.identity.spi.IdentitySession;

import ${package}.dao.UserDao;
import ${package}.domain.Role;

public class UserSession implements IdentitySession{
	
	private UserDao userDao;
	
	@Override
	public String createUser(String userId, String givenName,
			String familyName, String businessEmail) {
		return null;
	}

	@Override
	public User findUserById(String userId) {
		return null;
	}

	@Override
	public List<User> findUsersById(String... userIds) {
		return null;
	}

	@Override
	public List<User> findUsers() {
		return null;
	}

	@Override
	public void deleteUser(String userId) {
		
	}

	@Override
	public String createGroup(String groupName, String groupType,
			String parentGroupId) {
		return null;
	}

	@Override
	public List<User> findUsersByGroup(String groupId) {
		return null;
	}

	@Override
	public Group findGroupById(String groupId) {
		return null;
	}

	@Override
	public List<Group> findGroupsByUserAndGroupType(String userId,
			String groupType) {
		return null;
	}

	@Override
	public List<Group> findGroupsByUser(String userId) {
		List<Group> groups = new LinkedList<>();
		UserDao userDao = EnvironmentImpl.getFromCurrent(UserDao.class);
		List<Role> roles = userDao.get(userId).getRoles();
		for (Role role : roles) {
			groups.add(role);
		}
		return groups;
	}

	@Override
	public void deleteGroup(String groupId) {
		
	}

	@Override
	public void createMembership(String userId, String groupId, String role) {
		
	}

	@Override
	public void deleteMembership(String userId, String groupId, String role) {
		
	}

	public UserDao getUserDao() {
		return userDao;
	}

	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

}

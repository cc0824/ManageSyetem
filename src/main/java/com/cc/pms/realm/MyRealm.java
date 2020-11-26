package com.cc.pms.realm;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;

import com.cc.pms.bean.User;
import com.cc.pms.service.UserService;

/**
 * �Զ����û�����Ȩ��
 * @author cc
 *
 */
public class MyRealm extends AuthorizingRealm{

	@Autowired
	private UserService userService;
	
	/**
	 * Ϊ��ǰ�ĵ�¼���û���ɫ��Ȩ��
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		return null;
	}
	
	
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken token) throws AuthenticationException {
		System.out.println("[MyRealm] doGetAuthenticationInfo");
		
		//1. �� AuthenticationToken ת��Ϊ UsernamePasswordToken 
		UsernamePasswordToken upToken = (UsernamePasswordToken) token;
		
		//2. �� UsernamePasswordToken ������ȡ username
		String username = upToken.getUsername();
		
		//3. �������ݿ�ķ���, �����ݿ��в�ѯ username ��Ӧ���û���¼
		System.out.println("�����ݿ��л�ȡ username: " + username + " ����Ӧ���û���Ϣ.");
		
		//4. ���û�������, ������׳� UnknownAccountException �쳣
		if("unknown".equals(username)){
			throw new UnknownAccountException("�û�������!");
		}
		
		//5. �����û���Ϣ�����, �����Ƿ���Ҫ�׳������� AuthenticationException �쳣. 
		//����
		if("monster".equals(username)){
			throw new LockedAccountException("�û�������");
		}
		
		//6. �����û������, ������ AuthenticationInfo ���󲢷���. ͨ��ʹ�õ�ʵ����Ϊ: SimpleAuthenticationInfo
		//������Ϣ�Ǵ����ݿ��л�ȡ��.
		//1). principal: ��֤��ʵ����Ϣ. ������ username, Ҳ���������ݱ��Ӧ���û���ʵ�������. 
		Object principal = username;
		//2). credentials: ����. 
		Object credentials = null; //"fc1709d0a95a6be30bc5926fdb7f22f4";
		if("admin".equals(username)){
			credentials = "038bdaf98f2037b31f1e75b5b4c9b26e";
		}else if("user".equals(username)){
			credentials = "098d2c478e9c11555ce2823231e02ec1";
		}
		
		//3). realmName: ��ǰ realm ����� name. ���ø���� getName() ��������
		String realmName = getName();
		//4). ��ֵ. 
		ByteSource credentialsSalt = ByteSource.Util.bytes(username);
		
		SimpleAuthenticationInfo info = null; //new SimpleAuthenticationInfo(principal, credentials, realmName);
		info = new SimpleAuthenticationInfo(principal, credentials, credentialsSalt, realmName);
		return info;
	}

	/**
	 * ��֤��ǰ��¼���û�
	 */
//	@Override
//	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
//		String UserName=(String) token.getPrincipal();
//		User user=userService.getByUserName(UserName);
//		if(user!=null){
//			SecurityUtils.getSubject().getSession().setAttribute("currentUser", user); // �ѵ�ǰ�û���Ϣ�浽session��
//			AuthenticationInfo authcInfo=new SimpleAuthenticationInfo(user.getUserName(), user.getUserPassword(), "xxx");
//			return authcInfo;
//		}else{
//			return null;			
//		}
//	}

}

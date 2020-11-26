package com.cc.pms.bean;


public class TreeNode {
	Integer id;
	Integer pid;
	String val;
    public TreeNode left;
    public TreeNode right;
    
    public TreeNode(String x) { val = x; }
    
    
	public TreeNode(Integer id, Integer pid, String val) {
		super();
		this.id = id;
		this.pid = pid;
		this.val = val;
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "id="+id+",pid="+pid+",val="+val;
	}



	public Integer getId() {
		return id;
	}


	public void setId(Integer id) {
		this.id = id;
	}


	public Integer getPid() {
		return pid;
	}


	public void setPid(Integer pid) {
		this.pid = pid;
	}


	public String getVal() {
		return val;
	}
	public void setVal(String val) {
		this.val = val;
	}
	public TreeNode getLeft() {
		return left;
	}
	public void setLeft(TreeNode left) {
		this.left = left;
	}
	public TreeNode getRight() {
		return right;
	}
	public void setRight(TreeNode right) {
		this.right = right;
	}
	
}


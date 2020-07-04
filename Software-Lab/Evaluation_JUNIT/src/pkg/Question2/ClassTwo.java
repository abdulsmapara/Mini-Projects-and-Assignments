package pkg.Question2;


public class ClassTwo {
	private String msg;
	//message
	
	public ClassTwo(String msg) {
		this.msg = msg;
	}
	public void printMsg() {
		System.out.println(msg);
		int a=1,b=0;
		int divide = a/b;
	}
	public void printMsg_Hi() {
		String another_but_hi = "Hi! This is another message!";
		System.out.println(another_but_hi);
	}
	public void concatRev(String extend) {
		extend.concat(msg);
	}
}

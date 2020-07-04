class Vars{
	int y;
	static int x;

	String str;
	static{
		System.loadLibrary("myNative");
	}	
	Vars(){
		x=y=100;
		str="initial";
	}

	public native void demo();
	public static void main(String[] args) {
		Vars v = new Vars();
		v.demo();
	}
}
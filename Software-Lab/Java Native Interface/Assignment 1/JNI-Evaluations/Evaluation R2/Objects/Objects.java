class Objects{
	static{
		System.loadLibrary("myNative");
	}
	int x;

	public Objects(){
		x = 10;
		System.out.println("Object Created");
	}
	public static native void create();
	public static void main(String[] args) {
		Objects.create();	
	}

}
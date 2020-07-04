class CallBack{
	static{
		System.loadLibrary("myNative");
	}

	public native void callMe(int depth);

	public void callBack(int depth)
	{
		if(depth < 5)
		{
			System.out.println("Depth = "+depth+" about to enter C");
			callMe(depth+1);
			System.out.println("Depth = "+depth+" back from C");
		}else{
			System.out.println("Limit exceeded "+depth);
		}
	}

	public static void main(String[] args) {
		CallBack cb = new CallBack();
		cb.callMe(0);
	}

}
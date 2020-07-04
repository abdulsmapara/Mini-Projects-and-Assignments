class Driver{

	static{
		System.loadLibrary("myNative");
	}

	public static void main(String[] args) throws ClassNotFoundException{
		CallMethods call;
		SomeMethods some;
		call = new CallMethods();
		some = new SomeMethods();
		call.callOne(some);
		Class cl = Class.forName("SomeMethods");
		call.callTwo(cl);
	}
}
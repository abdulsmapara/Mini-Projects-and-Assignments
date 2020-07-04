class Exceptions{

	static{
		System.loadLibrary("myNative");
	}

	private native void CatchThrow() throws IllegalArgumentException;
	private native void another() throws IllegalArgumentException;
	private void call() throws NullPointerException{
		throw new NullPointerException("Thrown null pointer exception");
	}
	public static void main(String[] args) {
		Exceptions exp = new Exceptions();
		try{
			exp.CatchThrow();
		}catch(Exception e){
			System.out.println("In java "+e);
		}

		try{
			exp.another();

		}catch(Exception e){
			System.out.println("Using throw "+e);
		}
	}
}
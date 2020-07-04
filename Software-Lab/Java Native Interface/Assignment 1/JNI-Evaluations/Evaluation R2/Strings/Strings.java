import java.util.*;
class Strings{

	static
	{
		System.loadLibrary("myNative");
	}
	public native void print(String str);
	public native String give();
	public static void main(String[] args) {
		Strings str = new Strings();
		str.print("Hello! Strings in Java");

		System.out.println(str.give());
	}

}
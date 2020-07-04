public class Number
{
	static
	{
		System.loadLibrary("NativeLib");
	}
	public native void welcome();
	public native int factorial(int n);
	public native void print_string(String str);
	public static void main(String[] args) 
	{
			Number num= new Number();
			num.welcome();
			System.out.println("factorial "+num.factorial(5));
			num.print_string("String in JAVA");
	}	
}
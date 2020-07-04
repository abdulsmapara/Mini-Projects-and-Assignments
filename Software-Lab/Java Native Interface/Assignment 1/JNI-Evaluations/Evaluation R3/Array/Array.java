public class Array
{
	static
	{ 
		System.loadLibrary("myNative"); 
	}
	public native static Object [] mkArray(int sz);
	public native Object ret(Domino[] obj,int sz);
	public static void main(String [] args)
	{
		Domino [] da = (Domino [])mkArray(5);
		for (int k = 0; k < da.length; k++)
			System.out.println("arr[" + k + "] = " + da[k].i);
		Array my = new Array();
		da[0].i=5000;
		da[1].i=6000;
		da[2].i=7000;
		Object ob = (my.ret(da,5));
		System.out.println("Demo=====");
		for (int x=0;x<5;x++) {
			System.out.println(da[x].i);	
		}
	}
}
class Domino{
	public int i;
	Domino(int x){
		i = x;
	}

}
public class SetSomeVars{
	static{
		System.loadLibrary("myNative");
	}
	public native void modifyx(Vars c,int val);
	public native void modifyy(Vars c,int val);



}

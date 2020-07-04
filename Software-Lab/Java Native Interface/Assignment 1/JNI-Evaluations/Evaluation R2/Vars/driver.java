	
class driver{
	
	public static void main(String[] args) throws ClassNotFoundException {
		Vars someVars = new Vars();
		SetSomeVars obj = new SetSomeVars();
		Class var = Class.forName("Vars");
		obj.modifyx(someVars,10);
		obj.modifyy(someVars,20);
		someVars.print();
	}
}
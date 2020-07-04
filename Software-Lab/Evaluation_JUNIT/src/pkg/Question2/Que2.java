package pkg.Question2;
import org.junit.*;

import pkg.Question2.ClassTwo;



public class Que2 {
	
	ClassTwo obj = new ClassTwo("Abdul Sattar Mapara here!");
	
	@Test(expected = ArithmeticException.class)
	public void test1() {
		System.out.println("JUNIT IS EXPECTING AN EXCEPTION!");
		obj.printMsg();
		
	}
	@Test(expected = NullPointerException.class)
	public void test2() {
		System.out.println("JUNIT IS EXPECTING AN EXCEPTION!");
		obj.concatRev(null);
	}
	
	
	
	
}

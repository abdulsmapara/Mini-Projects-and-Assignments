package pkg.Question5;
import static org.junit.Assert.*;
import org.junit.*;

public class Que5 {
	ClassFive obj = new ClassFive();
	int variable_even=2;
	int variable_odd=3;
	String s1="Non Null";
	String s3 = "Bye!";
	String s2=null;
	@Test
	public void testIsEven() {
		assertTrue(obj.isEven(variable_even));
		assertFalse(obj.isEven(variable_odd));
	}
	@Test
	public void testAsserts() {
		assertNull(s2);
		assertNotNull(s1);
		assertSame(5,obj.add(1,4));
		assertNotSame(obj.retHi(),s3);
	}
	
}

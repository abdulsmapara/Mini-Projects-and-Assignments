package pkg.Question4;
import java.util.Arrays;
import java.util.Collection;
import org.junit.Test;
import org.junit.Before;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import org.junit.runner.RunWith;
import static org.junit.Assert.assertEquals;


@RunWith(Parameterized.class)
public class Que4 {
	private Integer a1,b1;
	private int expected_result;
	private ClassFour obj;
	@Before
	public void init() {
		obj = new ClassFour();
	}
	public Que4(Integer n1,Integer n2, int expected){
		this.a1 = n1;
		this.b1 = n2;
		this.expected_result = expected;
	}
	
	@Parameterized.Parameters
	public static Collection numbers() {
		return Arrays.asList(new Object[][] {
			{2,5,7},
			{1,3,4},
			{-1,-2,-3},
			{0,5,5}
		});
	}
	
	@Test
	public void testFunc(){
		System.out.println("The parameterized numbers "+a1+" "+b1);
		assertEquals(expected_result,obj.add(a1, b1));
	}
}

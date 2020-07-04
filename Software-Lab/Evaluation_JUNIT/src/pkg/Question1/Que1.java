package pkg.Question1;


import org.junit.*;

public class Que1 {
	
	@BeforeClass
	public static void method1() {
		System.out.println("\tWELCOME!!!");
	}
	
	@Before
	public void before1() {
		for(int i=0;i<21;++i) {
			System.out.print("%");
		}
		System.out.println();
	}
	@Test
	public void Test1() {
		System.out.println("Repeatedly Doing The");
	}
	@Test
	public void Test2() {
		System.out.println("SAME");
	}
	@Test
	public void Test3() {
		System.out.println("Thing and Expecting");
	}
	@Test
	public void Test4() {
		System.out.println("DIFFERENT");
	}
	@Test
	public void Test5() {
		System.out.println("Result");
	}
	
	@After
	public void after1() {
		for(int i=0;i<21;i++) {
			System.out.print("#");
		}
		System.out.println("\n");
	}
	
	@AfterClass
	public static void method_after_class() {
		System.out.println("\tGOODBYE!!!");
	}
	
	
}

package pkg.Question5;
import org.junit.runner.JUnitCore;		
import org.junit.runner.Result;		
import org.junit.runner.notification.Failure;	

public class Runner5 {
	public static void main(String[] args) {									
	      Result result = JUnitCore.runClasses(Que5.class);					
				for(Failure failure : result.getFailures()) {							
	         System.out.println(failure.toString());					
	      }		
	      System.out.println("Result=="+result.wasSuccessful());							
	   }		
}

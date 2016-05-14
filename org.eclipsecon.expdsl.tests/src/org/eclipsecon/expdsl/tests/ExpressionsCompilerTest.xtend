package org.eclipsecon.expdsl.tests

import com.google.inject.Inject
import java.io.ByteArrayOutputStream
import java.io.PrintStream
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.TemporaryFolder
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.eclipse.xtext.xbase.lib.util.ReflectExtensions
import org.eclipsecon.expdsl.ExpressionsInjectorProvider
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsInjectorProvider))
class ExpressionsCompilerTest {
	
	@Rule @Inject public TemporaryFolder temporaryFolder 
	@Inject extension CompilationTestHelper
	@Inject extension ReflectExtensions

	@Test def void testGeneratedJavaCode() {
		'''
		int i = 0
		int j = i + 1
		i > 0 || (j < i)
		'''.assertCompilesTo(
		'''
package expressions;

@SuppressWarnings("all")
public class MyFile {
	public void eval() {
		int i = 0;
		int j = (i + 1);
		System.out.println("" + ((i > 0) || (j < i)));
	}
}
		'''
		)
	}

	@Test def void testCorrectJavaCode() {
		'''
		int i = 0
		int j = i + 1
		bool b = i <= 0
		b
		string s = "this is b: " + b
		b || (j < i)
		s < "a"
		'''.compile[
			// this will compile the generated Java code
			compiledClass
		]
	}

	@Test def void testExecuteJavaCode() {
		'''
		int i = 0
		int j = i + 1
		bool b = i <= 0
		b // this should be true
		string s = "this is b: " + b
		b && (j < i) // this should be false
		"is A < b ? " + ("A" < "b")
		'''.compile[
			val out = new ByteArrayOutputStream()
			val backup = System.out
			System.setOut(new PrintStream(out))
			try {
				// instantiate the compiled Java class
				val obj = it.compiledClass.newInstance
				obj.invoke('eval')
			} finally {
				System.setOut(backup)
			}
			'''
			true
			false
			is A < b ? true
			'''.toString.assertEquals(out.toString)
		]
	}

	@Test def void testAllExpressions() {
		'''
		0
		true
		"a"
		!true
		1*2
		1/2
		1-2
		1==2
		"a"=="b"
		1!=2
		"a"!="b"
		bool b = false
		string s = "this is b: " + b
		s
		'''.compile[
'''
package expressions;

@SuppressWarnings("all")
public class MyFile {
	public void eval() {
		System.out.println("" + 0);
		System.out.println("" + true);
		System.out.println("" + "a");
		System.out.println("" + !(true));
		System.out.println("" + (1 * 2));
		System.out.println("" + (1 / 2));
		System.out.println("" + (1 - 2));
		System.out.println("" + (1 == 2));
		System.out.println("" + ("a".equals("b") == true));
		System.out.println("" + (1 != 2));
		System.out.println("" + ("a".equals("b") != true));
		boolean b = false;
		String s = ("this is b: " + b);
		System.out.println("" + s);
	}
}
'''.toString.assertEquals(singleGeneratedCode)
			// this will compile the generated Java code
			compiledClass
		]
	}
}

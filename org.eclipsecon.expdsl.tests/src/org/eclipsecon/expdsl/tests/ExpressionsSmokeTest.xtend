package org.eclipsecon.expdsl.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipsecon.expdsl.ExpressionsInjectorProvider
import org.junit.runner.RunWith
import com.google.inject.Inject
import org.eclipsecon.expdsl.generator.ExpressionsGenerator
import org.junit.Test

/**
 * Just for testing corner cases
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsInjectorProvider))
class ExpressionsSmokeTest {
	
	@Inject ExpressionsGenerator expressionGenerator

	@Test(expected=IllegalArgumentException)
	def void testCompileToJaveWithNullExpression() {
		expressionGenerator.compileToJava(null)
	}
}
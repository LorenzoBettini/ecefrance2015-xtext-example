package org.eclipsecon.expdsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipsecon.expdsl.ExpressionsInjectorProvider
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.expressions.ExpressionsPackage
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import org.eclipsecon.expdsl.validation.ExpressionsValidator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsInjectorProvider))
class ExpressionsValidatorTest {
	
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ValidationTestHelper
	
	@Test
	def void testForwardReference() {
		val input = '''
			int i = j
			int j = 10
		'''
		input.parse.assertError(
			// type of the element with error
			ExpressionsPackage.Literals.VARIABLE_REF,
			// error code
			ExpressionsValidator.FORWARD_REFERENCE,
			input.indexOf("j"), // offset of expected error
			1, 					// length of the region with error
			// expected error message
			"variable forward reference not allowed: 'j'"
		)
	}

	@Test
	def void testForwardReferenceInExpression() {
		'''int i = 1 j+i int j = 10'''.parse => [
			assertError(ExpressionsPackage::eINSTANCE.variableRef,
				ExpressionsValidator.FORWARD_REFERENCE,
				"variable forward reference not allowed: 'j'"
			)
			
			// check that's the only error
			1.assertEquals(validate.size)
		]
	}

}
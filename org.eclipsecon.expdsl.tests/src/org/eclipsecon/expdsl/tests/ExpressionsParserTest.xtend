package org.eclipsecon.expdsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipsecon.expdsl.ExpressionsInjectorProvider
import org.eclipsecon.expdsl.expressions.And
import org.eclipsecon.expdsl.expressions.BoolConstant
import org.eclipsecon.expdsl.expressions.Comparison
import org.eclipsecon.expdsl.expressions.Equality
import org.eclipsecon.expdsl.expressions.Expression
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.expressions.IntConstant
import org.eclipsecon.expdsl.expressions.Minus
import org.eclipsecon.expdsl.expressions.MulOrDiv
import org.eclipsecon.expdsl.expressions.Not
import org.eclipsecon.expdsl.expressions.Or
import org.eclipsecon.expdsl.expressions.Plus
import org.eclipsecon.expdsl.expressions.StringConstant
import org.eclipsecon.expdsl.expressions.VariableRef
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsInjectorProvider))
class ExpressionsParserTest {
	
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ValidationTestHelper
	
	@Test
	def void testSimpleExpression() {
		'''10'''.parse.assertNoErrors
	}

	@Test
	def void testVariableExpression() {
		'''int i = 10'''.parse.assertNoErrors
	}

	@Test
	def void testStringConstantExpression() {
		'''"test"'''.parse.assertNoErrors
	}

	@Test
	def void testBooleanConstantExpression() {
		'''true'''.parse.assertNoErrors
	}

	@Test
	def void testVariableReference() {
		val e =
		'''
		int i = 10
		i
		'''.parse
		e.assertNoErrors;
		
		(e.elements.get(1) as VariableRef).variable.
			assertSame(e.elements.get(0))
	}

	@Test
	def void testParenthesis() {
		"(10)".parse.elements.get(0) as IntConstant
	}

	@Test
	def void testPlus() {
		"10 + 5 + 1 + 2".assertRepr("(((10 + 5) + 1) + 2)")
	}

	@Test def void testPlusWithParenthesis() {
		"( 10 + 5 ) + ( 1 + 2 )".assertRepr("((10 + 5) + (1 + 2))")
	}

	@Test
	def void testMinus() {
		"10 + 5 - 1 - 2".assertRepr("(((10 + 5) - 1) - 2)")
	}

	@Test
	def void testMulOrDiv() {
		"10 * 5 / 1 * 2".assertRepr("(((10 * 5) / 1) * 2)")
	}

	@Test
	def void testPlusMulPrecedence() {
		"10 + 5 * 2 - 5 / 1".assertRepr("((10 + (5 * 2)) - (5 / 1))")
	}

	@Test def void testComparison() {
		"10 <= 5 < 2 > 5".assertReprNoValidation("(((10 <= 5) < 2) > 5)")
	}

	@Test def void testEqualityAndComparison() {
		"true == 5 <= 2".assertRepr("(true == (5 <= 2))")
	}

	@Test def void testAndOr() {
		"true || false && 1 < 0".assertRepr("(true || (false && (1 < 0)))")
	}

	@Test def void testNot() {
		"!true||false".assertRepr("((!true) || false)")
	}

	@Test def void testNotWithParentheses() {
		"!(true||false)".assertRepr("(!(true || false))")
	}
	
	@Test def void testPrecedences() {
		"!true||false&&1>(1/3+5*2)".
		assertRepr("((!true) || (false && (1 > ((1 / 3) + (5 * 2)))))")
	}

	def assertRepr(CharSequence input, CharSequence expected) {
		input.parse => [
			assertNoErrors;
			expected.assertEquals(
				(elements.last as Expression).stringRepr
			)
		]
	}

	def assertReprNoValidation(CharSequence input, CharSequence expected) {
		input.parse => [
			expected.assertEquals(
				(elements.last as Expression).stringRepr
			)
		]
	}

	def String stringRepr(Expression e) {
		switch (e) {
			Plus:
			'''(«e.left.stringRepr» + «e.right.stringRepr»)'''
			Minus:
			'''(«e.left.stringRepr» - «e.right.stringRepr»)'''
			MulOrDiv:
			'''(«e.left.stringRepr» «e.op» «e.right.stringRepr»)'''
			Comparison:
			'''(«e.left.stringRepr» «e.op» «e.right.stringRepr»)'''
			Equality:
			'''(«e.left.stringRepr» «e.op» «e.right.stringRepr»)'''
			And:
			'''(«e.left.stringRepr» && «e.right.stringRepr»)'''
			Or:
			'''(«e.left.stringRepr» || «e.right.stringRepr»)'''
			Not:
			'''(!«e.expression.stringRepr»)'''
			IntConstant: '''«e.value»'''
			StringConstant: '''«e.value»'''
			BoolConstant: '''«e.value»'''
			VariableRef: '''«e.variable.name»'''
		}
	}
}

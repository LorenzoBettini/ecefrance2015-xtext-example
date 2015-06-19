package org.eclipsecon.expdsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipsecon.expdsl.ExpressionsInjectorProvider
import org.eclipsecon.expdsl.expressions.Comparison
import org.eclipsecon.expdsl.expressions.Equality
import org.eclipsecon.expdsl.expressions.Expression
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.expressions.Plus
import org.eclipsecon.expdsl.expressions.Type
import org.eclipsecon.expdsl.expressions.Variable
import org.eclipsecon.expdsl.typing.ExpressionsTypeProvider
import org.eclipsecon.expdsl.typing.ExpressionsTypeUtils
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import org.eclipsecon.expdsl.expressions.ExpressionsFactory

@RunWith(XtextRunner)
@InjectWith(ExpressionsInjectorProvider)
class ExpressionsTypeProviderTest {
	
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ExpressionsTypeProvider
	@Inject extension ExpressionsTypeUtils

	@Test(expected=IllegalArgumentException)
	def void inferredTypeWithNull() { null.inferredType }

	@Test(expected=IllegalArgumentException)
	def void expectedTypeWithNullContainer() {
		ExpressionsFactory.eINSTANCE.createIntConstant.expectedType
	}
	
	@Test def void intConstant() { "10".assertIntType }
	@Test def void stringConstant() { "'foo'".assertStringType }
	@Test def void boolConstant() { "true".assertBoolType }
	
	@Test def void varWithoutExpression() { "int i = ".assertIntType }
	@Test def void varWithExpression() { "int i = 0".assertIntType }
	@Test def void varWithDeclaredType() { "int i = true".assertIntType }
	
	@Test def void varRef() { "int i = 0 string j = 's' i".assertIntType }
	@Test def void varRefUnresolved() { "i".assertUnknownType }
	@Test def void varRefToVarDefinedAfter() { "int i = j int j = i i".assertIntType }
	
	@Test def void notExp() { "!true".assertBoolType }
	
	@Test def void multiExp() { "1 * 2".assertIntType }
	@Test def void divExp() { "1 / 2".assertIntType }
	
	@Test def void minusExp() { "1 - 2".assertIntType }
	
	@Test def void plusIncomplete() { "1 + ".assertIntType }
	@Test def void numericPlus() { "1 + 2".assertIntType }
	@Test def void stringPlus() { "'a' + 'b'".assertStringType }
	@Test def void numAndStringPlus() { "'a' + 2".assertStringType }
	@Test def void numAndStringPlus2() { "2 + 'a'".assertStringType }
	@Test def void boolAndStringPlus() { "'a' + true".assertStringType }
	@Test def void boolAndStringPlus2() { "false + 'a'".assertStringType }
	
	@Test def void comparisonExp() { "1 < 2".assertBoolType }
	@Test def void equalityExp() { "1 == 2".assertBoolType }
	@Test def void andExp() { "true && false".assertBoolType }
	@Test def void orExp() { "true || false".assertBoolType }
	
	@Test def void testIncompleteModel() {
		"1 == ".assertBoolType
	}
	
	@Test def void mulExpectsInt() { 
		"true * false".assertExpectedType("int")
	}

	@Test def void divExpectsInt() { 
		"true / false".assertExpectedType("int")
	}

	@Test def void minusExpectsInt() { 
		"true - false".assertExpectedType("int")
	}

	@Test def void andExpectsBoolean() { 
		"true && 0".assertExpectedType("boolean")
	}

	@Test def void orExpectsBoolean() { 
		"true || 0".assertExpectedType("boolean")
	}

	@Test def void notExpectsBoolean() { 
		"!0".assertExpectedType("boolean")
	}

	@Test def void nonContainedExpressionHasNoExpectations() { 
		"0".assertExpectedType("Unknown")
	}

	@Test def void initializationExpressionExpectedType() { 
		"int i = 's'".assertVariableDeclarationExpectedTypes("int")
		"string i = 1".assertVariableDeclarationExpectedTypes("String")
		"bool i = 1".assertVariableDeclarationExpectedTypes("boolean")
	}

	@Test def void plusExpectsIntOrString() {
		"1 + true".assertPlusExpectedTypes("int", "int")
		"true + 1".assertPlusExpectedTypes("int", "int")
		"'1' + true".assertPlusExpectedTypes("String", "String")
		"true + '1'".assertPlusExpectedTypes("String", "String")
	}

	@Test def void testExpectedWithIncompleteModel() {
		// when the right expression is null the expectation is
		// simply string since everything is assignable to string
		"1 == ".assertExpectTheSameType("Unknown", null)
		"true + ".assertPlusExpectedTypes("int", null)
		"'s' + ".assertPlusExpectedTypes("String", null)
		"'s' <= ".assertComparisonExpectedTypes("Unknown", null)
	}
	
	@Test def void testIsInt() { 
		(ExpressionsTypeProvider::intType).isInt.assertTrue
	}

	@Test def void testIsString() { 
		(ExpressionsTypeProvider::stringType).isString.assertTrue
	}

	@Test def void testIsBool() { 
		(ExpressionsTypeProvider::boolType).isBoolean.assertTrue
	}
	
	def assertStringType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider.stringType)
	}
	
	def assertIntType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider.intType)
	}

	def assertBoolType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider.boolType)		
	}

	def private assertUnknownType(CharSequence input) {
		input.assertType(null)		
	}

	def private assertType(CharSequence input, Type expectedType) {
		expectedType?.eClass.assertSame
			(input.parse.elements.last.inferredType?.eClass)
	}
	
	def private assertExpectedType(CharSequence input, CharSequence expectation) {
		val lastElement = input.parse.elements.last as Expression
		val rightMostExpression = lastElement.eAllContents.filter(Expression).last ?: lastElement
		
		expectation.toString.assertEquals
			(rightMostExpression.
				expectedType.representation)
	}

	def private assertVariableDeclarationExpectedTypes(CharSequence input, CharSequence expectation) {
		val variable = input.parse.elements.last as Variable
		
		expectation.toString.assertEquals
			(variable.expression.
				expectedType.representation)
	}

	def private assertExpectTheSameType(CharSequence input, CharSequence expectedLeft, CharSequence expectedRight) {
		val equality = input.parse.elements.last as Equality
		
		expectedLeft.assertEquals(
			equality.left.expectedType.representation)
		if (expectedRight === null)
			equality.right.assertNull
		else
			expectedRight.assertEquals(
				equality.right.expectedType.representation)
	}

	def private assertPlusExpectedTypes(CharSequence input, CharSequence expectedLeft, CharSequence expectedRight) {
		val plus = input.parse.elements.last as Plus
		
		expectedLeft.assertEquals(
			plus.left.expectedType.representation)
		if (expectedRight === null)
			plus.right.assertNull
		else
			expectedRight.assertEquals(
				plus.right.expectedType.representation)
	}
	
	def private assertComparisonExpectedTypes(CharSequence input, CharSequence expectedLeft, CharSequence expectedRight) {
		val comparison = input.parse.elements.last as Comparison
		
		expectedLeft.assertEquals(
			comparison.left.expectedType.representation)
		if (expectedRight === null)
			comparison.right.assertNull
		else
			expectedRight.assertEquals(
				comparison.right.expectedType.representation)
	}
	
}
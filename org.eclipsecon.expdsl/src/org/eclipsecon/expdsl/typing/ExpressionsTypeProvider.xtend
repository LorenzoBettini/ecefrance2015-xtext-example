package org.eclipsecon.expdsl.typing

import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipsecon.expdsl.expressions.AbstractElement
import org.eclipsecon.expdsl.expressions.BoolType
import org.eclipsecon.expdsl.expressions.Expression
import org.eclipsecon.expdsl.expressions.ExpressionsFactory
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.expressions.IntType
import org.eclipsecon.expdsl.expressions.Plus
import org.eclipsecon.expdsl.expressions.StringType
import org.eclipsecon.expdsl.expressions.Type
import org.eclipsecon.expdsl.expressions.Variable
import org.eclipsecon.expdsl.expressions.VariableRef

import static org.eclipsecon.expdsl.expressions.ExpressionsPackage.Literals.*

class ExpressionsTypeProvider {
	
	static val factory = ExpressionsFactory.eINSTANCE
	public static val stringType = factory.createStringType
	public static val intType = factory.createIntType
	public static val boolType = factory.createBoolType

	val Map<EClass, Type> knownTypes
	val Map<EClass, Type> knownExpectedTypes

	new() {
		knownTypes = #{
			STRING_CONSTANT -> stringType,
			INT_CONSTANT -> intType,
			BOOL_CONSTANT -> boolType,
			NOT -> boolType,
			MUL_OR_DIV -> intType,
			MINUS -> intType,
			COMPARISON -> boolType,
			EQUALITY -> boolType,
			AND -> boolType,
			OR -> boolType
		}
		knownExpectedTypes = #{
			NOT -> boolType,
			MUL_OR_DIV -> intType,
			MINUS -> intType,
			AND -> boolType,
			OR -> boolType
		}
	}

	def dispatch Type inferredType(AbstractElement e) {
		knownTypes.get(e.eClass)
	}

	def dispatch Type inferredType(Plus e) {
		val leftType = e.left.inferredType
		val rightType = e.right?.inferredType
		if (leftType.isString || rightType.isString)
			stringType
		else
			intType
	}
	
	def dispatch Type inferredType(Variable variable) {
		return variable.declaredType
	}
	
	def dispatch Type inferredType(VariableRef varRef) {
		return varRef.variable.inferredType
	}
	
	def isInt(Type type) { type instanceof IntType }
	def isString(Type type) { type instanceof StringType }
	def isBoolean(Type type) { type instanceof BoolType }
	
	/**
	 * The expected type or null if there's no expectation
	 */
	def Type expectedType(Expression exp) {
		expectedType(exp.eContainer, exp)
	}

	def dispatch Type expectedType(ExpressionsModel container, Expression exp) {
		null // no expectation
	}

	def dispatch Type expectedType(EObject container, Expression exp) {
		if (container instanceof Variable) {
			return container.declaredType
		}
		
		return knownExpectedTypes.get(container.eClass)
	}

	def dispatch Type expectedType(Plus container, Expression exp) {
		val leftType = container.left.inferredType;
		val rightType = container.right?.inferredType;
		if (leftType.isString || rightType.isString) {
			stringType
		} else {
			intType
		}
	}

}
package org.eclipsecon.expdsl.typing

import org.eclipse.emf.ecore.EObject
import org.eclipsecon.expdsl.expressions.AbstractElement
import org.eclipsecon.expdsl.expressions.And
import org.eclipsecon.expdsl.expressions.BoolConstant
import org.eclipsecon.expdsl.expressions.BoolType
import org.eclipsecon.expdsl.expressions.Comparison
import org.eclipsecon.expdsl.expressions.Equality
import org.eclipsecon.expdsl.expressions.Expression
import org.eclipsecon.expdsl.expressions.ExpressionsFactory
import org.eclipsecon.expdsl.expressions.ExpressionsModel
import org.eclipsecon.expdsl.expressions.IntConstant
import org.eclipsecon.expdsl.expressions.IntType
import org.eclipsecon.expdsl.expressions.Minus
import org.eclipsecon.expdsl.expressions.MulOrDiv
import org.eclipsecon.expdsl.expressions.Not
import org.eclipsecon.expdsl.expressions.Or
import org.eclipsecon.expdsl.expressions.Plus
import org.eclipsecon.expdsl.expressions.StringConstant
import org.eclipsecon.expdsl.expressions.StringType
import org.eclipsecon.expdsl.expressions.Type
import org.eclipsecon.expdsl.expressions.Variable
import org.eclipsecon.expdsl.expressions.VariableRef

class ExpressionsTypeProvider {
	
	static val factory = ExpressionsFactory.eINSTANCE
	public static val stringType = factory.createStringType
	public static val intType = factory.createIntType
	public static val boolType = factory.createBoolType

	def dispatch Type inferredType(AbstractElement e) {
		null
	}
	
	def dispatch Type inferredType(Expression e) {
		switch (e) {
			StringConstant: stringType
			IntConstant: intType
			BoolConstant: boolType
			Not: boolType
			MulOrDiv: intType
			Minus: intType
			Comparison: boolType
			Equality: boolType
			And: boolType
			Or: boolType
		}
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
		if (varRef.variable.eIsProxy)
			return null // we'll deal with that in the validator
		else
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
		switch (container) {
			Not: boolType
			MulOrDiv: intType
			Minus: intType
			And: boolType
			Or: boolType
			Variable: container.declaredType // if it's null then no expectation
		}
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
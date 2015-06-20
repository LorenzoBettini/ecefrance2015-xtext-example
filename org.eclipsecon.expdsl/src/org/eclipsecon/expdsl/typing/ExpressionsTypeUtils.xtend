package org.eclipsecon.expdsl.typing

import org.eclipsecon.expdsl.expressions.Type

import static org.eclipsecon.expdsl.expressions.ExpressionsPackage.Literals.*

class ExpressionsTypeUtils {

	val static javaTypeRepr = #{
		INT_TYPE -> "int",
		STRING_TYPE -> "String",
		BOOL_TYPE -> "boolean"
	}

	val static stringRepr = #{
		INT_TYPE -> "int",
		STRING_TYPE -> "string",
		BOOL_TYPE -> "bool"
	}

	def String javaRepresentation(Type type) {
		var String repr = null
		if (type != null) {
			repr = javaTypeRepr.get(type.eClass)
		}
		repr ?: "Unknown"
	}

	def String stringRepresentation(Type type) {
		return stringRepr.get(type.eClass)
	}
}
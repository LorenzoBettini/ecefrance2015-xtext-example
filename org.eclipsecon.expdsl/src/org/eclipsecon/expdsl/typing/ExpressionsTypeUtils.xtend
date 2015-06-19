package org.eclipsecon.expdsl.typing

import org.eclipsecon.expdsl.expressions.Type

import static org.eclipsecon.expdsl.expressions.ExpressionsPackage.Literals.*

class ExpressionsTypeUtils {

	val static typeRepr = #{
		INT_TYPE -> "int",
		STRING_TYPE -> "string",
		BOOL_TYPE -> "boolean"
	}

	def String representation(Type type) {
		var String repr = null
		if (type != null) {
			repr = typeRepr.get(type.eClass)
		}
		repr ?: "Unknown"
	}
}
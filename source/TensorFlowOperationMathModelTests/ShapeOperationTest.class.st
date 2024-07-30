Class {
	#name : #ShapeOperationTest,
	#superclass : #TensorFlowComputationBasedTest,
	#category : #TensorFlowOperationMathModelTests
}

{ #category : #Test }
ShapeOperationTest >> testBatchDimension [
	| input shape inputValue batchDimension |
	input := tf floatInputNamed: 'x'.
	shape := ShapeOperation of: input.
	batchDimension := shape batchDimension.
	inputValue := #(#(1.0 3.0 4.0) #(2.0 0.5 -0.1)) asFloatTensor.
	self
		assert:
			(tf
				compute: batchDimension
				feedingInputsWith:
					(Dictionary new
						at: 'x' put: inputValue;
						yourself))
		isIntegerVectorEqualsTo: #(2)
]

{ #category : #Test }
ShapeOperationTest >> testFlattenedDimensionSize [
	| input shape inputValue nonBatchDimension |
	input := tf floatInputNamed: 'x'.
	shape := ShapeOperation of: input.
	nonBatchDimension := shape flattenedDimensionSize.
	inputValue := #(#(1.0 3.0 4.0) #(2.0 0.5 -0.1)) asFloatTensor.
	self
		assert:
			(tf
				compute: nonBatchDimension
				feedingInputsWith:
					(Dictionary new
						at: 'x' put: inputValue;
						yourself))
		isIntegerScalarEqualTo: 3
]

{ #category : #Test }
ShapeOperationTest >> testFlattenedShape [
	| input shape inputValue nonBatchDimension |
	input := tf floatInputNamed: 'x'.
	shape := ShapeOperation of: input.
	nonBatchDimension := shape flattenedShape.
	inputValue := #(#(1.0 3.0 4.0) #(2.0 0.5 -0.1)) asFloatTensor.
	
	self
		assert:
			(tf
				compute: nonBatchDimension
				feedingInputsWith:
					(Dictionary new
						at: 'x' put: inputValue;
						yourself))
		isIntegerVectorEqualsTo: #(2 3).
	
	inputValue := #(
		#( #(1.0 3.0 4.0)
			#(1.0 3.0 4.0) )  
		#( #(2.0 0.5 -0.1) 
			#(2.0 0.5 -0.1) )
	) asFloatTensor.
	self
		assert:
			(tf
				compute: nonBatchDimension
				feedingInputsWith:
					(Dictionary new
						at: 'x' put: inputValue;
						yourself))
		isIntegerVectorEqualsTo: #(2 6).
	
]

{ #category : #Test }
ShapeOperationTest >> testNonBatchDimension [
	| input shape inputValue nonBatchDimension |
	input := tf floatInputNamed: 'x'.
	shape := ShapeOperation of: input.
	nonBatchDimension := shape nonBatchDimensions.
	inputValue := #(#(1.0 3.0 4.0) #(2.0 0.5 -0.1)) asFloatTensor.
	self
		assert:
			(tf
				compute: nonBatchDimension
				feedingInputsWith:
					(Dictionary new
						at: 'x' put: inputValue;
						yourself))
		isIntegerVectorEqualsTo: #(3).
		

	inputValue := #(
		#( #(1.0 3.0 4.0)
			#(1.0 3.0 4.0) )  
		#( #(2.0 0.5 -0.1) 
			#(2.0 0.5 -0.1) )
	) asFloatTensor.
	self
		assert:
			(tf
				compute: nonBatchDimension
				feedingInputsWith:
					(Dictionary new
						at: 'x' put: inputValue;
						yourself))
		isIntegerVectorEqualsTo: #(2 3).
]

{ #category : #Test }
ShapeOperationTest >> testNonBatchDimensionCase2 [
	
	| input nonBatchDimensions result expectedOutput |

	input :=
		InputTensor
			on: tf
			named: 'flatten_input'
			of: FloatDataType new
			shaped: #(-1 2 2) asTensorShape.

	nonBatchDimensions := input shape nonBatchDimensions.

	result :=
		tf
			compute: nonBatchDimensions
			feedingInputsWith: (
				Dictionary new
					at: input  operationName put: #(
	((1.11 1.12) (1.21 1.22))
	((2.11 2.12) (2.21 2.22))
	((3.11 3.12) (3.21 3.22))
) asFloatTensor;
					yourself).
	
	expectedOutput := #(2 2).

	self assert: result isIntegerVectorEqualsTo: expectedOutput 
]

{ #category : #Test }
ShapeOperationTest >> testNonBatchedDimension [
	| input flattenedShape |
	input := VariableTensor
		on: tf
		named: 'input'
		of: FloatDataType new
		shaped: #(1 2 3) asTensorShape
		initializedWith: (ConstantInitializer with: 1) .
	flattenedShape := input shape nonBatchDimensions.
	self assert: flattenedShape computeEagerly allElements equals: #(2 3)
]

{ #category : #Test }
ShapeOperationTest >> testOperationName [

	| shape |

	shape := ShapeOperation named: 'my-shape' of: (tf floatConstantWith: #((1) (2))).
	self assert: shape operationName equals: 'my-shape'.

	shape := ShapeOperation of: (tf floatConstantWith: #((1) (2))).
	self assert: shape operationName equals: 'Shape'


]

{ #category : #Test }
ShapeOperationTest >> testShapeOf3RankTensor [

	| inputValue expectedShape |

	inputValue := #(
		#( #(1.0 3.0 4.0)
			#(1.0 3.0 4.0) )  
		#( #(2.0 0.5 -0.1) 
			#(2.0 0.5 -0.1) )
	) asFloatTensor.
	expectedShape := #(2 2 3).

	self assertOutputOf: (tf constantWith: inputValue) shape isIntegerVectorEqualsTo: expectedShape.
	self
		assertOutputOf: (tf variableNamed: 'input' with: inputValue) shape
		isIntegerVectorEqualsTo: expectedShape.
	self
		assert: (
			tf
				compute: (tf floatInputNamed: 'x') shape
				feedingInputsWith: (
					Dictionary new
						at: 'x' put: inputValue;
						yourself))
		isIntegerVectorEqualsTo: expectedShape
]

{ #category : #Test }
ShapeOperationTest >> testShapeOfColumnVector [

	| scalar expectedShape |

	scalar := #((1.0) (2.0)) asFloatTensor.
	expectedShape := #(2 1).

	self assertOutputOf: (tf constantWith: scalar) shape isIntegerVectorEqualsTo: expectedShape.
	self
		assertOutputOf: (tf variableNamed: 'input' with: scalar) shape
		isIntegerVectorEqualsTo: expectedShape.
	self
		assert: (
			tf
				compute: (tf floatInputNamed: 'x') shape
				feedingInputsWith: (
					Dictionary new
						at: 'x' put: scalar;
						yourself))
		isIntegerVectorEqualsTo: expectedShape
]

{ #category : #Test }
ShapeOperationTest >> testShapeOfMatrix [
	| input shape scalar matrix |

	input := tf floatInputNamed: 'x'.
	shape := ShapeOperation of: input.

	scalar := #(#(1.0 3.0 4.0) #(2.0 0.5 -0.1)) asFloatTensor.
	matrix := #(2 3).

	self
		assert:
			(tf
				compute: shape
				feedingInputsWith:
					(Dictionary new
						at: 'x' put: scalar;
						yourself))
		isIntegerVectorEqualsTo: matrix
]

{ #category : #Test }
ShapeOperationTest >> testShapeOfRowVector [

	| scalar expectedShape |

	scalar := #(1.0 2.0) asFloatTensor.
	expectedShape := #(2).

	self assertOutputOf: (ShapeOperation of: (tf constantWith: scalar)) isIntegerVectorEqualsTo: expectedShape.
	self
		assertOutputOf: (ShapeOperation of: (tf variableNamed: 'input' with: scalar))
		isIntegerVectorEqualsTo: expectedShape.
	self
		assert: (
			tf
				compute: ((ShapeOperation of: (tf floatInputNamed: 'x')))
				feedingInputsWith: (
					Dictionary new
						at: 'x' put: scalar;
						yourself))
		isIntegerVectorEqualsTo: expectedShape
]

{ #category : #Test }
ShapeOperationTest >> testShapeOfScalar [

	| scalar expectedShape shapeOfConstant shapeOfVariable shapeOfInput |

	scalar := 1.0 asFloatTensor.
	expectedShape := #().

	shapeOfConstant := ShapeOperation of: (tf constantWith: scalar).
	shapeOfVariable := ShapeOperation of: (tf variableNamed: 'input' with: scalar).
	shapeOfInput := (ShapeOperation of: (tf floatInputNamed: 'x')).
	self assertOutputOf: shapeOfConstant isIntegerVectorEqualsTo: expectedShape.
	self assertOutputOf: shapeOfVariable isIntegerVectorEqualsTo: expectedShape.
	self
		assert: (
			tf
				compute: shapeOfInput
				feedingInputsWith: (
					Dictionary new
						at: 'x' put: scalar;
						yourself))
		isIntegerVectorEqualsTo: expectedShape
]

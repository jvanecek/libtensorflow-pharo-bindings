Extension { #name : #TensorFlowOperationAbstract }

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> * anOperation [

	^ElementWiseMultiplication of: self and: anOperation
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> + anOperation [

	^Sum of: self plus: anOperation
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> - anOperation [

	^Substraction of: self minus: anOperation
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> / anOperation [

	^ElementWiseDivision of: self and: anOperation
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> abs [

	^AbsoluteValue of: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> argMaxAcross: anAxis [

	^IndexWithMaximum in: self across: anAxis
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> argMaxOnColumns [
	" (This assumes a tensor of rank 2, i.e. matrix, to make the concept of column valid)
	For each column, applies argMax "
	^self argMaxAcross: 0
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> argMaxOnRows [
	" (This assumes a tensor of rank 2, i.e. matrix, to make the concept of row valid)
	For each row, applies argMax "
	^self argMaxAcross: 1
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> argMinAcross: anAxis [

	^IndexWithMinimum in: self across: anAxis
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> biasedBy: aBias [

	^AddBias to: self with: aBias
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> castedTo: aDataType [

	^TypeCast of: self to: aDataType
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> comparedWith: anOperation [

	^ElementWiseEquality between: self and: anOperation
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> dot: aMatrix [

	^MatrixMultiplication of: self and: aMatrix
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> dotTransposing: aMatrix [

	^MatrixMultiplication of: self andTransposed: aMatrix
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> mean [

	^ReduceMean ofValuesIn: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> meanAlongside: anAxis [

	^ReduceMean ofValuesIn: self alongside: anAxis
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> negated [

	^ElementWiseNegative of: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> raisedTo: theNthPower [

	^Exponentiation of: self raisedTo: theNthPower
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> reciprocal [

	^Reciprocal of: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> relu [

	^ReLU activating: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> reshapeFlattened [

	^self reshapeTo: self outputShape flattened
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> reshapeTo: aNewShape [

	^Reshape of: self to: aNewShape
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> shape [

	^ShapeOperation of: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> sigmoid [

	^Sigmoid activating: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> softmax [

	^Softmax activating: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> squared [

	^ElementWiseSquare of: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> sumElements [

	^ReduceSum valuesIn: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> sumElementsAlongside: anAxis [

	^ReduceSum valuesIn: self alongside: anAxis
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> tanh [

	^Tanh activating: self
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> transposedDot: aMatrix [

	^MatrixMultiplication ofTransposed: self and: aMatrix
]

{ #category : #'*TensorFlowOperationMathModel' }
TensorFlowOperationAbstract >> transposedDotTransposing: aMatrix [

	^MatrixMultiplication ofTransposed: self andTransposed: aMatrix
]

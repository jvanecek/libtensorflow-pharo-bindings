Extension { #name : #TFOperationDescription }

{ #category : #'*TensorFlowOperationMathModel' }
TFOperationDescription >> atDataTypePut: aType [

	self at: TFAttributeName dataType putType: aType
]

{ #category : #'*TensorFlowOperationMathModel' }
TFOperationDescription >> atShapePut: aShape [

	self at: TFAttributeName shape putShape: aShape
]

{ #category : #'*TensorFlowOperationMathModel' }
TFOperationDescription >> atTransposeAPut: aBoolean [

	self at: TFAttributeName transposeA putBoolean: aBoolean
]

{ #category : #'*TensorFlowOperationMathModel' }
TFOperationDescription >> atTransposeBPut: aBoolean [

	self at: TFAttributeName transposeB putBoolean: aBoolean
]

{ #category : #'*TensorFlowOperationMathModel' }
TFOperationDescription >> atValuePut: aType [

	self at: TFAttributeName value putTensor: aType
]

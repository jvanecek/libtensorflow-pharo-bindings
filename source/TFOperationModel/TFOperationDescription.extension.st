Extension { #name : #TFOperationDescription }

{ #category : #'*TFOperationModel' }
TFOperationDescription >> atDataTypePut: aType [

	self at: TFAttributeName dataType putType: aType
]

{ #category : #'*TFOperationModel' }
TFOperationDescription >> atShapePut: aShape [

	self at: TFAttributeName shape putShape: aShape
]

{ #category : #'*TFOperationModel' }
TFOperationDescription >> atTransposeAPut: aBoolean [

	self at: TFAttributeName transposeA putBoolean: aBoolean
]

{ #category : #'*TFOperationModel' }
TFOperationDescription >> atTransposeBPut: aBoolean [

	self at: TFAttributeName transposeB putBoolean: aBoolean
]

{ #category : #'*TFOperationModel' }
TFOperationDescription >> atValuePut: aType [

	self at: TFAttributeName value putTensor: aType
]

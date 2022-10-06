Extension { #name : #TFOperationDescription }

{ #category : #'*TensorFlowDatasetModel' }
TFOperationDescription >> atContainerPut: aString [

	self at: TFAttributeName container putString: aString
]

{ #category : #'*TensorFlowDatasetModel' }
TFOperationDescription >> atFieldDelimiterPut: aListOfTypes [

	self at: 'field_delim' putString: aListOfTypes
]

{ #category : #'*TensorFlowDatasetModel' }
TFOperationDescription >> atNotAvailableValuePut: aListOfTypes [

	self at: 'na_value' putString: aListOfTypes
]

{ #category : #'*TensorFlowDatasetModel' }
TFOperationDescription >> atOutputShapesPut: aListOfShapes [

	self at: TFAttributeName outputShapes putShapes: aListOfShapes
]

{ #category : #'*TensorFlowDatasetModel' }
TFOperationDescription >> atOutputTypesPut: aListOfTypes [

	self at: TFAttributeName outputTypes putTypes: aListOfTypes
]

{ #category : #'*TensorFlowDatasetModel' }
TFOperationDescription >> atSharedNamePut: aString [

	self at: TFAttributeName sharedName putString: aString
]

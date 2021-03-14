Extension { #name : #TFOperationDescription }

{ #category : #'*TFDatasetModel' }
TFOperationDescription >> atContainerPut: aString [

	self at: TFAttributeName container putString: aString
]

{ #category : #'*TFDatasetModel' }
TFOperationDescription >> atFieldDelimiterPut: aListOfTypes [

	self at: 'field_delim' putString: aListOfTypes
]

{ #category : #'*TFDatasetModel' }
TFOperationDescription >> atNotAvailableValuePut: aListOfTypes [

	self at: 'na_value' putString: aListOfTypes
]

{ #category : #'*TFDatasetModel' }
TFOperationDescription >> atOutputShapesPut: aListOfShapes [

	self at: TFAttributeName outputShapes putShapes: aListOfShapes
]

{ #category : #'*TFDatasetModel' }
TFOperationDescription >> atOutputTypesPut: aListOfTypes [

	self at: TFAttributeName outputTypes putTypes: aListOfTypes
]

{ #category : #'*TFDatasetModel' }
TFOperationDescription >> atSharedNamePut: aString [

	self at: TFAttributeName sharedName putString: aString
]

Extension { #name : #TFOperationDescription }

{ #category : #'*TFOptimizerModel' }
TFOperationDescription >> atUseNesterovPut: aBoolean [

	self at: TFAttributeName useNesterov putBoolean: aBoolean
]
